import 'package:wassapviews/libraries.dart';

class CustomTextButton extends StatelessWidget {
  String text;
  Function() onPressed;
  CustomTextButton({Key? key, required this.text, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          color: Theme.of(context).buttonColor,
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
    );
  }
}
