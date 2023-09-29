import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/custom_alert_dialog.dart';
import '../../../widgets/custom_toast.dart';

class DetailTodoController extends GetxController {
  //TODO: Implement DetailTodoController

  final count = 0.obs;
  final Map<String, dynamic> argsData = Get.arguments;
  RxBool isLoading = false.obs;
  RxBool isLoadingCreateTodo = false.obs;

  TextEditingController titleC = TextEditingController();
  TextEditingController descriptionC = TextEditingController();
  TextEditingController namaC = TextEditingController();
  TextEditingController tanggalC = TextEditingController();
  TextEditingController tanggalKemC = TextEditingController();
  TextEditingController statusC = TextEditingController();
  TextEditingController keteranganC = TextEditingController();
  String image = "";
  String imageName = "";

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  @override
  void onInit() {
    super.onInit();
    titleC.text = argsData["title"];
    descriptionC.text = argsData["description"];
    namaC.text = argsData["nama_peminjam"];
    tanggalC.text = argsData["tanggal_pinjam"];
    tanggalKemC.text = argsData["tanggal_kembali"];
    statusC.text = argsData["status"];
    keteranganC.text = argsData["keterangan"];
    image = argsData["image"];
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();

    titleC.dispose();
    descriptionC.dispose();
  }

  void increment() => count.value++;

  Future<void> deleteTodo() async {
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
          await firestore.collection('todos').doc(argsData['id']).delete();
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
