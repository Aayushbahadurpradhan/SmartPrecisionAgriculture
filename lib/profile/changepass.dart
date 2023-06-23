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

  void _saveProfile() async {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      if (_usernameController.text.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .update({
          'username': _usernameController.text,
          'contact': _contactController.text,
        });
      }

      if (_passwordController.text.isNotEmpty) {
        try {
          final credential = EmailAuthProvider.credential(
              email: user!.email!, password: _currentPasswordController.text);
          await user!.reauthenticateWithCredential(credential);
          await user!.updatePassword(_passwordController.text);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Password updated successfully!'),
            ),
          );
        } on FirebaseAuthException catch (e) {
          if (e.code == 'wrong-password') {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Invalid current password.'),
              ),
            );
            return;
          }
        }
      }

      setState(() {
        _isEditing = false; // Disable editing mode
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Profile updated successfully!'),
        ),
      );
    }
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
            SizedBox(height: 20),
            TextFormField(
              controller: _emailController,
              enabled: false,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _contactController,
              enabled: _isEditing,
              decoration: InputDecoration(
                labelText: 'Contact',
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _currentPasswordController,
              enabled: _isEditing,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Current Password',
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _passwordController,
              enabled: _isEditing,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'New Password',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isEditing ? _saveProfile : _updateProfile,
              child: Text(_isEditing ? 'Save Profile' : 'Edit Profile'),
              style: ElevatedButton.styleFrom(
                primary: _isEditing ? Colors.green : Colors.orange,
                textStyle: TextStyle(fontSize: 18),
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



























































































