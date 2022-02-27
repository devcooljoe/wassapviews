import 'package:wassapviews/libraries.dart';

List<Widget> cardList = <Widget>[
  HomeContactCount(),
  Consumer(builder: (context, watch, widget) {
    return HomeScreenCard(
      icon: FontAwesomeIcons.solidPaperPlane,
      title: appLang[watch(langProvider) as String]![21],
      description: appLang[watch(langProvider) as String]![22],
      btnTitle: appLang[watch(langProvider) as String]![23],
      nextScreen: SubmitContactScreen(),
    );
  }),
  Consumer(builder: (context, watch, widget) {
    return HomeScreenCard(
      icon: FontAwesomeIcons.download,
      title: appLang[watch(langProvider) as String]![24],
      description: appLang[watch(langProvider) as String]![25],
      btnTitle: appLang[watch(langProvider) as String]![26],
      nextScreen: GetVcfScreen(),
    );
  }),
];
