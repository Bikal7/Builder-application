import 'package:builder/Add%20Info/materials.dart';
import 'package:builder/Add%20Info/professions.dart';
import 'package:builder/login.dart';
import 'package:builder/otherSettings.dart';
import 'package:builder/policy.dart';
import 'package:builder/profile.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class SettingList {
  String? settingImage;
  String? settingName;
  Function? onPressed;

  SettingList({this.settingImage, this.settingName, this.onPressed});
}

class _SettingsState extends State<Settings> {
  int number = 9828491612;
  bool isAdmin = false;
  bool admin = false;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadAdminStatus();
  }

   areYouAdmin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int phone = prefs.getInt("Phone") ?? 0;
    if (phone != 0) {
      if (phone == number) {
        isAdmin = true;
      } else {
        isAdmin = false;
      }
    }
  }

  Future<void> loadAdminStatus() async {
    await areYouAdmin();
    setState(() {
      loading = false;
    });
    loadSettingsList();
  }

  void loadSettingsList() {
    setState(() {
      settingsList = [
        SettingList(
          settingImage: "assets/images/user.png",
          settingName: "Profile",
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: ((context) => const Profile())));
          },
        ),
        SettingList(
          settingImage: "assets/images/file.png",
          settingName: "Privacy policy",
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: ((context) => const Policy())));
          },
        ),
        SettingList(
          settingImage: "assets/images/settings.png",
          settingName: "Other Settings",
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: ((context) => const OtherSetting())));
          },
        ),
        // if (isAdmin)
          SettingList(
            settingImage: "assets/images/Materials.png",
            settingName: "Add Material Details",
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: ((context) => const MaterialForm())));
            },
          ),
        // if (isAdmin)
          SettingList(
            settingImage: "assets/images/worker.png",
            settingName: "Add Profession Details",
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: ((context) => const ProfessionForm())));
            },
          ),
        SettingList(
          settingImage: "assets/images/exit.png",
          settingName: "Logout",
          onPressed: () {
            showAlertDialogBox(context);
          },
        ),
      ];
    });
  }

  List<SettingList>? settingsList;

  removeValueFromSharedPreference() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("isLogin");
    prefs.remove("Phone");
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 15, bottom: 10),
              child: Text('Settings', style: TextStyle(fontSize: 24)),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12, right: 12),
              child: Column(
                children: settingsList!
                    .asMap()
                    .entries
                    .map(
                      (e) => InkWell(
                        onTap: () {
                          if (settingsList![e.key].onPressed != null) {
                            settingsList![e.key].onPressed!();
                          }
                        },
                        child: Column(
                          children: [
                            Container(
                              height: 60,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 0.2,
                                    spreadRadius: 0.1,
                                    color: Colors.grey,
                                  )
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          height: 27,
                                          width: 27,
                                          child: Image.asset(
                                            settingsList![e.key].settingImage!,
                                            color: Colors.black,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          settingsList![e.key].settingName!,
                                          style: const TextStyle(
                                            fontSize: 15,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(right: 10),
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.black,
                                      size: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            )
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            )
          ],
        ),
      );
    }
  }
  void showAlertDialogBox(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Logout?",
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Are you sure you want to Logout?",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                      width: MediaQuery.of(context).size.width * 0.2,
                      child: ElevatedButton(
                        onPressed: () {
                          removeValueFromSharedPreference();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Login(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          // primary: Colors.white,
                          // onPrimary: Colors.black,
                        ),
                        child: const Text(
                          "Yes",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 70,
                      height: 30,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                      width: MediaQuery.of(context).size.width * 0.2,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          // primary: Colors.white,
                          // onPrimary: Colors.black,
                        ),
                        child: const Text(
                          "No",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
