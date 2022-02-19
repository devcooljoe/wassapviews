import 'package:wassapviews/libraries.dart';

class HomeContactCount extends StatelessWidget {
  HomeContactCount({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 22.5, right: 22.5),
      child: Container(
        padding: const EdgeInsets.all(8),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(50),
          boxShadow: <BoxShadow>[
            BoxShadow(
              spreadRadius: 0,
              blurRadius: 1,
              color: GlobalVariables.isDarkMode() ? Colors.transparent : Colors.grey,
            )
          ],
        ),
        child: Consumer(
          builder: (context, watch, widget) {
            return Text(
              '${watch(contactCountProvider)} Contacts Compiled',
              style: TextStyle(
                color: Theme.of(context).buttonColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            );
          },
        ),
      ),
    );
  }
}
