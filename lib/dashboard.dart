import 'package:builder/materials/cement.dart';
import 'package:builder/materials/electronics.dart';
import 'package:builder/materials/glass.dart';
import 'package:builder/materials/lumber.dart';
import 'package:builder/materials/metal.dart';
import 'package:builder/materials/sand.dart';
import 'package:builder/profession_model.dart';
import 'package:builder/professions/carpenter.dart';
import 'package:builder/professions/electrician.dart';
import 'package:builder/professions/engineer.dart';
import 'package:builder/materials/brick.dart';
import 'package:builder/professions/glazier.dart';
import 'package:builder/professions/mason.dart';
import 'package:builder/professions/painter.dart';
import 'package:builder/professions/plumber.dart';
import 'package:builder/profile.dart';
import 'package:builder/search.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bloc/apiservices/apiImpl.dart';
import 'material_model.dart';


class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

List<String> images = [
  "assets/images/c1.jpg",
  "assets/images/c6.jpg",
  "assets/images/c2.jpg",
  "assets/images/c3.jpg",
  "assets/images/c5.jpg"
];

class _DashboardState extends State<Dashboard> {
  String name = "";
  String imageUrl = "";
  int _current = 0;
  late Future<bool> _nameFetchedFuture;
  late Future<bool> _imageFetchedFuture; 
  final CarouselController _controller = CarouselController();
  List<Widget> imageSliders = [];
  List<BuildingMaterials> materialList = [];
  List<Laborer> laborerList = [];

  String searchQuery = ''; 
  List<MaterialModel> materialSearchResults = [];
  List<ProfeesionModel> professionSearchResults = [];

  void searchMaterialsAndProfessions(String query) async {
    setState(() {
      searchQuery = query;
      materialSearchResults = [];
      professionSearchResults = [];
    });

    if (query.isNotEmpty) {
      List<MaterialModel> materials = await ApiImpl().getMaterials(query);
      List<ProfeesionModel> professions = await ApiImpl().getProfessions(query);

      setState(() {
        materialSearchResults = materials;
        professionSearchResults = professions;
      });
    }
  }

  Future<String> getNameFromFirebase() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int phone = prefs.getInt('Phone') ?? 0; // Set the default value to 0

    if (phone != 0) {
      var response = await FirebaseFirestore.instance
          .collection('Signup')
          .where('Phone', isEqualTo: phone)
          .get();
      if (response.docs.isNotEmpty) {
        final user = response.docs.first;
        name = user.data()['fullname'] ?? '';
        return name;
      }
    }
    return ''; 
  }

  Future<String> getImageUrlFromFirebase() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int phone = prefs.getInt('Phone') ?? 0; // Set the default value to 0

    if (phone != 0) {
      var response = await FirebaseFirestore.instance
          .collection('Signup')
          .where('Phone', isEqualTo: phone)
          .get();
      if (response.docs.isNotEmpty) {
        final user = response.docs.first;
        imageUrl = user.data()['ImageURL'] ?? '';
        return imageUrl;
      }
    }
    return ''; 
  }

  

  @override
  void initState() {
    super.initState();
    _nameFetchedFuture = getNameFromFirebase().then((name) {
      if (name.isNotEmpty) {
        setState(() {
          this.name = name;
        });
        return true;
      } else {
        return false;
      }
    });

    _imageFetchedFuture = getImageUrlFromFirebase().then((imageUrl) {
      if (imageUrl.isNotEmpty) {
        setState(() {
          this.imageUrl = imageUrl;
        });
        return true;
      } else {
        return false;
      }
    });

    imageSliders = images
        .map((item) => ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(5.0)),
              child: Stack(
                children: <Widget>[
                  Image.asset(
                    item,
                    fit: BoxFit.fitWidth,
                  ),
                ],
              ),
            ))
        .toList();

    
    materialList = [
      BuildingMaterials(
        imageUrl: "assets/images/brick.png",
        materialName: "Bricks",
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>  BrickServices(materialName: "Bricks")),
          );
        },
      ),
      BuildingMaterials(
        imageUrl: "assets/images/cement.png",
        materialName: "Cement",onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => BrickServices(materialName: "Cement")),
          );
        },
      ),
      BuildingMaterials(
        imageUrl: "assets/images/glass.png",
        materialName: "Glass",
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>BrickServices(materialName: "Glass")),
          );
        },
      ),
      BuildingMaterials(
        imageUrl: "assets/images/sand.png",
        materialName: "Sand",
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => BrickServices(materialName: "Sand")),
          );
        },
      ),
      BuildingMaterials(
        imageUrl: "assets/images/steel.png",
        materialName: "Metal",
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => BrickServices(materialName: "Metal")),
          );
        },
      ),
      BuildingMaterials(
        imageUrl: "assets/images/lumber.png",
        materialName: "Lumber",
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>BrickServices(materialName: "Lumber")),
          );
        },
      ),
      BuildingMaterials(
        imageUrl: "assets/images/wire.png",
        materialName: "Electronics",
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>BrickServices(materialName: "Electronics")),
          );
        },
      ),
    ];

