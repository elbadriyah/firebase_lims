import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailBarangController extends GetxController {
  final Map<String, dynamic> argsData = Get.arguments;

  RxBool isLoading = false.obs;
  RxBool isLoadingCreateBarang = false.obs;

  TextEditingController namabrgC = TextEditingController();
  TextEditingController spfkC = TextEditingController();
  TextEditingController merkC = TextEditingController();
  TextEditingController thnbeliC = TextEditingController();
  TextEditingController sumberdanaC = TextEditingController();
  TextEditingController jumlahC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  onClose() {
    namabrgC.dispose();
    spfkC.dispose();
    merkC.dispose();
    thnbeliC.dispose();
    sumberdanaC.dispose();
    jumlahC.dispose();
  }

  @override
  void onInit() {
    super.onInit();
    namabrgC.text = argsData["nama_barang"];
    spfkC.text = argsData["spesifikasi"];
    merkC.text = argsData["merk"];
    thnbeliC.text = argsData["tahun_beli"];
    sumberdanaC.text = argsData["sumber_dana"];
    jumlahC.text = argsData["jumlah"];
  }
}
