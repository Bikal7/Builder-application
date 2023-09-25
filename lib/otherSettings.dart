import 'package:builder/changePassForm.dart';
import 'package:flutter/material.dart';

class OtherSetting extends StatefulWidget {
  const OtherSetting({super.key});

  @override
  State<OtherSetting> createState() => _OtherSettingState();
}

class OtherSettingList {
  String? settingImage;
  String? settingName;
  Function? onPressed;

  OtherSettingList({this.settingImage, this.settingName, this.onPressed});
}

class _OtherSettingState extends State<OtherSetting> {
  List<OtherSettingList>? otherSettingsList;

  @override
  void initState() {
    otherSettingsList = [
      OtherSettingList(
        settingImage: "assets/images/padlock.png",
        settingName: "Change Password",
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: ((context) => const ChangePassword())),
          );
        },
      ),
    ];
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 15, bottom: 10),
            child: Text(
              'Settings',
              style: TextStyle(fontSize: 24),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 12),
            child: Column(
              children: otherSettingsList!
                  .asMap()
                  .entries
                  .map(
                    (e) => InkWell(
                      onTap: () {
                        if (otherSettingsList![e.key].onPressed != null) {
                          otherSettingsList![e.key].onPressed!();
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
                                          otherSettingsList![e.key].settingImage!,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        otherSettingsList![e.key].settingName!,
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