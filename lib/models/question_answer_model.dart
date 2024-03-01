class QuestionAnswerModel {
  final String question;
  final StringBuffer answer;

  QuestionAnswerModel({
    required this.question,
    required this.answer,
  });

  QuestionAnswerModel copyWith({
    String? newQuestion,
    StringBuffer? newAnswer,
  }) {
    return QuestionAnswerModel(
      question: newQuestion ?? question,
      answer: newAnswer ?? answer,
    );
  }
}
