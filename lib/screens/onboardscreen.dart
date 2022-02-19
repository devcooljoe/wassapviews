import 'package:flutter/cupertino.dart';
import 'package:wassapviews/libraries.dart';

class OnboardScreen extends StatelessWidget {
  const OnboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PageController _pageController = PageController(initialPage: 0);
    int _currentPage = 0;
    OnboardScreenController _onboardController = context.read(onboardScreenProvider.notifier);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(bottom: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              child: PageView(
                onPageChanged: (page) {
                  _currentPage = page;
                  _onboardController.setPage(page);
                },
                controller: _pageController,
                physics: const BouncingScrollPhysics(),
                children: onboardList.map((e) => e).toList(),
              ),
            ),
            const SizedBox(height: 10),
            SmoothPageIndicator(
              controller: _pageController,
              count: 3,
              effect: WormEffect(
                dotHeight: 5,
                dotWidth: 30,
                dotColor: GlobalVariables.isDarkMode() ? AppColors.grey4 : AppColors.grey2,
                activeDotColor: Theme.of(context).accentColor,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 50),
        child: FloatingActionButton(
          backgroundColor: GlobalVariables.isDarkMode() ? AppColors.darkModeGreen : AppColors.lightModeGreen,
          foregroundColor: AppColors.white,
          child: Consumer(builder: (context, watch, widget) {
            return Icon(
              (watch(onboardScreenProvider) as int) == 2 ? Icons.check : Icons.chevron_right,
              size: 30,
            );
          }),
          onPressed: () {
            if (_currentPage + 1 > 2) {
              UserSharedPreferences.setFirstLaunch('false');
              GlobalVariables.firstLaunch = 'false';
              Navigator.pushReplacement(
                context,
                CupertinoPageRoute(
                  builder: (BuildContext context) => HomeScreen(),
                ),
              );
            } else {
              _onboardController.setPage(_currentPage);
              _pageController.animateToPage(_currentPage + 1, duration: const Duration(milliseconds: 500), curve: Curves.ease);
            }
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
