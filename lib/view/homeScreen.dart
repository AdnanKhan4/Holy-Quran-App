import 'dart:io';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:holy_quran_app/customWidgets/buttons.dart';
import 'package:holy_quran_app/onboarding_splashscreen.dart';
import 'package:holy_quran_app/view/bookmarksPage.dart';
import 'package:holy_quran_app/view/juzIndex.dart';
import 'package:holy_quran_app/view/surahIndex.dart';

class HomeScreen extends StatefulWidget {
  final Function toggleTheme;
  final bool isDarkMode;
  const HomeScreen(
      {super.key, required this.toggleTheme, required this.isDarkMode});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final advancedrawerController = AdvancedDrawerController();

  void drawerControl() {
    advancedrawerController.showDrawer();
  }

  ThemeMode _themeMode = ThemeMode.light;

  // Toggle theme between light and dark mode
  void toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          await AwesomeDialog(
            context: context,
            dialogType: DialogType.question,
            animType: AnimType.bottomSlide,
            title: 'Exit Application',
            desc: 'Are you sure you want to exit?',
            btnCancelOnPress: () {},
            btnOkOnPress: () {
              exit(0);
            },
          ).show();
          return false;
        },
        child: AdvancedDrawer(
          childDecoration:
              BoxDecoration(borderRadius: BorderRadius.circular(50)),
          rtlOpening: false,
          animationDuration: const Duration(milliseconds: 600),
          animationCurve: Curves.easeIn,
          controller: advancedrawerController,
          backdrop: Container(
            decoration: BoxDecoration(
              gradient: widget.isDarkMode
                  ? const LinearGradient(
                      colors: [
                        Color.fromARGB(255, 10, 20, 40),
                        Color.fromARGB(255, 4, 63, 134),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : const LinearGradient(
                      colors: [
                        Color.fromARGB(255, 34, 113, 241),
                        Color.fromARGB(255, 169, 216, 255)
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
            ),
          ),
          drawer: SafeArea(
            child: Column(
              children: <Widget>[
                DrawerHeader(
                    child: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: const TextSpan(
                                children: [
                                  TextSpan(
                                    text: "The\n",
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontFamily: "Poppins"),
                                  ),
                                  TextSpan(
                                    text: "Holy\nQur'an",
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontFamily: "Poppins"),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Image.asset(
                          'assets/images/alQuranTextwhite.png',
                          height: 110,
                        ),
                      ),
                    ],
                  ),
                )),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: <Widget>[
                      ListTile(
                        leading: const Icon(
                          Icons.menu_outlined,
                          color: Colors.white,
                        ),
                        title: const Text(
                          'Surah Index',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SurahIndexPage()),
                          );
                        },
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.calendar_month_outlined,
                          color: Colors.white,
                        ),
                        title: const Text(
                          'Juz Index',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => JuzIndexPage()),
                          );
                        },
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.menu_book_outlined,
                          color: Colors.white,
                        ),
                        title: const Text(
                          'Bookmarks',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Bookmarkspage()),
                          );
                        },
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.info_outline,
                          color: Colors.white,
                        ),
                        title: const Text(
                          'Introduction',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const OnboardingSplashscreen()),
                          );
                        },
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.share,
                          color: Colors.white,
                        ),
                        title: const Text(
                          'Share App',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        onTap: () {},
                      ),
                      ListTile(
                        leading: Icon(
                          widget.isDarkMode
                              ? Icons.light_mode_outlined
                              : Icons.dark_mode_outlined,
                          color: Colors.white,
                        ),
                        title: Text(
                          widget.isDarkMode ? 'Light Mode' : 'Dark Mode',
                          style: const TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          widget.toggleTheme();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          child: ValueListenableBuilder<AdvancedDrawerValue>(
            valueListenable: advancedrawerController,
            builder: (context, value, child) {
              return Scaffold(
                body: Builder(builder: (context) {
                  return Container(
                    color: widget.isDarkMode
                        ? const Color.fromARGB(255, 10, 20, 40)
                        : Theme.of(context).colorScheme.surface,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 40),
                            child: IconButton(
                              icon: SvgPicture.asset(
                                'assets/icons/4dotsmenu.svg',
                                height: 24.0,
                                width: 24.0,
                              ),
                              onPressed: () {
                                drawerControl();
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              Column(
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "The\n",
                                          style: TextStyle(
                                            fontSize: 25,
                                            color: widget.isDarkMode
                                                ? Colors.white38
                                                : Colors.black38,
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                        TextSpan(
                                          text: "Holy\nQur'an",
                                          style: TextStyle(
                                            fontSize: 35,
                                            fontWeight: FontWeight.bold,
                                            color: widget.isDarkMode
                                                ? Colors.white38
                                                : Colors.black38,
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              const Spacer(),
                              Image.asset(
                                'assets/images/alQuranText.png',
                                height: 150,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Column(
                          children: [
                            CustomButton(
                                text: "Surah Index",
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const SurahIndexPage()),
                                  );
                                }),
                            const SizedBox(height: 10),
                            CustomButton(
                                text: "Juz Index",
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => JuzIndexPage()),
                                  );
                                }),
                            const SizedBox(
                              height: 10,
                            ),
                            CustomButton(
                                text: "Bookmarks",
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const Bookmarkspage()),
                                  );
                                }),
                          ],
                        ),
                        Stack(
                          children: [
                            Opacity(
                                opacity: 0.2,
                                child: Image.asset(
                                  'assets/images/Quranwithtray.png',
                                  height: 300,
                                )),
                            const Positioned(
                              top: 220,
                              left: 0,
                              right: 0,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    '"Indeed, It is We who sent down the Qur\'an\nand indeed, We will be its Guardian"',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 13,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'Surah Al-Hijr',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                }),
              );
            },
          ),
        ));
  }
}
