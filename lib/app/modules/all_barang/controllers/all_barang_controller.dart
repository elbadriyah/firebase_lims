import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AllBarangController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<QuerySnapshot<Map<String, dynamic>>> getAllResult() async {
    String uid = auth.currentUser!.uid;
    QuerySnapshot<Map<String, dynamic>> query = await firestore
        .collection("items")
        .orderBy(
          "created_at",
          descending: true,
        )
        .get();
    return query;
  }
}
