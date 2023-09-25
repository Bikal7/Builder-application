import 'package:flutter/material.dart';

class Policy extends StatefulWidget {
  const Policy({super.key});

  @override
  State<Policy> createState() => _PolicyState();
}

class _PolicyState extends State<Policy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'PRIVACY POLICY',
          style: TextStyle(color: Color(
              0xff1777AB,
            ),fontSize: 20),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        },
        icon:const Icon(Icons.arrow_back_ios),),
        iconTheme: const IconThemeData(color: Color(0xff1777AB,),),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 15,right: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('''Builder is your go-to app for seamless home improvement and construction projects. With its user-friendly interface, finding skilled experts for at-home services has never been easier. From plumbing and electrical work to carpentry and painting, Builder connects you with reliable professionals who can transform your vision into reality. But that's not all! Need building materials for your dream home? Look no further. Builder lets you effortlessly browse and contact various dealers to purchase essential construction supplies. Whether it's cement, lumber, sand, bricks, or other materials, our app streamlines the process, putting a wide range of options at your fingertips.''',
            style: TextStyle(fontSize: 16,fontWeight: FontWeight.w300),
            ),
            SizedBox(height: 20),
            Text(
              'AGREEMENT TO TERMS',
              style: TextStyle(
                fontSize: 18,
                color: Color(
                      0xff1777AB,
                    ),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5),
            Text(
              'By using the Builder app, you agree to our comprehensive privacy policy that ensures the security and confidentiality of your personal information. We are committed to safeguarding your data and maintaining the highest standards of privacy protection. Our privacy policy outlines how we collect, use, and share your information to enhance your experience while using the app. It also highlights your rights and choices concerning your data. We encourage you to review the privacy policy carefully to understand how your information is handled. Your continued use of the Builder app constitutes your consent to the terms of our privacy policy, demonstrating your trust in our dedication to providing you with a secure and seamless home improvement and construction project experience.',
              style: TextStyle(fontSize: 16,fontWeight: FontWeight.w300),
            ),
            SizedBox(height: 20),
            Text(
              'USER REGISTRATION',
              style: TextStyle(
                fontSize: 18,
                color:Color(0xff1777AB,),
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '''As you embark on your journey with the Builder app, registration becomes your gateway to a world of innovation and transformation. Safeguarding your password is pivotal, as it holds the key to your personal haven within our digital realm. Your account is a canvas for creativity, and you're responsible for its guardianship. While you choose a username that resonates with your spirit, rest assured, we stand against any shadows of inappropriateness. Our commitment to harmony empowers us to remove, reclaim, or modify usernames that diverge from our community's ethos. Together, we'll craft a digital haven where your aspirations thrive amidst a landscape of respect and inspiration.''',
              style: TextStyle(fontSize: 16,fontWeight: FontWeight.w300),
            ),
            SizedBox(height: 10,)
          ],
        ),
      ),
    );
  }
}
