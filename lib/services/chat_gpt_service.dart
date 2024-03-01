import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:web_task/services/shared_prefs.dart';

class ChatGPTService {
  static Future<Map<String, String>> getResponse(String prompt, key) async {
    List<Map<String, dynamic>> messages = await SharedPrefs.getCachedMessages();

    messages.add({
      'role': 'user',
      'content': prompt,
    });
    try {
      final res = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $key',
        },
        body: jsonEncode({"model": "gpt-3.5-turbo", "messages": messages}),
      );
      if (res.statusCode == 200) {
        String content =
            jsonDecode(res.body)['choices'][0]['message']['content'];
        content = content.trim();

        messages.add({
          'role': 'assistant',
          'content': content,
        });
        await SharedPrefs.storeCachedMessage({
          'role': 'assistant',
          'content': content,
        });
        return {'result': content};
      } else if (res.statusCode > 399 && res.statusCode < 500) {
        String error = jsonDecode(res.body)['error']['message'];
        return {
          'result': 'nulll',
          'error': error,
        };
      }
      return {
        'result': 'nulll',
        'error': 'An internal error occurred',
      };
    } catch (e) {
      return {
        'result': 'nulll',
        'error': e.toString(),
      };
    }
  }
}
