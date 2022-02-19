import 'package:flutter/cupertino.dart';
import 'package:wassapviews/libraries.dart';

class HomeScreenCard extends StatelessWidget {
  IconData icon;
  String title;
  String description;
  String btnTitle;
  Widget nextScreen;
  HomeScreenCard(
      {Key? key,
      required this.icon,
      required this.title,
      required this.description,
      required this.btnTitle,
      required this.nextScreen})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Container(
        padding: const EdgeInsets.all(20),
        width: MediaQuery.of(context).size.width * 0.75,
        color: Theme.of(context).primaryColorDark,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            FaIcon(
              icon,
              color: Theme.of(context).accentColor,
              size: 50,
            ),
            const SizedBox(height: 15),
            Text(
              title,
              style: TextStyle(
                color: Theme.of(context).buttonColor,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              description,
              style: TextStyle(
                color: Theme.of(context).shadowColor,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (BuildContext context) {
                      return nextScreen;
                    },
                  ),
                );
              },
              child: Text(btnTitle),
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.resolveWith(
                  (states) => Theme.of(context).accentColor,
                ),
                overlayColor: MaterialStateProperty.resolveWith(
                  (states) => GlobalVariables.isDarkMode()
                      ? AppColors.darkModeTransparentGreen
                      : AppColors.lightModeTransparentGreen,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
