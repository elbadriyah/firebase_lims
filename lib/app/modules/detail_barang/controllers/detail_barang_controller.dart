import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crud_firebase/app/widgets/custom_alert_dialog.dart';
import 'package:flutter_crud_firebase/app/widgets/custom_toast.dart';
import 'package:get/get.dart';

class DetailBarangController extends GetxController {
  final count = 0.obs;
  final Map<String, dynamic> argsData = Get.arguments;

  RxBool isLoading = false.obs;
  RxBool isLoadingCreateBarang = false.obs;

  TextEditingController namabrgC = TextEditingController();
  TextEditingController spfkC = TextEditingController();
  TextEditingController merkC = TextEditingController();
  TextEditingController thnbeliC = TextEditingController();
  TextEditingController sumberdanaC = TextEditingController();
  TextEditingController jumlahC = TextEditingController();
  String image = "";
  String imageName = "";

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;

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
    image = argsData["image"];
  }

  Future<void> deleteBarang() async {
    CustomAlertDialog.showPresenceAlert(
      title: "Hapus data peminjaman",
      message: "Apakah anda ingin menghapus data peminjaman ini ?",
      onCancel: () => Get.back(),
      onConfirm: () async {
        Get.back(); // close modal
        Get.back(); // back page
        try {
          await firebaseStorage.refFromURL(image).delete();

          String uid = auth.currentUser!.uid;
          await firestore.collection('items').doc(argsData['id']).delete();
          CustomToast.successToast(
              'Success', 'Data peminjaman berhasil dihapus');
        } catch (e) {
          CustomToast.errorToast(
              "Error", "Error dikarenakan : ${e.toString()}");
        }
      },
    );
  }
}
