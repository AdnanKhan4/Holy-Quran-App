import 'package:flutter/material.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
import 'main.dart';
import 'view/homeScreen.dart';
import 'package:provider/provider.dart';

class OnboardingSplashscreen extends StatefulWidget {
  const OnboardingSplashscreen({super.key});

  @override
  State<OnboardingSplashscreen> createState() => _OnboardingSplashscreenState();
}

class _OnboardingSplashscreenState extends State<OnboardingSplashscreen> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    Color backgroundColor = Theme.of(context).brightness == Brightness.dark
        ? const Color.fromARGB(255, 10, 20, 40)
        : Colors.white;

    return OnBoardingSlider(
      finishButtonText: '✓',
      onFinish: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(
              toggleTheme: themeProvider.toggleTheme,
              isDarkMode: themeProvider.themeMode == ThemeMode.dark,
            ),
          ),
        );
      },
      skipTextButton: const Text(
        'Skip',
        style: TextStyle(
          fontSize: 16,
          color: Colors.blue,
        ),
      ),
      skipFunctionOverride: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(
              toggleTheme: themeProvider.toggleTheme,
              isDarkMode: themeProvider.themeMode == ThemeMode.dark,
            ),
          ),
        );
      },
      finishButtonStyle: const FinishButtonStyle(
        backgroundColor: Colors.blue,
        shape: CircleBorder(
          side: BorderSide.none,
        ),
        elevation: 5,
      ),
      trailing: const Text(
        'Skip',
        style: TextStyle(
          fontSize: 16,
          color: Colors.blue,
        ),
      ),
      trailingFunction: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(
              toggleTheme: themeProvider.toggleTheme,
              isDarkMode: themeProvider.themeMode == ThemeMode.dark,
            ),
          ),
        );
      },
      controllerColor: Colors.blue,
      totalPage: 3,
      headerBackgroundColor: backgroundColor,
      pageBackgroundColor: backgroundColor,
      background: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.only(top: 100),
            child: Center(
              child: Image.asset(
                'assets/images/alQuranText.png',
                height: 300,
              ),
            ),
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.only(top: 100),
            child: Center(
              child: Image.asset(
                'assets/images/alQuranText.png',
                height: 300,
              ),
            ),
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.only(top: 100),
            child: Center(
              child: Image.asset(
                'assets/images/alQuranText.png',
                height: 300,
              ),
            ),
          ),
        ),
      ],
      speed: 1.8,
      pageBodies: [
        Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: const Column(
            children: <Widget>[
              SizedBox(
                height: 480,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "The Holy Qu'ran",
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    '"Indeed, It is We who sent down\n the القُرْآن and indeed, We will\n be its Guardian"',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 480,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "With sleek & awesome User\nInterface to keep you in love with\nthis amazing app and the Book.",
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Hope you will like our efforts!',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 480,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Now with Surah & Juz Index you\ncan find your required Surahs &\nJuzs easily.",
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'With Bookmark option you can\naccess your readings.',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
