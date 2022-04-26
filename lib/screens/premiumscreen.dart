import 'package:flutter/cupertino.dart';
import 'package:wassapviews/libraries.dart';
import 'package:dio/dio.dart' as dio;

class PremiumScreen extends StatelessWidget {
  const PremiumScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void browserDownload2KVCF(int index) async {
      LoadingDialogController _controller = context.read(loadingDialogProvider.notifier);
      String _code = UserSharedPreferences.getUserDialCode()!;
      String _inititalNumber = UserSharedPreferences.getUserPhoneNumber()!;
      String _number = _inititalNumber.substring(_code.length, _inititalNumber.length);
      try {
        _controller.setLoading(true);

        final _response = await post(
          Uri.parse('https://app.wassapviews.ng/api/get2kvcf'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': authKey,
          },
          body: jsonEncode(
            {
              'country_code': _code,
              'number': _number,
              'index': index,
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
          dynamic _fetchedData = jsonDecode(_response.body);
          if (_fetchedData['status'] == 'success') {
            String _downloadPath = _fetchedData['data']['path'];

            _controller.setLoading(false);
            GlobalVariables.watchAd = false;
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text(
                  'Download VCF',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                content: const Text('VCF file has been requested completely. Click the \'Download VCF\' button to open your browser and download the VCF file.'),
                actions: <Widget>[
                  CustomTextButton(
                    text: 'Download VCF',
                    onPressed: () async {
                      if (await canLaunch(_downloadPath)) {
                        await launch(_downloadPath);
                      } else {
                        throw 'Could not launch $_downloadPath';
                      }
                      Navigator.pop(context, 'Cancel');
                      if (UserSharedPreferences.getRated() == 'false') {
                        _showCustomDialog(context);
                      }
                    },
                  ),
                ],
              ),
            );
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
          } else if (_fetchedData['status'] == 'share') {
            _controller.setLoading(false);
            UserSharedPreferences.setShared('false');
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: Text(
                  UserSharedPreferences.getShared() == 'true' ? 'Not Available' : 'Share',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                content: Text(UserSharedPreferences.getShared() == 'true' ? 'Come back later for more new VCF files.' : 'Click the \'SHARE NOW\' button to share our app link on your WhatsApp status and in 5 groups.'),
                actions: <Widget>[
                  UserSharedPreferences.getShared() == 'true'
                      ? SizedBox.shrink()
                      : CustomTextButton(
                          text: 'SHARE NOW',
                          onPressed: () async {
                            UserSharedPreferences.setShared('true');
                            String _link =
                                "https://wa.me/?text=Hey!!!%20%0A*Have%20you%20been%20Wondering%20the%20strategies%20your%20friends%20are%20using%20to%20boost%20their%20WhatsApp%20views%3F%3F%3F*%0A%0A*Leave%20the%20Wonder%20land%2C%20click%20the%20link%20below%20and%20install%20wassapviews%20app%20to%20find%20out%20their%20secret*%0A%F0%9F%91%87%F0%9F%91%87%F0%9F%91%87%F0%9F%91%87%F0%9F%91%87%0Ahttps%3A%2F%2Fplay.google.com%2Fstore%2Fapps%2Fdetails%3Fid%3Dcom.dartechlabs.wassapviews%0Ahttps%3A%2F%2Fplay.google.com%2Fstore%2Fapps%2Fdetails%3Fid%3Dcom.dartechlabs.wassapviews";
                            if (await canLaunch(_link)) {
                              await launch(_link);
                            } else {
                              throw 'Could not launch $_link';
                            }
                            await Future.delayed(const Duration(seconds: 10));
                            Navigator.pop(context, 'Cancel');
                          },
                        ),
                ],
              ),
            );
          } else {
            _controller.setLoading(false);
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
          _controller.setLoading(false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('An unexpected error occured. StatusCode: ${_response.statusCode}'),
              duration: const Duration(seconds: 4),
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
      } on FileSystemException {
        _controller.setLoading(false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Storage permission not granted by device. Please use another device.'),
            duration: Duration(seconds: 4),
          ),
        );
      } on PlatformException {
        _controller.setLoading(false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('An error occured! Could not get the downloads directory.'),
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

    Future getTotalCount() async {
      var _response = await post(
        Uri.parse('https://app.wassapviews.ng/api/gettotalcount'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': authKey,
        },
      ).timeout(Duration(seconds: 120), onTimeout: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occured while fetching vcf files.'),
          ),
        );
        return Response('Error', 500);
      });
      return _response.body;
    }

    void _downloadFullVCF() async {
      LoadingDialogController _controller = context.read(loadingDialogProvider.notifier);
      try {
        _controller.setLoading(true);
        var _testdir = await Directory('/storage/emulated/0/Wassapviews/full_vcf').create(recursive: true);
        String appDocPath = _testdir.path;
        String _code = UserSharedPreferences.getUserDialCode()!;
        String _inititalNumber = UserSharedPreferences.getUserPhoneNumber()!;
        String _number = _inititalNumber.substring(_code.length, _inititalNumber.length);
        final _response = await post(
          Uri.parse('https://app.wassapviews.ng/api/getallvcf'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': authKey,
          },
          body: jsonEncode(
            {
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
          dynamic _fetchedData = jsonDecode(_response.body);
          if (_fetchedData['status'] == 'success') {
            String _downloadPath = _fetchedData['data']['path'];
            String _fileName = _fetchedData['data']['file_name'];

            var _dio = dio.Dio();

            try {
              await _dio.download(_downloadPath, "$appDocPath/$_fileName");
            } catch (e) {
              debugPrint('Error: $e');
            }

            _controller.setLoading(false);
            GlobalVariables.watchAd = false;
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text(
                  'Download Complete',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                content: const Text('VCF file has downloaded completely. Click the \'Import VCF\' button and click your contact app to open the file. \n Note: Your VCF files can be found in the "Wassapviews" => "full_vcf" folder of your root storage.'),
                actions: <Widget>[
                  CustomTextButton(
                    text: 'Import VCF',
                    onPressed: () async {
                      await OpenFile.open("${appDocPath}/${_fileName}");
                      Navigator.pop(context, 'Cancel');
                    },
                  ),
                ],
              ),
            );
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
          } else if (_fetchedData['status'] == 'share') {
            _controller.setLoading(false);
            UserSharedPreferences.setShared('false');
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: Text(
                  UserSharedPreferences.getShared() == 'true' ? 'Not Available' : 'Share',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                content: Text(UserSharedPreferences.getShared() == 'true' ? 'Come back later for more new VCF files.' : 'Click the \'SHARE NOW\' button to share our app link on your WhatsApp status and in 5 groups.'),
                actions: <Widget>[
                  UserSharedPreferences.getShared() == 'true'
                      ? SizedBox.shrink()
                      : CustomTextButton(
                          text: 'SHARE NOW',
                          onPressed: () async {
                            UserSharedPreferences.setShared('true');
                            String _link =
                                "https://wa.me/?text=*THE%20SECRET%20OF%20WHATSAPP%20TVs%20HAS%20BEEN%20REVEALED*%0A%0AAre%20you%20tired%20of%20getting%20low%20Whatsapp%20status%20views%3F%20Follow%20the%20link%20below%20to%20install%20Wassapviews%20app%20in%20order%20to%20gain%202k%2B%20Whatsapp%20status%20views%20for%20free%20with%20just%201%20click%F0%9F%98%B1%F0%9F%98%B1%F0%9F%92%83%F0%9F%92%83%20%0A%20%20%20%20%20%20%20%20%20%20%20%20%20*VISIT*%20%F0%9F%91%87%0A%20%20https%3A%2F%2Fplay.google.com%2Fstore%2Fapps%2Fdetails%3Fid%3Dcom.dartechlabs.wassapviews%0A%20%20https%3A%2F%2Fplay.google.com%2Fstore%2Fapps%2Fdetails%3Fid%3Dcom.dartechlabs.wassapviews";
                            if (await canLaunch(_link)) {
                              await launch(_link);
                            } else {
                              throw 'Could not launch $_link';
                            }
                            await Future.delayed(const Duration(seconds: 10));
                            Navigator.pop(context, 'Cancel');
                          },
                        ),
                ],
              ),
            );
          } else {
            _controller.setLoading(false);
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
          _controller.setLoading(false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('An unexpected error occured. StatusCode: ${_response.statusCode}'),
              duration: const Duration(seconds: 4),
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
      } on FileSystemException {
        _controller.setLoading(false);
        browserDownloadVCF(context);
      } on PlatformException {
        _controller.setLoading(false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('An error occured! Could not get the downloads directory.'),
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

    /*void _deleteInactiveContacts() async {
      LoadingDialogController _controller = context.read(loadingDialogProvider.notifier);
      if (await FlutterContacts.requestPermission()) {
        try {
          String _code = UserSharedPreferences.getUserDialCode()!;
          String _inititalNumber = UserSharedPreferences.getUserPhoneNumber()!;
          String _number = _inititalNumber.substring(_code.length, _inititalNumber.length);

          _controller.setLoading(true);
          final _response = await post(
            Uri.parse('https://app.wassapviews.ng/api/fetchoutdated'),
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Authorization': authKey,
            },
            body: jsonEncode(
              {
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
            dynamic _fetchedData = jsonDecode(_response.body);
            if (_fetchedData['status'] == 'success') {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Deleting inactive & outdated contacts',
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
              List _data = _fetchedData['data'];
              _data.forEach((element) async {
                Contact? contact = await FlutterContacts.getContact(element.toString());
                if (contact != null && (contact.displayName).contains(' WV')) {
                  await contact.delete();
                }
              });
              _controller.setLoading(false);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Contacts updated successfully.',
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
              _controller.setLoading(false);
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
            _controller.setLoading(false);
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
    }*/

    return Scaffold(
      appBar: AppBar(
        title: Consumer(
          builder: (context, watch, widget) {
            return (watch(premiumPlanStatusProvider) as String) == 'active'
                ? RichText(
                    text: TextSpan(
                      text: 'Premium',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w900,
                        fontStyle: FontStyle.italic,
                        color: Theme.of(context).buttonColor,
                      ),
                      children: <InlineSpan>[
                        TextSpan(
                          text: 'Plan',
                          style: TextStyle(
                            color: Theme.of(context).accentColor,
                          ),
                        )
                      ],
                    ),
                  )
                : RichText(
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
                  );
          },
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
                    'Premium User Page',
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
                  child: ListView(
                    physics: BouncingScrollPhysics(),
                    children: [
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Theme.of(context).buttonColor,
                              elevation: 0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                FaIcon(FontAwesomeIcons.addressCard, size: 20),
                                Text('Download Full Contacts'),
                                FaIcon(FontAwesomeIcons.longArrowAltRight, size: 20),
                              ],
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: Text('Comfirm Download?'),
                                  content: Text('Do you really want to download the full VCF file?'),
                                  actions: [
                                    CustomTextButton(
                                      text: 'Download',
                                      onPressed: () {
                                        Navigator.pop(context);
                                        _downloadFullVCF();
                                      },
                                    ),
                                    CustomTextButton(
                                      text: 'Not yet',
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Theme.of(context).buttonColor,
                              elevation: 0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                FaIcon(FontAwesomeIcons.trash, size: 20),
                                Text('Delete Outdated/Inactive Contacts'),
                                FaIcon(FontAwesomeIcons.longArrowAltRight, size: 20),
                              ],
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: Text('Comfirm Delete?'),
                                  content: Text('Do you really want to delete inactive contacts? This will delete all contacts gotten from Wassapviews which are found to be inactive.'),
                                  actions: [
                                    CustomTextButton(
                                      text: 'Delete',
                                      onPressed: () {
                                        Navigator.pop(context);
                                        // _deleteInactiveContacts();
                                      },
                                    ),
                                    CustomTextButton(
                                      text: 'Not yet',
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Theme.of(context).buttonColor,
                              elevation: 0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text('Manage Contacts'),
                                FaIcon(FontAwesomeIcons.longArrowAltRight, size: 20),
                              ],
                            ),
                            onPressed: null,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Theme.of(context).buttonColor,
                              elevation: 0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text('Delete Duplicate Contacts'),
                                FaIcon(FontAwesomeIcons.longArrowAltRight, size: 20),
                              ],
                            ),
                            onPressed: null,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(top: 40),
                        // height: 70,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                        ),
                        child: Text(
                          'List of 2K VCF Files for You.',
                          style: TextStyle(
                            color: GlobalVariables.isDarkMode() ? AppColors.white : AppColors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: SizedBox(
                          width: double.infinity,
                          child: FutureBuilder(
                              future: getTotalCount(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return Center(
                                    heightFactor: 5,
                                    child: CircularProgressIndicator(color: Theme.of(context).accentColor),
                                  );
                                } else if (snapshot.hasError) {
                                  return Container(
                                    padding: EdgeInsets.all(4),
                                    height: MediaQuery.of(context).size.height * 0.4,
                                    child: Text('Failed to load VCF files.'),
                                  );
                                } else {
                                  int count = jsonDecode(snapshot.data.toString())['data']['count'];
                                  int pagin = (count / 2000).ceilToDouble().toInt();
                                  return GridView.builder(
                                      padding: EdgeInsets.all(5),
                                      physics: BouncingScrollPhysics(),
                                      itemCount: pagin,
                                      shrinkWrap: true,
                                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 200, crossAxisSpacing: 20, mainAxisSpacing: 20),
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () {
                                            browserDownload2KVCF(index);
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: GlobalVariables.isDarkMode() ? Color(0xFFFFFFFF) : Color(0xFFECFFF1),
                                              boxShadow: GlobalVariables.isDarkMode() ? null : [BoxShadow(color: Colors.grey, offset: Offset.zero, blurRadius: 4, spreadRadius: 1)],
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                FaIcon(FontAwesomeIcons.addressCard, size: 30, color: Theme.of(context).accentColor),
                                                SizedBox(height: 3),
                                                Text(
                                                  'FILE ${index + 1}',
                                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Theme.of(context).accentColor),
                                                ),
                                                SizedBox(height: 3),
                                                Text(
                                                  '2K Contacts',
                                                  style: TextStyle(color: Colors.black),
                                                ),
                                                SizedBox(height: 3),
                                                FaIcon(FontAwesomeIcons.download, size: 20, color: Colors.grey),
                                              ],
                                            ),
                                          ),
                                        );
                                      });
                                }
                              }),
                        ),
                      ),
                      SizedBox(height: 200),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Consumer(builder: (context, watch, widget) {
            return (watch(premiumPlanStatusProvider) as String) != 'active'
                ? Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    color: AppColors.transparentBlack,
                    child: AlertDialog(
                      title: Text('Premium Plan'),
                      content: Text('Subcribe to premium plan to access premium features'),
                      actions: [
                        CustomTextButton(
                          text: 'Go Premium',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) => GoPremiumScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  )
                : SizedBox.shrink();
          }),
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

  void browserDownloadVCF(BuildContext context) async {
    LoadingDialogController _controller = context.read(loadingDialogProvider.notifier);
    try {
      String _code = UserSharedPreferences.getUserDialCode()!;
      String _inititalNumber = UserSharedPreferences.getUserPhoneNumber()!;
      String _number = _inititalNumber.substring(_code.length, _inititalNumber.length);
      _controller.setLoading(true);

      final _response = await post(
        Uri.parse('https://app.wassapviews.ng/api/getvcf'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': authKey,
        },
        body: jsonEncode(
          {
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
        dynamic _fetchedData = jsonDecode(_response.body);
        if (_fetchedData['status'] == 'success') {
          String _downloadPath = _fetchedData['data']['path'];

          _controller.setLoading(false);
          GlobalVariables.watchAd = false;
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text(
                'Download VCF',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: const Text('VCF file has been requested completely. Click the \'Download VCF\' button to open your browser and download the VCF file.'),
              actions: <Widget>[
                CustomTextButton(
                  text: 'Download VCF',
                  onPressed: () async {
                    if (await canLaunch(_downloadPath)) {
                      await launch(_downloadPath);
                    } else {
                      throw 'Could not launch $_downloadPath';
                    }
                    Navigator.pop(context, 'Cancel');
                    if (UserSharedPreferences.getRated() == 'false') {
                      _showCustomDialog(context);
                    }
                  },
                ),
              ],
            ),
          );
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
        } else if (_fetchedData['status'] == 'share') {
          _controller.setLoading(false);
          UserSharedPreferences.setShared('false');
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: Text(
                UserSharedPreferences.getShared() == 'true' ? 'Not Available' : 'Share',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: Text(UserSharedPreferences.getShared() == 'true' ? 'Come back later for more new VCF files.' : 'Click the \'SHARE NOW\' button to share our app link on your WhatsApp status and in 5 groups.'),
              actions: <Widget>[
                UserSharedPreferences.getShared() == 'true'
                    ? SizedBox.shrink()
                    : CustomTextButton(
                        text: 'SHARE NOW',
                        onPressed: () async {
                          UserSharedPreferences.setShared('true');
                          String _link =
                              "https://wa.me/?text=*THE%20SECRET%20OF%20WHATSAPP%20TVs%20HAS%20BEEN%20REVEALED*%0A%0AAre%20you%20tired%20of%20getting%20low%20Whatsapp%20status%20views%3F%20Follow%20the%20link%20below%20to%20install%20Wassapviews%20app%20in%20order%20to%20gain%202k%2B%20Whatsapp%20status%20views%20for%20free%20with%20just%201%20click%F0%9F%98%B1%F0%9F%98%B1%F0%9F%92%83%F0%9F%92%83%20%0A%20%20%20%20%20%20%20%20%20%20%20%20%20*VISIT*%20%F0%9F%91%87%0A%20%20https%3A%2F%2Fplay.google.com%2Fstore%2Fapps%2Fdetails%3Fid%3Dcom.dartechlabs.wassapviews%0A%20%20https%3A%2F%2Fplay.google.com%2Fstore%2Fapps%2Fdetails%3Fid%3Dcom.dartechlabs.wassapviews";
                          if (await canLaunch(_link)) {
                            await launch(_link);
                          } else {
                            throw 'Could not launch $_link';
                          }
                          await Future.delayed(const Duration(seconds: 10));
                          Navigator.pop(context, 'Cancel');
                        },
                      ),
              ],
            ),
          );
        } else {
          _controller.setLoading(false);
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
        _controller.setLoading(false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An unexpected error occured. StatusCode: ${_response.statusCode}'),
            duration: const Duration(seconds: 4),
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
    } on FileSystemException {
      _controller.setLoading(false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Storage permission not granted by device. Please use another device.'),
          duration: Duration(seconds: 4),
        ),
      );
    } on PlatformException {
      _controller.setLoading(false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occured! Could not get the downloads directory.'),
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

  void _showCustomDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text(
          'Join us on Telegram',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text('Please join our official Telegram channel for more info, questions, updates, tutorial, etc.. .'),
        actions: <Widget>[
          CustomTextButton(
            text: 'Join Us',
            onPressed: () async {
              await UserSharedPreferences.setRated('true');
              String url = 'https://t.me/wassapviews';
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'Could not launch $url';
              }
              Navigator.pop(context, 'Cancel');
            },
          ),
        ],
      ),
    );
  }
}
