import 'package:builder/profileEdit.dart';
import 'package:builder/profile_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfile {
  final String? name;
  final String? imageUrl;
  final String? phoneNumber;
  final String? gender;
  final String? address;

  UserProfile({
    this.name,
    this.imageUrl,
    this.phoneNumber,
    this.gender,
    this.address,
  });
}

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late Future<UserProfile> _userProfileFuture;

 Future<UserProfile> getDataFromFirebase() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  int phone = prefs.getInt('Phone') ?? 0; // Set the default value to 0

  if (phone != 0) {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Signup')
        .where('Phone', isEqualTo: phone)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final user = querySnapshot.docs.first;
      final data = user.data() as Map<String, dynamic>?;
      return UserProfile(
        name: data?['fullname'] as String?,
        imageUrl: data?['ImageURL'] as String?,
        phoneNumber: data?['Phone']?.toString(),
        gender: data?['Gender'] as String?,
        address: data?['Address'] as String?,
      );
    }
  }

  return UserProfile(
    name: null,
    imageUrl: null,
    phoneNumber: null,
    gender: null,
    address: null,
  );
}

void _editProfile(BuildContext context, UserProfile userProfile) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => EditProfile(
        profile: ProfileModel(
          id: '', // You need to provide a value for id as it is required in ProfileModel
          fullname: userProfile.name ?? '',
          gender: userProfile.gender ?? '',
          address: userProfile.address ?? '',
          imageUrl: userProfile.imageUrl ?? '',
          phone: int.tryParse(userProfile.phoneNumber ?? '') ?? 0,
        ),
      ),
    ),
  );
}


  @override
  void initState() {
    _userProfileFuture = getDataFromFirebase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Profile',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios),
          ),
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.grey,
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: FutureBuilder<UserProfile>(
                future: _userProfileFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    UserProfile userProfile = snapshot.data!;
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 170),
                          child: SizedBox(
                            height:50,
                            width: MediaQuery.of(context).size.width*.43,
                            child: ElevatedButton(
                              onPressed: () {
                                _editProfile(context, userProfile);
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                primary: Colors.blue,
                                padding: const EdgeInsets.all(16),
                                textStyle: const TextStyle(fontSize: 14),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Edit Profile?',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Center(
                          child: userProfile.imageUrl != null && userProfile.imageUrl!.isNotEmpty
                              ? CircleAvatar(
                                  radius: 50,
                                  backgroundImage: NetworkImage(userProfile.imageUrl!),
                                )
                              : const CircleAvatar(
                                  radius: 50,
                                  backgroundImage: AssetImage("assets/images/pr.jpg"),
                                ),
                        ),
                        const SizedBox(height: 24),
                        ListTile(
                          leading: const Icon(Icons.person),
                          title: userProfile.name != null && userProfile.name!.isNotEmpty
                              ? Text(
                                  userProfile.name!,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                )
                              : const Text(
                                  "Your Name",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                          subtitle: const Text("Name"),
                        ),
                        const SizedBox(height: 16),
                        ListTile(
                          leading: const Icon(Icons.people_alt),
                          title: userProfile.gender != null && userProfile.gender!.isNotEmpty
                              ? Text(
                                  userProfile.gender!,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                )
                              : const Text(
                                  "Your Gender",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                          subtitle: const Text("Gender"),
                        ),
                        const SizedBox(height: 16),
                        ListTile(
                          leading: const Icon(Icons.location_on),
                          title: userProfile.address != null && userProfile.address!.isNotEmpty
                              ? Text(
                                  userProfile.address!,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                )
                              : const Text(
                                  "Your Address",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                          subtitle: const Text("Address"),
                        ),
                        const SizedBox(height: 16),
                        ListTile(
                          leading: const Icon(Icons.phone),
                          title: userProfile.phoneNumber != null && userProfile.phoneNumber!.isNotEmpty
                              ? Text(
                                  userProfile.phoneNumber!,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                )
                              : const Text(
                                  "Your Phone Number",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                          subtitle: const Text("Phone"),
                        ),
                        
                      ],
                    );
                  }
                },
              ),
            ),
          ),
        ),
        
      ),
    );
  }
}
