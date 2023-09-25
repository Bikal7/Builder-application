import 'package:builder/Add%20Info/editMaterial.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Helper/helper.dart';
import '../bloc/apiservices/apiImpl.dart';
import '../bloc/apiservices/apiService.dart';
import '../material_model.dart';
import 'package:url_launcher/url_launcher.dart';


class BrickServices extends StatefulWidget {
  String? materialName;
   BrickServices({Key? key,this.materialName}) : super(key: key);

  @override
  State<BrickServices> createState() => _BrickServicesState();
}

class _BrickServicesState extends State<BrickServices> {
  Api apiService = ApiImpl();
  int number=9828491612;
  bool isAdmin=false;
  bool admin=false;
  bool isTextVisible=false;
   double? lat, long;
  String? address;
  String? distance;
  String? currentAddress;
  Map<String, String?> calculatedDistances = {};
  bool isApiLoaded=false;
  bool loader=false;

  areYouAdmin()async {
    final SharedPreferences prefs=await SharedPreferences.getInstance();
    int phone=prefs.getInt("Phone")??0;
    if(phone!=0){
      if(phone==number){
        isAdmin=true;
      }else{
        isAdmin=false;
      }
    }
  }

  Future<void> deleteMaterialFromFirestore(int phone) async {
    try {
      bool result= await apiService.deleteMaterial(phone);
      if(result){
      showSnackBar("Record Successfully deleted");
      }else{
        showSnackBar("Unable to delete record");
      }
    } catch (e) {
      print('Error deleting material: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error deleting material.'),
        ),
      );
    }
     setState(() {});
  }

  showSnackBar(String message){
       ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
          content: Text(message),
        ),
      );
  }

    void _editMaterial(MaterialModel material) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditMaterial(
          material: material,
        ),
      ),
    );
  }


  @override
  void initState() {
    areYouAdmin();
    super.initState();
  }
 
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Materials', style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        },
        icon:const Icon(Icons.arrow_back_ios),),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: Stack(children: [
          ui()
        ],)
      ),
    );
  }
   
