import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];

showSnackBar(String message){
       ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
          content: Text(message),
        ),
      );
  }

  void _performSearch(String searchText) async {
    if (searchText.isEmpty) {
      setState(() {
        _searchResults.clear();
      });
      return;
    }

    // Search for Professions
    QuerySnapshot<Map<String, dynamic>> professionsQuerySnapshot = await _firestore
        .collection('Professions')
        .where('Profession', isGreaterThanOrEqualTo: searchText)
        .where('Profession', isLessThan: searchText + 'z')
        .get();

    // Search for Materials
    QuerySnapshot<Map<String, dynamic>> materialsQuerySnapshot = await _firestore
        .collection('Materials')
        .where('Material', isGreaterThanOrEqualTo: searchText)
        .where('Material', isLessThan: searchText + 'z')
        .get();

    List<Map<String, dynamic>> combinedResults = [];
    combinedResults.addAll(professionsQuerySnapshot.docs.map((doc) => doc.data()).toList());
    combinedResults.addAll(materialsQuerySnapshot.docs.map((doc) => doc.data()).toList());

    setState(() {
      _searchResults = combinedResults;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Search',
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 18.0,
              left: 10,
              right: 10,
            ),
            child: SizedBox(
              height: 55,
              child: TextFormField(
                controller: _searchController,
                onChanged: (value) => _performSearch(value),
                decoration: InputDecoration(
                  suffixIcon: const Icon(Icons.search),
                  hintText: 'Search your services',
                  hintStyle: const TextStyle(
                    fontSize: 15,
                    letterSpacing: 1,
                  ),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(
                        width: 0.5, color: Color.fromARGB(255, 154, 159, 156)),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (notification is OverscrollNotification) {
                  if (notification.overscroll > 0) {
                    // Scrolling down, fade out the overflowing text
                    _searchController.clear();
                  }
                }
                return false;
              },
              child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  final searchData = _searchResults[index];
                  final professionName = searchData['Profession'] ?? 'N/A';
                  final wName = searchData['wName'] ?? 'N/A';
                  final exp = searchData['Exp'] ?? 'N/A';
                  final phone = searchData['Phone'] ?? 'N/A';
                  final imageUrl = searchData['ImageURL'] ?? 'N/A';
                  final materialName = searchData['bName'] ?? 'N/A';
                  final materials=searchData['Material']??'N/A';
                  final supplier = searchData['sHead'] ?? 'N/A';
                  final materialPhone = searchData['Phone'] ?? 'N/A';
                  final materialImageUrl = searchData['ImageURL'] ?? 'N/A';
            
                  // Decide whether to show profession or material data
                  bool isProfession = searchData.containsKey('Profession');
            
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(3),
                          border: Border.all(
                            color: Colors.grey,
                            width: 0.20,
                          ),
                        ),
                        height:
                            MediaQuery.of(context).size.height * 0.275 + (index * 10),
                        width: MediaQuery.of(context).size.width * 0.95,
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.95,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Column(
                            children: [
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.15,
                                width:
                                    MediaQuery.of(context).size.width * 0.9,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(5),
                                    topRight: Radius.circular(5),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black,
                                      spreadRadius: 0.5,
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 5),
                                        child: SizedBox(
                                          height: 200,
                                          width: 50,
                                          child: Column(
                                            children: [
                                              CircleAvatar(
                                                radius: 25,
                                                backgroundImage:
                                                    NetworkImage(isProfession ? imageUrl : materialImageUrl),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              IconButton(
                                                onPressed: () async{
                                                  try {
                                                    await launch (isProfession?('tel://$phone'):('tel://$materialPhone'));
                                                  } catch (e) {
                                                    print(e);
                                                  }
                                                },
                                                icon: const Icon(
                                                  Icons.phone,
                                                  size: 30,
                                                  color: Colors.green,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: SizedBox(
                                          height: 200,
                                          child: Column(
                                            children: [
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Align(
                                                alignment: Alignment.topLeft,
                                                child: SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.45,
                                                  height: 25,
                                                  child: FadeTransition(
                                                    opacity: Tween<double>(
                                                  begin: 1,
                                                  end: 1, // Adjust the opacity value as needed
                                                  ).animate(CurvedAnimation(
                                                  parent: const AlwaysStoppedAnimation<double>(1),
                                                  curve: const Interval(0.5, 1), // Adjust the interval as needed
                                                  )),
                                                    child: Text(
                                                      isProfession ? wName : materialName,
                                                      style: const TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.fade,
                                                      softWrap: false,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.99,
                                                height: 25,
                                                child: FadeTransition(
                                                  opacity: Tween<double>(
                                                  begin: 1,
                                                  end: 1, // Adjust the opacity value as needed
                                                  ).animate(CurvedAnimation(
                                                  parent: const AlwaysStoppedAnimation<double>(1),
                                                  curve: const Interval(0.5, 1), // Adjust the interval as needed
                                                  )),
                                                  child: Text(
                                                    isProfession ? professionName : supplier,
                                                    style: const TextStyle(fontSize: 14),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.fade,
                                                    softWrap: false,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.99,
                                                height: 25,
                                                child: FadeTransition(
                                                  opacity: Tween<double>(
                                              begin: 1,
                                              end: 1, // Adjust the opacity value as needed
                                            ).animate(CurvedAnimation(
                                              parent: const AlwaysStoppedAnimation<double>(1),
                                              curve: const Interval(0.5, 1), // Adjust the interval as needed
                                            )),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        isProfession ? "Experience:" : "Phone",
                                                      ),
                                                      const SizedBox(
                                                        width: 3,
                                                      ),
                                                      Text(
                                                        isProfession ? exp.toString() : materialPhone.toString(),
                                                        style: const TextStyle(fontSize: 14),
                                                        maxLines: 1,
                                                        overflow: TextOverflow.fade,
                                                        softWrap: false,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              FadeTransition(
                                            opacity: Tween<double>(
                                              begin: 1,
                                              end: 1, // Adjust the opacity value as needed
                                            ).animate(CurvedAnimation(
                                              parent: const AlwaysStoppedAnimation<double>(1),
                                              curve: const Interval(0.5, 1), // Adjust the interval as needed
                                            )),
                                            child: Row(
                                              children: [
                                                Text(
                                                  isProfession ? "Phone:" : "Material:",
                                                ),
                                                const SizedBox(
                                                  width: 3,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    isProfession ? phone.toString() : materials,
                                                    style: const TextStyle(fontSize: 14),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.fade,
                                                    softWrap: false,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.1,
                                width:
                                    MediaQuery.of(context).size.width * 0.9,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(5),
                                    bottomRight: Radius.circular(5),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black,
                                      spreadRadius: 0.5,
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 5),
                                        child: SizedBox(
                                          height: 200,
                                          width: 50,
                                          child: Align(
                                            alignment: Alignment.topLeft,
                                            child: IconButton(
                                              onPressed: () {},
                                              icon: const Icon(
                                                Icons.location_on,
                                                size: 40,
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: SizedBox(
                                          height: 200,
                                          child: Column(
                                            children: [
                                              const SizedBox(height: 10),
                                              Align(
                                                alignment: Alignment.topLeft,
                                                child: SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.9,
                                                  height: 25,
                                                  child: const Text(
                                                    "Banepa, Kavrepalanchok",
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.fade,
                                                    softWrap: false,
                                                  ),
                                                ),
                                              ),
                                              Align(
                                                alignment: Alignment.topLeft,
                                                child: SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.99,
                                                  height: 30,
                                                  child: const FadeTransition(
                                                    opacity: AlwaysStoppedAnimation(1),
                                                    child: Text(
                                                      "5 KM away",
                                                      style: TextStyle(fontSize: 14),
                                                      maxLines: 1,
                                                      overflow: TextOverflow.fade,
                                                      softWrap: false,
                                                    ),
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
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
