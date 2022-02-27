import 'package:wassapviews/libraries.dart';

List<OnboardPageView> onboardList = <OnboardPageView>[
  OnboardPageView(
    title: GlobalVariables.getString(4),
    description: GlobalVariables.getString(5),
    image: 'assets/onboard/views.png',
    icon: FontAwesomeIcons.whatsapp,
  ),
  OnboardPageView(
    title: GlobalVariables.getString(6),
    description: GlobalVariables.getString(7),
    image: 'assets/onboard/download.png',
    icon: FontAwesomeIcons.download,
  ),
  OnboardPageView(
    title: GlobalVariables.getString(8),
    description: GlobalVariables.getString(9),
    image: 'assets/onboard/sort.png',
    icon: FontAwesomeIcons.sortAlphaUp,
  ),
];
