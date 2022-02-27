import 'package:wassapviews/libraries.dart';

class LoadingDialog extends StatelessWidget {
  LoadingDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      color: Colors.transparent,
      child: AlertDialog(
        content: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 10, bottom: 10),
              child: CircularProgressIndicator(color: Theme.of(context).accentColor),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 20, top: 10, bottom: 10),
              child: Text('Loading...'),
            ),
          ],
        ),
      ),
    );
  }
}

class InternetDialog extends StatelessWidget {
  Function()? onCancel = null;
  InternetDialog({Key? key, this.onCancel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.transparentBlack,
      child: AlertDialog(
        title: Text('Connection Error'),
        content: Text('No internet connection detected. Turn on your mobile data or Wifi!'),
      ),
    );
  }
}

class LoadingPage extends StatelessWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      color: Theme.of(context).backgroundColor,
      child: AlertDialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(color: Theme.of(context).accentColor),
            const Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text('Please wait...'),
            ),
          ],
        ),
      ),
    );
  }
}

class ReloadScreen extends StatelessWidget {
  Function()? onPressed;
  ReloadScreen({Key? key, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      color: Theme.of(context).backgroundColor,
      child: AlertDialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            OutlinedButton(
              onPressed: onPressed,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[
                    Icon(Icons.refresh),
                    SizedBox(width: 3),
                    Text('Try again'),
                  ],
                ),
              ),
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.resolveWith(
                  (states) => Theme.of(context).accentColor,
                ),
                overlayColor: MaterialStateProperty.resolveWith(
                  (states) => GlobalVariables.isDarkMode() ? AppColors.darkModeTransparentGreen : AppColors.lightModeTransparentGreen,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
