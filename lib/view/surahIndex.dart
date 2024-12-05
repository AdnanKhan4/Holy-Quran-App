import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:holy_quran_app/model/apis/api_handler.dart';
import 'package:holy_quran_app/model/surah_model.dart';
import 'package:holy_quran_app/view/surahDetailsPage.dart';

import '../model/database/database_helper.dart';

class SurahIndexPage extends StatefulWidget {
  const SurahIndexPage({super.key});

  @override
  SurahIndexPageState createState() => SurahIndexPageState();
}

class SurahIndexPageState extends State<SurahIndexPage> {
  late Future<List<Surah>> _surahList;
  List<Surah> _allSurahs = [];
  List<Surah> _filteredSurahs = [];
  final TextEditingController _searchController = TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterSurahs);
    _surahList = _fetchSurahs();
  }

  Future<List<Surah>> _fetchSurahs() async {
    List<Surah> surahsFromDB = await _dbHelper.getSurahs();
    if (surahsFromDB.isEmpty) {
      // Fetch from API if database is empty
      List<Surah> surahsFromApi = await APIHandler.fetchSurahs();
      for (var surah in surahsFromApi) {
        await _dbHelper.insertSurah(surah);
      }
      setState(() {
        _allSurahs = surahsFromApi;
        _filteredSurahs = surahsFromApi;
      });
      return surahsFromApi;
    } else {
      setState(() {
        _allSurahs = surahsFromDB;
        _filteredSurahs = surahsFromDB;
      });
      return surahsFromDB;
    }
  }

  void _filterSurahs() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredSurahs = _allSurahs;
      } else if (int.tryParse(query) != null) {
        // Handle numeric search logic if necessary
      } else {
        _filteredSurahs = _allSurahs.where((surah) {
          return surah.englishName.toLowerCase().contains(query) ||
              surah.englishNameTranslation.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 150,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Surah Index',
                style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey)),
            Opacity(
              opacity: 0.2,
              child: Image.asset(
                'assets/images/Kaaba.png',
                height: 150,
              ),
            ),
          ],
        ),
        leading: Align(
          alignment: Alignment.topLeft,
          child: IconButton(
            icon: Icon(Icons.arrow_back,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? const Color.fromARGB(255, 10, 20, 40)
            : Colors.white,
        elevation: 0,
      ),
      body: Container(
        color: Theme.of(context).brightness == Brightness.dark
            ? const Color.fromARGB(255, 10, 20, 40)
            : Colors.white,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Search Surah...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                  hintStyle: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                ),
                cursorColor: Colors.grey,
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Surah>>(
                future: _surahList,
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
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No Surahs found'));
                  } else {
                    return ListView.builder(
                      itemCount: _filteredSurahs.length,
                      itemBuilder: (context, index) {
                        Surah surah = _filteredSurahs[index];
                        return ListTile(
                          title: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: '${surah.number}  ',
                                  style: TextStyle(
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                                TextSpan(
                                  text: surah.englishName,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          subtitle: Text(surah.englishNameTranslation),
                          trailing: Text(
                            surah.name,
                            style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Amiri'),
                          ),
                          onTap: () {
                            // Navigate to SurahDetailsPage
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    SurahDetailsPage(surahNumber: surah.number),
                              ),
                            );
                          },
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
