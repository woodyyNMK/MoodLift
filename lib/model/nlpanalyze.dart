import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import './musicmodel.dart';

final String? nlptoken = dotenv.env['NLP_TOKEN'];

class SentimentAnalyzer {
  void analyzeSentiment(String text, Function updateStateCallback) async {
    try {
      final response = await http.post(
        Uri.parse(
            'https://api-inference.huggingface.co/models/cardiffnlp/twitter-roberta-base-sentiment'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $nlptoken',
        },
        body: jsonEncode(<String, dynamic>{
          'inputs': text
        }), // Ensure this matches expected format
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        double negative = 0, neutral = 0, positive = 0;
        final labelMapping = {
          'LABEL_0': 'Negative',
          'LABEL_1': 'Neutral',
          'LABEL_2': 'Positive',
        };

        for (var item in data[0]) {
          if (item['label'] == 'LABEL_0') {
            negative = (item['score'] * 100).round();
          }
          if (item['label'] == 'LABEL_1') {
            neutral = (item['score'] * 100).round();
          }
          if (item['label'] == 'LABEL_2') {
            positive = (item['score'] * 100).round();
          }
        }
        final String sentiment = labelMapping[data[0][0]['label']]!;
        updateStateCallback(sentiment, positive, neutral, negative);
        SoundManager.playSound(sentiment);
      } else {
        throw Exception('Failed to analyze sentiment');
      }
    } catch (e) {
      // Handle error
    }
  }
}
