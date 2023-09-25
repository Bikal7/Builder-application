import 'package:builder/Add%20Info/editProfession.dart';
import 'package:builder/profession_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../bloc/apiservices/apiImpl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../bloc/apiservices/apiService.dart';

class Carpenter extends StatefulWidget {
  const Carpenter({super.key});

  @override
  State<Carpenter> createState() => _CarpenterState();
}

class _CarpenterState extends State<Carpenter> {
  Api apiService = ApiImpl();
  int number=9828491612;
  bool isAdmin=false;
  bool admin=false;

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

  @override
  void initState() {
    areYouAdmin();
    super.initState();
  }

  Future<void>deleteProfessionFromFirebase(int phone)async{
    try{
      bool result=await apiService.deleteProfession(phone);
      if(result){
      showSnackBar("Record Successfully deleted");
      }else{
        showSnackBar("Unable to delete record");
      }
    }catch(e){
      print('Error deleting material: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error deleting material.'),
        ),
      );
    }
  }

  showSnackBar(String message){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void _editProfession(ProfeesionModel profession){
    Navigator.push(context,
    MaterialPageRoute(builder: (context)=>EditProfession(
      profession: profession,
    )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Professions',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        },
        icon:const Icon(Icons.arrow_back_ios),),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: StreamBuilder<List<ProfeesionModel>>(
          stream: apiService.getProfessions("Carpenter").asStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
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
            } else {
              final professionList = snapshot.data!;
              return ListView.builder(
                itemCount: professionList.length,
                itemBuilder: (BuildContext context, int index) {
                  final profession = professionList[index];
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
                                                    backgroundImage: NetworkImage(profession.imageUrl)
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  IconButton(
                                                    onPressed: () async{
                                                      try {
                                                        await launch('tel://${profession.phone}');
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
                                                  const SizedBox(height: 10),
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
                                                          profession.wName,
                                                          style: const TextStyle(
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.bold),
                                                          maxLines: 1,
                                                          overflow: TextOverflow.fade,
                                                          softWrap: false,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: MediaQuery.of(context).size.width *
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
                                                        profession.profession,
                                                        style: const TextStyle(fontSize: 14),
                                                        maxLines: 1,
                                                        overflow: TextOverflow.fade,
                                                        softWrap: false,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: MediaQuery.of(context).size.width *
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
                                                          const Text("Experience:"),
                                                          const SizedBox(
                                                            width: 3,
                                                          ),
                                                          Text(
                                                            "${profession.exp}" ,
                                                            style: const TextStyle(fontSize: 14),
                                                            maxLines: 1,
                                                            overflow: TextOverflow.fade,
                                                            softWrap: false,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: MediaQuery.of(context).size.width *
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
                                                          const Text("Phone Number:"),
                                                          const SizedBox(
                                                            width: 3,
                                                          ),
                                                          Text(
                                                            "${profession.phone}",
                                                            style: const TextStyle(fontSize: 14),
                                                            maxLines: 1,
                                                            overflow: TextOverflow.fade,
                                                            softWrap: false,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          isAdmin?Column(
                                            children: [
                                              IconButton(onPressed: (){
                                                _editProfession(profession);
                                              }, icon: const Icon(Icons.edit,size: 25,color:Colors.blue)),
                                              const SizedBox(height: 10,),
                                              IconButton(onPressed: (){
                                                deleteProfessionFromFirebase(profession.phone);
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
                                                            fontWeight: FontWeight.bold),
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
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}