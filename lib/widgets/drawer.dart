import 'package:flutter/cupertino.dart';
import 'package:wassapviews/libraries.dart';

class CustomDrawer extends StatelessWidget {
  CustomDrawer({Key? key}) : super(key: key);
  String _dropDownValue = UserSharedPreferences.getLanguage();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Image.asset(
                'assets/images/background.jpg',
                fit: BoxFit.cover,
                alignment: Alignment.bottomCenter,
                height: MediaQuery.of(context).size.height * 0.27,
              ),
              Opacity(
                opacity: GlobalVariables.isDarkMode() ? 0.5 : 0.1,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.27,
                  width: double.infinity,
                  color: GlobalVariables.isDarkMode() ? AppColors.black : AppColors.lightModeGreen,
                ),
              ),
              Positioned(
                bottom: 5.0,
                left: 15.0,
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    color: Theme.of(context).accentColor,
                  ),
                  child: Text(
                    "Wassapviews",
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            ],
          ),
          ListTile(
            leading: const FaIcon(FontAwesomeIcons.question, size: 15),
            title: Text('Learn how to use this app'),
            onTap: () async {
              String url = 'https://www.youtube.com/watch?v=fiIu4c1gfx8';
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'Could not launch $url';
              }
            },
          ),
          const Divider(),
          ListTile(
            leading: const FaIcon(FontAwesomeIcons.solidPaperPlane, size: 20),
            title: Consumer(builder: (context, watch, widget) {
              return Text(appLang[watch(langProvider) as String]![10]);
            }),
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (BuildContext context) => SubmitContactScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const FaIcon(FontAwesomeIcons.download, size: 20),
            title: Consumer(builder: (context, watch, widget) {
              return Text(appLang[watch(langProvider) as String]![11]);
            }),
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (BuildContext context) => GetVcfScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const FaIcon(FontAwesomeIcons.addressCard, size: 20),
            title: const Text('Download Full Contacts'),
            trailing: const FaIcon(FontAwesomeIcons.check, size: 15),
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (BuildContext context) => PremiumScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const FaIcon(FontAwesomeIcons.trash, size: 20),
            title: Text('Delete Inactive Contacts'),
            trailing: const FaIcon(FontAwesomeIcons.check, size: 15),
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (BuildContext context) => PremiumScreen(),
                ),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const FaIcon(FontAwesomeIcons.trophy, size: 20),
            title: Consumer(builder: (context, watch, widget) {
              return Text(appLang[watch(langProvider) as String]![17]);
            }),
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (BuildContext context) => GoPremiumScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const FaIcon(FontAwesomeIcons.telegram, size: 20),
            title: Consumer(builder: (context, watch, widget) {
              return Text(appLang[watch(langProvider) as String]![12]);
            }),
            onTap: () async {
              String url = 'https://t.me/wassapviews';
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'Could not launch $url';
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.star),
            title: Consumer(builder: (context, watch, widget) {
              return Text(appLang[watch(langProvider) as String]![13]);
            }),
            onTap: () async {
              String url = 'https://play.google.com/store/apps/details?id=com.dartechlabs.wassapviews';
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'Could not launch $url';
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: Consumer(builder: (context, watch, widget) {
              return Text(appLang[watch(langProvider) as String]![14]);
            }),
            onTap: () async {
              String url = 'https://wassapviews.ng/terms-and-conditions.pdf';
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'Could not launch $url';
              }
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.more),
            title: Text('Boost Social Media Followers'),
            onTap: () async {
              String url = 'https://thefastestboost.com';
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'Could not launch $url';
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.more),
            title: Text('Get More WhatsApp Views'),
            onTap: () async {
              String url = 'https://wassapviews.ng';
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'Could not launch $url';
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.more),
            title: Text('Get Your Google Voice Number'),
            onTap: () async {
              String url = 'https://darads.com/gpricelist';
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'Could not launch $url';
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.more),
            title: Text('Place Your Viral Ads'),
            onTap: () async {
              String url = 'https://darads.com';
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'Could not launch $url';
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.code),
            title: Text('Get a Website/App Developer'),
            onTap: () async {
              String url = 'mailto:onipedejoseph2018@gmail.com';
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'Could not launch $url';
              }
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.warning),
            title: Consumer(builder: (context, watch, widget) {
              return Text(appLang[watch(langProvider) as String]![15]);
            }),
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (BuildContext context) => ReportContactScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete),
            title: Consumer(builder: (context, watch, widget) {
              return Text(appLang[watch(langProvider) as String]![16]);
            }),
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (BuildContext context) => RemoveContactScreen(),
                ),
              );
            },
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.only(
              top: 2,
              bottom: 1,
              left: 2,
              right: 2,
            ),
            child: ListTile(
              trailing: DropdownButton<String>(
                underline: SizedBox.shrink(),
                hint: const Text('Choose'),
                items: <String>[
                  'English',
                  'Chinese',
                  'Spanish',
                  'Hindi',
                  'Arabic',
                  'Portuguese',
                  'Russian',
                  'Japanese',
                  'German',
                  'Korean',
                  'French',
                  'Turkish',
                  'Tamil',
                  'Vietnamese',
                  'Urdu',
                ].map((e) {
                  return DropdownMenuItem(
                    child: Text(e),
                    value: e,
                  );
                }).toList(),
                value: _dropDownValue,
                onChanged: (String? newValue) async {
                  if (newValue != null) {
                    _dropDownValue = newValue;
                    LangController _langController = context.read(langProvider.notifier);
                    _langController.setLang(newValue);
                    await UserSharedPreferences.setLanguage(newValue);
                  }
                },
              ),
              leading: Consumer(builder: (context, watch, widget) {
                return Text(
                  appLang['${watch(langProvider)}']![18],
                  style: TextStyle(fontWeight: FontWeight.bold),
                );
              }),
            ),
          ),
          Center(
            child: Consumer(
              builder: (context, watch, widget) {
                return Text('${appLang[watch(langProvider) as String]![19]} $deviceName');
              },
            ),
          ),
        ],
      ),
    );
  }
}