Widget ui(){
  return StreamBuilder<List<MaterialModel>>(
          stream: !isApiLoaded? apiService.getMaterials(widget.materialName!).asStream() :null,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return  Center(
                child: Helper.backdropFilter(context),
              );
            }else if (snapshot.hasError) {
              return const Center(
                child: Text('Error fetching data'),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 300),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 50,
                        width: 50,
                        child: Image.asset("assets/images/no-connection.png")
                      ),
                      const Text('No data found!',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                    ],
                  ),
                ),
              );
            }
            else{
              final materialsList = snapshot.data!;
                 
                    isApiLoaded=true;
                
              return ListView.builder(
                itemCount: materialsList.length,
                itemBuilder: (BuildContext context, int index) {
             
                  final material = materialsList[index];
                  getCurrentLocation(material.bName);
                  return NotificationListener<ScrollNotification>(
                    onNotification: (notification) {
        if (notification is OverscrollNotification) {
          if (notification.overscroll > 0) {
            // Scrolling down, fade out the overflowing text
            setState(() {
              isTextVisible = false;
            });
          } else {
            // Scrolling up or not overscrolling, fade in the text
            setState(() {
              isTextVisible = true;
            });
          }
        }
        return false;
      },
                    child: Padding(
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
                          height: MediaQuery.of(context).size.height * 0.275 + (index * 10),
                          width: MediaQuery.of(context).size.width * 0.95,
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.95,
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Column(
                                  children: [
                                    Container(
                                      height: MediaQuery.of(context).size.height * 0.15,
                                      width: MediaQuery.of(context).size.width * 0.9,
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
                                              padding: const EdgeInsets.only(left: 5),
                                              child: SizedBox(
                                                height: 200,
                                                width: 50,
                                                child: Column(
                                                  children: [
                                                    CircleAvatar(
                                                      radius: 25,
                                                      backgroundImage: NetworkImage(material.imageUrl),
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    IconButton(
                                                      onPressed: () async{
                                                        try {
                                                          await launch('tel://${material.phone}');
                                                        } catch (e) {
                                                        print(e);
                                                        }
                                                      },
                                                      icon: const Icon(Icons.phone, size: 30, color: Colors.green,),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 10,),
                                            Expanded(
                                              child: SizedBox(
                                                height: 200,
                                                child: Column(
                                                  children: [
                                                    const SizedBox(height: 10,),
                                                    Align(
                                                      alignment: Alignment.topLeft,
                                                      child: SizedBox(
                                                        width: MediaQuery.of(context).size.width * 0.9,
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
                                                            material.bName,
                                                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                                            maxLines: 1,
                                                            overflow: TextOverflow.fade,
                                                            softWrap: false,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Align(
                                                      alignment: Alignment.topLeft,
                                                      child: SizedBox(
                                                        width: MediaQuery.of(context).size.width * 0.99,
                                                        height: 25,
                                                        child: AnimatedOpacity(
                                                          opacity: isTextVisible ? 1.0 : 1.0,
                                                          duration: const Duration(milliseconds: 200),
                                                          child: Row(
                                                            children: [
                                                              const Text("Supplier:",style: TextStyle(fontSize: 14),
                                                                maxLines: 1,
                                                                overflow: TextOverflow.fade,
                                                                softWrap: false,),
                                                                const SizedBox(width: 3,),
                                                              Text(
                                                                material.sHead,
                                                                style: const TextStyle(fontSize: 14),
                                                                maxLines: 1,
                                                                overflow: TextOverflow.fade,
                                                                softWrap: false,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Align(
                                                      alignment: Alignment.topLeft,
                                                      child: SizedBox(
                                                        width: MediaQuery.of(context).size.width * 0.99,
                                                        height: 25,
                                                        child: AnimatedOpacity(
                                                          opacity: isTextVisible ? 1.0 : 1.0,
                                                          duration: const Duration(milliseconds: 200), 
                                                          child: Row(
                                                            children: [
                                                              const Text("Phone:",style:TextStyle(fontSize: 14)),
                                                              Text(
                                                                material.phone.toString(),
                                                                style: const TextStyle(fontSize: 14),
                                                                maxLines: 1,
                                                                overflow: TextOverflow.fade,
                                                                softWrap: false,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            isAdmin?Column(
                                              children: [
                                                IconButton(onPressed: (){
                                                  _editMaterial(material);
                                                }, icon: const Icon(Icons.edit,size: 25,color:Colors.blue)),
                                                const SizedBox(height: 10,),
                                                IconButton(onPressed: (){
                                                  deleteMaterialFromFirestore(material.phone);
                                                }, icon: const Icon(Icons.delete,size: 25,color:Colors.red)),
                                              ],
                                            ):const SizedBox()
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: MediaQuery.of(context).size.height * 0.1,
                                      width: MediaQuery.of(context).size.width * 0.9,
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
                                              padding: const EdgeInsets.only(left: 5),
                                              child: SizedBox(
                                                height: 200,
                                                width: 50,
                                                child: Align(
                                                  alignment: Alignment.topLeft,
                                                  child: IconButton(
                                                    onPressed: () async{
                                                       await Helper().launchMaps(currentAddress!);
                                                     
                                                    },
                                                    icon: const Icon(Icons.location_on, size: 40, color: Colors.red,),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 10,),
                                            Expanded(
                                              child: SizedBox(
                                                height: 200,
                                                child: Column(
                                                  children: [
                                                    const SizedBox(height: 10,),
                                                    Align(
                                                      alignment: Alignment.topLeft,
                                                      child: SizedBox(
                                                        width: MediaQuery.of(context).size.width * 0.9,
                                                        height: 25,
                                                        child: Text(
                                                          material.address,
                                                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                                          maxLines: 1,
                                                          overflow: TextOverflow.fade,
                                                          softWrap: false,
                                                        ),
                                                      ),
                                                    ),
                                                    Align(
                                                      alignment: Alignment.topLeft,
                                                      child: SizedBox(
                                                        width: MediaQuery.of(context).size.width * 0.99,
                                                        height: 30,
                                                        child:  FadeTransition(
                                                          opacity: const AlwaysStoppedAnimation(1),
                                                          child: Text(
                                                            calculatedDistances[material.bName] ?? "0 KM",
                                                            style: const TextStyle(fontSize: 14),
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
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            } 
          },
        );
}
  getCurrentLocation(String hardwareName) async {
    LocationPermission permission = await Helper().getPermission();
    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      Stream<Coordinate> coordinateStream = Helper().getCoordinateStream();
      coordinateStream.listen((Coordinate coordinate) async {
        setState(() {
          lat = coordinate.latitude;
          long = coordinate.longitude;
          address = coordinate.address!;
        });

        var response = await FirebaseFirestore.instance
            .collection('Materials')
            .where('bName', isEqualTo: hardwareName)
            .get();
        final user = response.docs.first;

        double haversine = await Helper().calculateDistance(
            lat!, long!, double.parse(user.data()['Latitude']), double.parse(user.data()['Longitude']));

        setState(() {
          currentAddress = user.data()['currentAddress'];
          calculatedDistances[hardwareName] = '${haversine.toStringAsFixed(3)} KM';
          print('Distance is $distance');
        });
     

     print("current address $currentAddress");
     print("lat address $lat");
      print("long address $long");
     

        // sendCurrentLocationInFireBase(lat!, long!, address!);
      });
    }
  }
}
