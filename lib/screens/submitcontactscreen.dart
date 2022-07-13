import 'package:flutter/cupertino.dart';
import 'package:wassapviews/libraries.dart';
import 'package:wassapviews/widgets/others.dart';

class SubmitContactScreen extends StatelessWidget {
  SubmitContactScreen({Key? key}) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  PhoneNumber _phoneNumber = PhoneNumber();
  String _name = '';

  bool _validateForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!UserSharedPreferences.getWatchedVideo()!) {
      Future.delayed(
          Duration(milliseconds: 500),
          () => showDialog(
                barrierDismissible: false,
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: Text('Watch Video Tutorial?'),
                  content: Text('Click the Yes button to learn how to use Wassapviews Application.'),
                  actions: [
                    CustomTextButton(
                        text: 'No',
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                    CustomTextButton(
                        text: 'Yes',
                        onPressed: () async {
                          Navigator.pop(context);
                          UserSharedPreferences.setWatchedVideo(true);
                          String url = 'https://www.youtube.com/watch?v=fiIu4c1gfx8';
                          if (await canLaunchUrl(Uri.parse(url))) {
                            await launchUrl(Uri.parse(url));
                          } else {
                            throw 'Could not launch $url';
                          }
                        }),
                  ],
                ),
              ));
    }
    return Scaffold(
      appBar: AppBar(
        title: AppTitleName(),
      ),
      body: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height * 0.6,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Theme.of(context).accentColor,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(100.0),
                bottomRight: Radius.circular(5.0),
                topRight: Radius.circular(50.0),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(10),
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(top: 40),
                  // height: 70,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0),
                    ),
                  ),
                  child: Consumer(builder: (context, watch, widget) {
                    return Text(
                      appLang[watch(langProvider) as String]![27],
                      style: TextStyle(
                        color: GlobalVariables.isDarkMode() ? AppColors.white : AppColors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    );
                  }),
                ),
                Container(
                  padding: const EdgeInsets.only(bottom: 40),
                  height: MediaQuery.of(context).size.height,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).backgroundColor,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0),
                    ),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Consumer(builder: (context, watch, widget) {
                            return CustomTextField(
                              hintText: 'John Doe',
                              labelText: appLang[watch(langProvider) as String]![28],
                              validator: (String? _value) {
                                if (_value!.isEmpty) {
                                  return 'This field is required!';
                                } else {
                                  return null;
                                }
                              },
                              onSaved: (String? _value) async {
                                _name = _value!;
                              },
                            );
                          }),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: CustomPhoneInput(
                            initialValue: _phoneNumber,
                            onInputChanged: (value) {
                              _phoneNumber = PhoneNumber(
                                dialCode: value.dialCode,
                                isoCode: value.isoCode,
                                phoneNumber: value.phoneNumber,
                              );
                            },
                            onSaved: (value) async {
                              _phoneNumber = PhoneNumber(
                                dialCode: value.dialCode,
                                isoCode: value.isoCode,
                                phoneNumber: value.phoneNumber,
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: SizedBox(
                            height: 50,
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Theme.of(context).accentColor,
                                elevation: 0,
                              ),
                              child: Consumer(builder: (context, watch, widget) {
                                return Text(appLang[watch(langProvider) as String]![30]);
                              }),
                              onPressed: () {
                                _submitContact(context);
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: Consumer(builder: (context, watch, widget) {
                            return Text(
                              appLang[watch(langProvider) as String]![31],
                              style: TextStyle(color: Colors.red),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Consumer(builder: (context, watch, widget) {
            return (watch(internetProvider) as bool) ? SizedBox.shrink() : InternetDialog();
          }),
          Consumer(builder: (context, watch, widget) {
            return (watch(loadingDialogProvider) as bool) ? LoadingDialog() : SizedBox.shrink();
          }),
        ],
      ),
      bottomNavigationBar: BannerAdWidget(size: AdSize.banner),
    );
  }

  void _submitContact(BuildContext context) async {
    LoadingDialogController _controller = context.read(loadingDialogProvider.notifier);
    if (_validateForm()) {
      if (UserSharedPreferences.getUserPhoneNumber() == "" || UserSharedPreferences.getUserPhoneNumber() != _phoneNumber.phoneNumber) {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (BuildContext context) => ValidateNumberScreen(
              phoneNumber: _phoneNumber,
            ),
          ),
        );
      } else {
        try {
          String _code = _phoneNumber.dialCode!;
          String _inititalNumber = _phoneNumber.phoneNumber!;
          String _number = _inititalNumber.substring(_code.length, _inititalNumber.length);

          _controller.setLoading(true);
          final _response = await post(
            Uri.parse('https://app.wassapviews.ng/api/register'),
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Authorization': authKey,
            },
            body: jsonEncode(
              {
                'name': _name,
                'country_code': _code,
                'number': _number,
              },
            ),
          ).timeout(
            const Duration(seconds: 60),
            onTimeout: () {
              _controller.setLoading(false);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Connection timeout! Check your internet connection and try again.'),
                  duration: Duration(seconds: 4),
                ),
              );
              return Response('Error', 500);
            },
          );
          if (_response.statusCode == 200 || _response.statusCode == 201) {
            _controller.setLoading(false);
            dynamic _fetchedData = jsonDecode(_response.body);
            if (_fetchedData['status'] == 'success') {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    _fetchedData['message'],
                    style: TextStyle(
                      color: Theme.of(context).buttonColor,
                    ),
                  ),
                  backgroundColor: Theme.of(context).backgroundColor,
                  behavior: SnackBarBehavior.floating,
                  margin: const EdgeInsets.fromLTRB(
                    50,
                    0,
                    50,
                    70,
                  ),
                  duration: const Duration(seconds: 4),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    _fetchedData['message'],
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                  margin: const EdgeInsets.fromLTRB(
                    50,
                    0,
                    50,
                    70,
                  ),
                  duration: const Duration(seconds: 4),
                ),
              );
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('An unexpected error occured'),
                duration: Duration(seconds: 4),
              ),
            );
          }
        } on SocketException {
          _controller.setLoading(false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('An error occured! Check your internet connection and try again.'),
              duration: Duration(seconds: 4),
            ),
          );
        } catch (e) {
          _controller.setLoading(false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('An unexpected error occured: $e'),
              duration: const Duration(seconds: 4),
            ),
          );
        }
      }
    }
  }
}
