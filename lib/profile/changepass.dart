import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateProfileScreen extends StatefulWidget {
  @override
  _UpdateProfileScreenState createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  User? user;
  late DocumentSnapshot userData;
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _contactController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _currentPasswordController = TextEditingController();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  void fetchUserData() async {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();
      setState(() {
        user = currentUser;
        this.userData = userData;
        _usernameController.text = userData.get('username') ?? '';
        _emailController.text = user?.email ?? '';
        _contactController.text = userData.get('contact') ?? '';
      });
    }
  }

  void _updateProfile() async {
    setState(() {
      _isEditing = true; // Enable editing mode
    });
  }


  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Update Profile'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Update Profile'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: ListView(
          children: [
            SizedBox(height: 20),
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.grey,
              backgroundImage: NetworkImage(
                'https://img.freepik.com/premium-vector/figure-person-hand-drawn-outline-doodle-icon-sketch-illustration-standing-figure-print-web-mobile-infographics-isolated-white-background_107173-17483.jpg', // Replace with image URL
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _usernameController,
              enabled: _isEditing,
              decoration: InputDecoration(
                labelText: 'Username',
              ),
            ),


          ],
        ),
      ),
    );
  }
}