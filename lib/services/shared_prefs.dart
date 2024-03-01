import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  // Use code below for cubit

  static Future<List<Map<String, dynamic>>> getStoredMessages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final storedMessages = prefs.getStringList('messages');
    if (storedMessages != null) {
      return storedMessages
          .map<Map<String, dynamic>>((jsonString) => jsonDecode(jsonString))
          .toList();
    }
    return [];
  }

  static Future<void> storeMessage(Map<String, dynamic> message) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> storedMessages = prefs.getStringList('messages') ?? [];
    storedMessages.add(jsonEncode(message));
    await prefs.setStringList('messages', storedMessages);
  }

  static Future<void> clearMessages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  // Use code below for service

  static Future<List<Map<String, dynamic>>> getCachedMessages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final storedMessages = prefs.getStringList('cached_messages');
    if (storedMessages != null) {
      return storedMessages
          .map<Map<String, dynamic>>((jsonString) => jsonDecode(jsonString))
          .toList();
    }
    return [];
  }

  static Future<void> storeCachedMessage(Map<String, dynamic> message) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> storedMessages = prefs.getStringList('cached_messages') ?? [];
    storedMessages.add(jsonEncode(message));
    await prefs.setStringList('cached_messages', storedMessages);
  }
}
