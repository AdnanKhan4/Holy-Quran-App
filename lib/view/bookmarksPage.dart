import 'package:flutter/material.dart';
import 'package:holy_quran_app/view/surahDetailsPage.dart';
import '../model/database/database_helper.dart';

class Bookmarkspage extends StatefulWidget {
  const Bookmarkspage({super.key});

  @override
  State<Bookmarkspage> createState() => _BookmarkspageState();
}

class _BookmarkspageState extends State<Bookmarkspage> {

 ThemeMode _themeMode = ThemeMode.light;

  // Method to toggle theme mode
  void toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  List<Map<String, dynamic>> bookmarkedSurahs = [];
  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _loadBookmarks();
  }

  // Load bookmarks from the SQLite database
  void _loadBookmarks() async {
    final bookmarks = await _dbHelper.getBookmarks();
    setState(() {
      bookmarkedSurahs = bookmarks;
    });
  }

  // Remove a bookmark from the database
  void _removeBookmark(int surahNumber) async {
    await _dbHelper.removeBookmark(surahNumber);
    _loadBookmarks();
  }

 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark ? const Color.fromARGB(255, 10, 20, 40) : Colors.white,
      appBar: AppBar(
        leading: Align(
        alignment: Alignment.topLeft,
        child: IconButton(
          icon: Icon(Icons.arrow_back, color:Theme.of(context).brightness == Brightness.dark ? Colors.white: Colors.black,),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
        toolbarHeight: 150,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Bookmarks',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            Opacity(
              opacity: 0.2,
              child: Image.asset(
                'assets/images/manSalah.png',
                height: 150,
              ),
            ),
          ],
        ),
         backgroundColor: Theme.of(context).brightness == Brightness.dark ? const Color.fromARGB(255, 10, 20, 40) : Colors.white,
        elevation: 0,
      ),
      body: bookmarkedSurahs.isEmpty
          ? const Center(child: Text('No bookmarks yet.'))
          : ListView.builder(
            
              itemCount: bookmarkedSurahs.length,
              itemBuilder: (context, index) {
                final bookmark = bookmarkedSurahs[index];
                final surahName = bookmark['surahName'];
                final surahNumber = bookmark['surahNumber'];
    
                return ListTile(
                  title: Text(surahName),
                  subtitle: Text('Surah Number: $surahNumber'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      _removeBookmark(surahNumber);
                    },
                  ),
                  onTap: () async {
                    // Navigate to SurahDetailsPage
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            SurahDetailsPage(surahNumber: surahNumber),
                      ),
                    );
                    // Reload bookmarks after returning from SurahDetailsPage
                    _loadBookmarks();
                  },
                );
              },
            ),
    );
  }
}
