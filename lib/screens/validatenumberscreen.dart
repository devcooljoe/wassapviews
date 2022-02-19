import 'package:flutter/cupertino.dart';
import 'package:wassapviews/libraries.dart';

class ValidateNumberScreen extends StatelessWidget {
  PhoneNumber phoneNumber;
  ValidateNumberScreen({
    Key? key,
    required this.phoneNumber,
  }) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _code = '';

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
    OtpSentController _otpController = context.read(otpSentProvider.notifier);
    if (_otpController.getSent() == false) {
      Future.delayed(Duration(milliseconds: 500), () => _sendOTP(context, phoneNumber.phoneNumber!));
    }

    return Scaffold(
      appBar: AppBar(
        title: RichText(
          text: TextSpan(
            text: 'Wassap',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w900,
              fontStyle: FontStyle.italic,
              color: Theme.of(context).buttonColor,
            ),
            children: <InlineSpan>[
              TextSpan(
                text: 'Views',
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                ),
              )
            ],
          ),
        ),
        elevation: 0,
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
                  child: Text(
                    'Verify your WhatsApp number below',
                    style: TextStyle(
                      color: GlobalVariables.isDarkMode() ? AppColors.white : AppColors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
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
                          child: SizedBox(
                            height: 50,
                            width: double.infinity,
                            child: PinCodeTextField(
                              autovalidateMode: AutovalidateMode.disabled,
                              autoDismissKeyboard: true,
                              appContext: context,
                              pastedTextStyle: TextStyle(
                                color: Colors.green.shade600,
                                fontWeight: FontWeight.bold,
                              ),
                              length: 6,
                              animationType: AnimationType.fade,
                              validator: (String? val) {
                                if (val!.length < 6) {
                                  return "";
                                } else {
                                  return null;
                                }
                              },
                              pinTheme: PinTheme(
                                selectedFillColor: Theme.of(context).backgroundColor,
                                selectedColor: Theme.of(context).accentColor,
                                inactiveFillColor: Theme.of(context).backgroundColor,
                                inactiveColor: AppColors.grey4,
                                shape: PinCodeFieldShape.box,
                                borderRadius: BorderRadius.circular(5),
                                fieldHeight: 50,
                                fieldWidth: 40,
                                activeFillColor: Theme.of(context).backgroundColor,
                              ),
                              cursorColor: Theme.of(context).accentColor,
                              animationDuration: Duration(milliseconds: 300),
                              enableActiveFill: true,
                              keyboardType: TextInputType.number,
                              onCompleted: (value) {},
                              onChanged: (value) {
                                _code = value;
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: Consumer(builder: (context, watch, widget) {
                            return (watch(otpSentProvider) as bool)
                                ? Text(
                                    'An otp code has been sent to ${phoneNumber.phoneNumber}. Enter the otp code sent.',
                                    style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                                  )
                                : SizedBox.shrink();
                          }),
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
                              child: const Text('Verify Number'),
                              onPressed: () {
                                _submitCode(context);
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(30),
                          child: SizedBox(
                            height: 30,
                            width: double.infinity,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                primary: Theme.of(context).buttonColor,
                                elevation: 0,
                              ),
                              child: const Text('Not my number? Try again after 10mins!'),
                              onPressed: () {
                                _otpController.setSent(false);
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Consumer(builder: (context, watch, widget) {
            return (watch(loadingDialogProvider) as bool) ? LoadingPage() : SizedBox.shrink();
          }),
        ],
      ),
    );
  }

  void _submitCode(BuildContext context) async {
    if (_validateForm()) {
      _validateCode(context);
    } else {
      showDialog(
        context: context,
        builder: (BuildContext _) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Entries not Valid!'),
            actions: [
              CustomTextButton(
                text: 'OK',
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    }
  }

  void _sendOTP(BuildContext context, String phonenumber) {
    LoadingDialogController _controller = context.read(loadingDialogProvider.notifier);
    _controller.setLoading(true);
    final FirebaseAuth _auth = FirebaseAuth.instance;
    _auth.verifyPhoneNumber(
      phoneNumber: phonenumber,
      verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async {
        _controller.setLoading(false);
        await FirebaseAuth.instance.signInWithCredential(phoneAuthCredential).then((value) async {
          if (value.user != null) {
            _controller.setLoading(false);
            _completeVerify(context);
          }
        });
      },
      verificationFailed: (FirebaseAuthException exception) {
        _controller.setLoading(false);
        print('Error: ${exception.message}');
      },
      codeSent: (String verificationId, resendToken) {
        UserSharedPreferences.setVerificationId(verificationId);
        _controller.setLoading(false);
        OtpSentController _otpController = context.read(otpSentProvider.notifier);
        _otpController.setSent(true);
      },
      codeAutoRetrievalTimeout: (String code) {
        _controller.setLoading(false);
        print('Code retrieval Timeout');
      },
    );
  }

  void _validateCode(BuildContext context) async {
    LoadingDialogController _controller = context.read(loadingDialogProvider.notifier);
    _controller.setLoading(true);
    try {
      await FirebaseAuth.instance.signInWithCredential(PhoneAuthProvider.credential(verificationId: UserSharedPreferences.getVerificationId()!, smsCode: _code)).then((value) async {
        if (value.user != null) {
          _controller.setLoading(false);
          _completeVerify(context);
        }
      }).catchError((e) {
        _controller.setLoading(false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Invalid OTP Code',
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
      });
    } catch (e) {
      _controller.setLoading(false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error: $e',
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
  }

  void _completeVerify(BuildContext context) {
    OtpSentController _controller = context.read(otpSentProvider.notifier);
    _controller.setSent(false);
    UserSharedPreferences.setVerificationId('');
    UserSharedPreferences.setUserDialCode(phoneNumber.dialCode!);
    UserSharedPreferences.setUserIsoCode(phoneNumber.isoCode!);
    UserSharedPreferences.setUserPhoneNumber(phoneNumber.phoneNumber!);
    PhoneNumberController _phoneNumberController = context.read(phoneNumberProvider.notifier);
    _phoneNumberController.setPhoneNumber(phoneNumber.phoneNumber!);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'WhatsApp number verified successfully!',
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
    Navigator.pop(context);
  }
}
