import 'package:wassapviews/libraries.dart';

class CustomPhoneInput extends StatelessWidget {
  PhoneNumber? initialValue;
  Function(PhoneNumber)? onInputChanged;
  Function(PhoneNumber)? onSaved;
  CustomPhoneInput({
    Key? key,
    this.initialValue,
    required this.onInputChanged,
    this.onSaved,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, watch, widget) {
      return InternationalPhoneNumberInput(
        initialValue: initialValue,
        formatInput: true,
        spaceBetweenSelectorAndTextField: 0,
        textStyle: const TextStyle(fontSize: 20),
        countrySelectorScrollControlled: false,
        onInputChanged: onInputChanged,
        cursorColor: Theme.of(context).accentColor,
        selectorConfig: const SelectorConfig(
          selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
          useEmoji: true,
          showFlags: true,
          trailingSpace: false,
        ),
        inputDecoration: InputDecoration(
          labelText: appLang[watch(langProvider) as String]![36],
          floatingLabelStyle: TextStyle(
            color: GlobalVariables.isDarkMode() ? AppColors.grey4 : AppColors.grey6,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 2,
              color: Theme.of(context).accentColor,
            ),
          ),
        ),
        keyboardType: TextInputType.phone,
        searchBoxDecoration: InputDecoration(
          labelText: 'Search with country name or code',
          floatingLabelStyle: TextStyle(
            color: GlobalVariables.isDarkMode() ? AppColors.grey4 : AppColors.grey6,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 2,
              color: Theme.of(context).accentColor,
            ),
          ),
        ),
        onSaved: onSaved,
      );
    });
  }
}

class CustomTextField extends StatelessWidget {
  String? initialValue;
  String? labelText;
  String? hintText;
  TextInputType? inputType;
  String? Function(String?)? validator;
  Function(String?)? onSaved;
  CustomTextField({
    Key? key,
    this.inputType,
    this.initialValue,
    this.validator,
    this.onSaved,
    this.labelText,
    this.hintText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: inputType,
      initialValue: initialValue,
      cursorColor: Theme.of(context).accentColor,
      style: const TextStyle(fontSize: 20),
      decoration: InputDecoration(
        labelText: labelText,
        floatingLabelStyle: TextStyle(
          color: GlobalVariables.isDarkMode() ? AppColors.grey4 : AppColors.grey6,
        ),
        hintText: hintText,
        contentPadding: const EdgeInsets.symmetric(horizontal: 6),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 2,
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
      validator: validator,
      onSaved: onSaved,
    );
  }
}