laborerList = [
  Laborer(
    imageUrl: "assets/images/manager.png",
    laborerName: "Civil Engineer",
    onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Engineer()),
          );
        },
  ),
  Laborer(
    imageUrl: "assets/images/construction.png",
    laborerName: "Mason",
    onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Mason()),
          );
        },
  ),
  Laborer(
    imageUrl: "assets/images/electrician.png",
    laborerName: "Electrician",
    onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Electrician()),
          );
        },
  ),
  Laborer(
    imageUrl: "assets/images/carpenter.png",
    laborerName: "Carpenter",
    onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Carpenter()),
          );
        },
  ),
  Laborer(
    imageUrl: "assets/images/glazier.png",
    laborerName: "Glazier",
    onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Glazier()),
          );
        },
  ),
  Laborer(
    imageUrl: "assets/images/plumber.png",
    laborerName: "Plumber",
    onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Plumber()),
          );
        },
  ),
  Laborer(
    imageUrl: "assets/images/painter.png",
    laborerName: "Painter",
    onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Painter()),
          );
        },
  ),
];

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(left: 5),
          child: Column(
            children: [
              Row(
                children: [
                  FutureBuilder<bool>(
                    future: _imageFetchedFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return const Text('Error fetching image');
                      } else {
                        return Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder:(context) => const Profile(),));
                            },
                            child: CircleAvatar(
                              radius: 25,
                              backgroundImage: snapshot.hasData && snapshot.data == true
                                ? NetworkImage(imageUrl)
                                : Image.asset(
                                  "assets/images/pr.jpg",
                                  fit: BoxFit.cover,
                                ).image, 
                            ),
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FutureBuilder<bool>(
                          future: _nameFetchedFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return const Text('Error fetching name');
                            } else {
                              return Text(
                                snapshot.data == true
                                    ? 'Welcome, $name'
                                    : 'Welcome, User',
                                style: const TextStyle(
                                    fontSize: 15, color: Colors.black),
                              );
                            }
                          },
                        ),

                        const SizedBox(
                          height: 5,
                        ),
                        const Text(
                          "What are you looking for?",
                          style: TextStyle(
                              fontSize: 14,
                              color: Color.fromARGB(255, 164, 159, 159)),
                        )
                      ],
                    ),
                  )
                ],
              ),
              Padding(
                  padding: const EdgeInsets.only(
                      top: 18.0, left: 10, right: 10,),
                  child: SizedBox(
                    height: 55,
                    child: TextFormField(
                      onTap: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Search()));
                      },
                      decoration: InputDecoration(
                        suffixIcon: const Icon(Icons.search),
                        hintText: 'Search your services',
                        hintStyle: const TextStyle(
                          fontSize: 15,
                          letterSpacing: 1,
                        ),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(
                              width: 0.5,
                              color: Color.fromARGB(255, 154, 159, 156)),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                ),
              const SizedBox(
                height: 15,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8, right: 8),
                        child: CarouselSlider(
                          items: imageSliders,
                          carouselController: _controller,
                          options: CarouselOptions(
                              height: 200.0,
                              enlargeCenterPage: true,
                              autoPlay: true,
                              viewportFraction: 1.0,
                              enableInfiniteScroll: true,
                              onPageChanged: (index, reason) {
                                setState(() {
                                  _current = index;
                                });
                              }),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: images.asMap().entries.map((entry) {
                          return GestureDetector(
                            onTap: () => _controller.animateToPage(entry.key),
                            child: Container(
                              width: _current == entry.key ? 12.0 : 8.0,
                              height: _current == entry.key ? 12.0 : 8.0,
                              margin: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 4.0),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      width: 1, color: const Color(0xff1777AB,),),
                                  color: (Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Colors.white
                                          : const Color(0xff1777AB,))
                                      .withOpacity(
                                          _current == entry.key ? 0.9 : 0)),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Align(
                          alignment: AlignmentDirectional.topStart,
                          child: Text(
                            "BUILDING MATERIALS",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10,),
                      GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 120,
                          childAspectRatio: 3 / 2,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                        ),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: materialList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () {
                              materialList[index].onPressed!();
                            },
                            child: Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.white,
                                        spreadRadius: 0.5,
                                      ),]
                                  ),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 45,
                                        width: 70,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(10.0),
                                          child: Image.asset(
                                              materialList[index].imageUrl!),
                                        ),
                                      ),
                                      const SizedBox(
                                  height: 10,
                                ),
                                Text(materialList[index].materialName!),
                                    ],
                                  ),
                                  
                                ),
                                
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Align(
                          alignment: AlignmentDirectional.topStart,
                          child: Text(
                            "PROFESSIONALS",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10,),
                      GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 120,
                          childAspectRatio: 3 / 2,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                        ),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: laborerList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: (){
                              laborerList[index].onPressed!();
                            },
                            child: Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    boxShadow: const [
                                        BoxShadow(
                                          color: Colors.white,
                                          spreadRadius: 0.5,
                                        ),]
                                  ),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 45,
                                        width: 70,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(10.0),
                                          child: Image.asset(
                                              laborerList[index].imageUrl!),
                                        ),
                                      ),
                                      const SizedBox(
                                  height: 10,
                                ),
                                Text(laborerList[index].laborerName!),
                                    ],
                                  ),
                                ),
                                
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 10,),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BuildingMaterials {
  String? imageUrl, materialName;
  Function? onPressed;

  BuildingMaterials({this.imageUrl, this.materialName, this.onPressed});
}

class Laborer {
  String? imageUrl, laborerName;
  Function? onPressed;

  Laborer({this.imageUrl, this.laborerName,this.onPressed});
}
