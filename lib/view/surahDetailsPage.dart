import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:holy_quran_app/model/apis/api_handler.dart';
import '../model/database/database_helper.dart';

class SurahDetailsPage extends StatefulWidget {
  final int surahNumber;

  const SurahDetailsPage({super.key, required this.surahNumber});

  @override
  _SurahDetailsPageState createState() => _SurahDetailsPageState();
}

class _SurahDetailsPageState extends State<SurahDetailsPage> {
  late Future<Map<String, dynamic>> _surahDetails;
  List<Map<String, dynamic>> bookmarkedSurahs = [];
  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _surahDetails = APIHandler.fetchSurahDetails(widget.surahNumber);
    _loadBookmarks();
  }

  // Load bookmarked Surahs from SQLite
  void _loadBookmarks() async {
    final bookmarks = await _dbHelper.getBookmarks();
    setState(() {
      bookmarkedSurahs = bookmarks;
    });
  }

  // Check if the current Surah is bookmarked
  bool _isBookmarked(String surahName, int surahNumber) {
    return bookmarkedSurahs.any((bookmark) =>
        bookmark['surahName'] == surahName &&
        bookmark['surahNumber'] == surahNumber);
  }

  // Toggle bookmark for a specific Surah
  void _toggleBookmark(String surahName, int surahNumber) async {
    if (_isBookmarked(surahName, surahNumber)) {
      // If already bookmarked, remove it
      await _dbHelper.removeBookmark(surahNumber);
    } else {
      // Otherwise, add it to the bookmarks
      await _dbHelper.insertBookmark(surahNumber, surahName);
    }
    _loadBookmarks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? const Color.fromARGB(255, 10, 20, 40)
            : Colors.white,
        actions: [
          FutureBuilder<Map<String, dynamic>>(
            future: _surahDetails,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container();
              } else if (snapshot.hasData) {
                final surah = snapshot.data!;
                final String surahName = surah['name'];

                return IconButton(
                  icon: Icon(
                    _isBookmarked(surahName, widget.surahNumber)
                        ? Icons.bookmark
                        : Icons.bookmark_outline,
                  ),
                  onPressed: () {
                    _toggleBookmark(surahName, widget.surahNumber);
                  },
                );
              }
              return Container();
            },
          ),
        ],
      ),
      body: Container(
        color: Theme.of(context).brightness == Brightness.dark
            ? const Color.fromARGB(255, 10, 20, 40)
            : Colors.white,
        child: FutureBuilder<Map<String, dynamic>>(
          future: _surahDetails,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: SpinKitWaveSpinner(
                  color: Colors.blue,
                  size: 50.0,
                  waveColor: Colors.blue,
                ),
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return const Center(child: Text('No details found'));
            } else {
              final surah = snapshot.data!;
              final List<dynamic> ayahs = surah['ayahs'];

              return Stack(
                children: [
                  // Background image (Quran)
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.center,
                      child: Opacity(
                        opacity: 0.1,
                        child: Image.asset(
                          'assets/images/Quranwithtray.png',
                          width: 300,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),

                  // Content on top of the background
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Column(
                          children: [
                            Text(
                              surah['englishNameTranslation'],
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              surah['name'],
                              style: const TextStyle(
                                  fontSize: 35, fontWeight: FontWeight.w900),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              surah['englishName'],
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: ListView.builder(
                          itemCount: ayahs.length,
                          itemBuilder: (context, index) {
                            final ayah = ayahs[index];
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      ayah['text'],
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontFamily: 'Amiri',
                                        height: 2,
                                      ),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Container(
                                    margin: const EdgeInsets.only(right: 10),
                                    child: CircleAvatar(
                                      backgroundColor: Colors.grey[300],
                                      foregroundColor: Colors.black,
                                      radius: 14,
                                      child: Text(
                                        '${ayah['numberInSurah']}',
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
