import 'package:wassapviews/libraries.dart';

class OnboardPageView extends StatelessWidget {
  String? title;
  String? description;
  String? image;
  IconData? icon;
  OnboardPageView({
    Key? key,
    this.title,
    this.description,
    this.image,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
      child: Column(
        children: <Widget>[
          Text(
            title!,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 35,
              fontFamily: 'Monserrat',
              color: Theme.of(context).accentColor,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            description!,
            style: TextStyle(
              color: GlobalVariables.isDarkMode()
                  ? AppColors.grey2
                  : AppColors.grey4,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          Expanded(
            child: GlobalVariables.isDarkMode()
                ? Container(
                    alignment: Alignment.center,
                    child: FaIcon(
                      icon!,
                      size: 100,
                      color: AppColors.grey3,
                    ),
                  )
                : Image.asset(image!),
          ),
        ],
      ),
    );
  }
}
