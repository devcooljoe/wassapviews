import 'package:wassapviews/libraries.dart';

class ThemeDialog extends StatelessWidget {
  const ThemeDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text(
        GlobalVariables.getString(0),
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      children: <int>[0, 1, 2]
          .map(
            (e) => Consumer(
              builder: (context, watch, widget) => RadioListTile<int>(
                value: e,
                groupValue: watch(radioValueProvider) as int,
                onChanged: (int? value) async {
                  if (value != null) {
                    RadioValueController _radioValueController =
                        context.read(radioValueProvider.notifier);
                    _radioValueController.setRadioValue(value);
                    await UserSharedPreferences.setTheme(
                      GlobalVariables.generateThemeFromRadioVal(
                        value,
                      ),
                    );
                    GlobalVariables.theme =
                        GlobalVariables.generateThemeFromRadioVal(value);
                  }
                  Phoenix.rebirth(context);
                },
                title: Text(
                  GlobalVariables.getString(e + 1),
                  style: TextStyle(
                    color: Theme.of(context).buttonColor,
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
