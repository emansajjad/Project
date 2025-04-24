import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_fyp/models/university_model.dart';

class UniversityService {
  Future<List<University>> fetchUniversities() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('UNI Dataset').get();
    return snapshot.docs.map((doc) {
      return University.fromFirestore(doc.data() as Map<String, dynamic>);
    }).toList();
  }
}
//fetch method fetches all the documents from the Firestore collection 'UNI Dataset'
// using get() returns a Future<List<University>>,
// meaning it fetches a list of University objects