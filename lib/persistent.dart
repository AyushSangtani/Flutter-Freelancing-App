import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'global_var.dart';

class Persistent{
  static List<String> jobCategoryList = [
    'Architecture and Construction',
    'Education and Training',
    'Development - Programming',
    'Business',
    'Information Technology',
    'Human Resources',
    'Marketing',
    'Design',
    'Accounting',
  ] ;

  // get user data
  void getMyData() async
  {
    final DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    name = userDoc.get('name');
    userImage = 'https://img.freepik.com/premium-vector/user-profile-icon-flat-style-member-avatar-vector-illustration-isolated-background-human-permission-sign-business-concept_157943-15752.jpg';
    location = userDoc.get('address');
  }
}