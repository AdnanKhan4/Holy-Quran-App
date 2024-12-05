import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:holy_quran_app/model/apis/api_handler.dart';

class JuzDetailPage extends StatelessWidget {
  final int juzNumber;

  // List of Arabic Juz names
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

  JuzDetailPage({super.key, required this.juzNumber});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? const Color.fromARGB(255, 10, 20, 40)
            : Colors.white,
      ),
      body: Container(
        color: Theme.of(context).brightness == Brightness.dark
            ? const Color.fromARGB(255, 10, 20, 40)
            : Colors.white,
        child: FutureBuilder<Map<String, dynamic>>(
          future: APIHandler.fetchJuz(juzNumber),
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
            } else if (snapshot.hasData) {
              // Display the Juz details
              Map<String, dynamic> juzData = snapshot.data!;
              List<dynamic> ayahs = juzData['ayahs'];

              return Stack(
                children: [
                  // Background image
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.center,
                      child: Opacity(
                        opacity: 0.1,
                        child: Image.asset(
                          'assets/images/Quranwithtray.png',
                          fit: BoxFit.cover,
                          width: 300,
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
                            // Juz Arabic Name
                            const Text(
                              'بِسۡمِ ٱللَّهِ ٱلرَّحۡمَـٰنِ ٱلرَّحِیمِ',
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              juzArabicNames[juzNumber - 1],
                              style: const TextStyle(
                                  fontSize: 30,
                                  fontFamily: 'Amiri',
                                  fontWeight: FontWeight.w900),
                            ),
                            const SizedBox(
                              height: 20,
                            ),

                            // Display Juz Name and Juz Number
                            Text(
                              'Juz No.$juzNumber',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Expanded list of Ayahs
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
            } else {
              return const Center(child: Text('No data available'));
            }
          },
        ),
      ),
    );
  }
}
