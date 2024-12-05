import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:holy_quran_app/model/apis/api_handler.dart';
import 'package:holy_quran_app/view/juzDetailsPage.dart';

class JuzIndexPage extends StatefulWidget {
  const JuzIndexPage({super.key});

  @override
  _JuzIndexPageState createState() => _JuzIndexPageState();
}

class _JuzIndexPageState extends State<JuzIndexPage> {
  List<int> juzList = [];
  List<int> filteredJuzList = [];
  final TextEditingController _searchController = TextEditingController();

  final List<String> juzArabicNames = [
    'أَلِمُ',
    'سَيَقُولُ',
    'تِلْكَ ٱلرُّسُل',
    'لَنْ تَنَالُواْ',
    'وَٱلْمُحْصَنَات',
    'لَا يُحِبُّ ٱللَّهُ',
    'وَإِذَا سَمِعُواْ',
    'وَلَوْ أَنَّنَا',
    'قَدْ أَفْلَحَ',
    'وَٱعْلَمُواْ',
    'يَعْتَذِرُونَ',
    'وَمَا مِنْ دَآبَّةٍ',
    'وَمَا أُبَرِّئُ',
    'رُبَمَا',
    'سُبْحَانَ ٱلَّذِي',
    'قَالَ أَلَمْ',
    'ٱقْتَرَبَ لِلنَّاسِ',
    'قَدْ أَفْلَحَ',
    'وَقَالَ ٱلَّذِينَ',
    'أَمَّنْ خَلَقَ',
    'أُتْلُ مَا أُوحِيَ',
    'وَمَنْ يَقْنُتْ',
    'وَمَآ لي',
    'فَمَنْ أَظْلَمُ',
    'إِلَيْهِ يُرَدُّ',
    'حم',
    'قَالَ فَمَا خَطْبُكُمْ',
    'قَدْ أَفْلَحَ',
    'تَبَارَكَ ٱلَّذِي',
    'عَمَّ يَتَسَآءَلُونَ'
  ];

  @override
  void initState() {
    super.initState();
    fetchJuzList();

    _searchController.addListener(() {
      filterJuzList();
    });
  }

  Future<void> fetchJuzList() async {
    try {
      List<int> fetchedJuzList = await APIHandler.fetchAllJuzNumbers();
      setState(() {
        juzList = fetchedJuzList;
        filteredJuzList = fetchedJuzList;
      });
    } catch (error) {
      print('Error fetching Juz list: $error');
    }
  }

  void filterJuzList() {
    String query = _searchController.text;
    setState(() {
      filteredJuzList = query.isEmpty
          ? juzList
          : juzList.where((juz) => juz.toString().contains(query)).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 150,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Juzz Index',
                style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey)),
            Opacity(
              opacity: 0.2,
              child: Image.asset(
                'assets/images/Quranwithtray.png',
                height: 150,
              ),
            ),
          ],
        ),
        leading: Align(
          alignment: Alignment.topLeft,
          child: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
            ),
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
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Search Juz Number here...',
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
              child: filteredJuzList.isEmpty
                  ? const Center(
                      child: SpinKitWaveSpinner(
                        color: Colors.blue,
                        size: 50.0,
                        waveColor: Colors.blue,
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 10.0,
                          childAspectRatio: 1.0,
                        ),
                        itemCount: filteredJuzList.length,
                        itemBuilder: (context, index) {
                          int juzNumber = filteredJuzList[index];
                          String juzArabicName = juzArabicNames[juzNumber - 1];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      JuzDetailPage(juzNumber: juzNumber),
                                ),
                              );
                            },
                            child: Card(
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? const Color.fromARGB(255, 5, 27, 68)
                                  : Colors.grey[70],
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      juzArabicName,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? Colors.white38
                                            : Colors.grey[700],
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      '$juzNumber',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? Colors.white38
                                            : Colors.grey[700],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
