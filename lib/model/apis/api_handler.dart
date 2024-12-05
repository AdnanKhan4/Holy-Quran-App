import 'dart:convert';
import 'package:holy_quran_app/model/surah_model.dart';
import 'package:http/http.dart' as http;

class APIHandler {
  // Surah API
  static const String surahApi = 'https://api.alquran.cloud/v1/surah';

  // Juz API base URL
  static const String juzApi = 'https://api.alquran.cloud/v1/juz/';

  // Fetch Surahs from API
  static Future<List<Surah>> fetchSurahs() async {
    try {
      final response = await http.get(Uri.parse(surahApi));

      if (response.statusCode == 200) {
        // Parse the JSON data
        final Map<String, dynamic> jsonData = json.decode(response.body);
        List<dynamic> surahData = jsonData['data'];

        // Convert JSON to List<Surah>
        List<Surah> surahs = surahData.map((surah) {
          return Surah.fromJson(surah);
        }).toList();

        return surahs;
      } else {
        throw Exception('Failed to load Surahs');
      }
    } catch (error) {
      throw Exception('Error fetching Surahs: $error');
    }
  }

  // Fetch Surah Details from API
  static Future<Map<String, dynamic>> fetchSurahDetails(int number) async {
    try {
      final response = await http
          .get(Uri.parse('https://api.alquran.cloud/v1/surah/$number'));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return jsonData['data'];
      } else {
        throw Exception('Failed to load surah details');
      }
    } catch (error) {
      throw Exception('Error fetching surah details: $error');
    }
  }

  // Fetch Juz based on the Juz number
  static Future<Map<String, dynamic>> fetchJuz(int number) async {
    try {
      final response = await http.get(Uri.parse('$juzApi$number'));

      if (response.statusCode == 200) {
        // Parse the JSON data
        final Map<String, dynamic> jsonData = json.decode(response.body);
        return jsonData['data'];
      } else {
        throw Exception('Failed to load Juz');
      }
    } catch (error) {
      throw Exception('Error fetching Juz: $error');
    }
  }

  // Fetch all Juz (1 to 30) without ayah details
  static Future<List<int>> fetchAllJuzNumbers() async {
    try {
      List<int> juzList = [];
      for (int i = 1; i <= 30; i++) {
        juzList.add(i);
      }
      return juzList;
    } catch (error) {
      throw Exception('Error fetching Juz numbers: $error');
    }
  }
}
