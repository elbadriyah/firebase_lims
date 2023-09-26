import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_lims/app/widgets/custom_alert_dialog.dart';
import 'package:firebase_lims/app/widgets/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailTodoController extends GetxController {
  final Map<String, dynamic> argsData = Get.arguments;

  RxBool isLoading = false.obs;
  RxBool isLoadingCreateTodo = false.obs;

  TextEditingController titleC = TextEditingController();
  TextEditingController descriptionC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> deleteTodo() async {
    CustomAlertDialog.showPresenceAlert(
      title: "Hapus data todo",
      message: "Apakah anda ingin menghapus data todo ini ?",
      onCancel: () => Get.back(),
      onConfirm: () async {
        Get.back(); // close modal
        Get.back(); // back page

        try {
          String uid = auth.currentUser!.uid;
          await firestore
              .collection('users')
              .doc(uid)
              .collection('todos')
              .doc(argsData['id'])
              .delete();
          CustomToast.successToast('Success', 'Data todo berhasil dihapus');
        } catch (e) {
          CustomToast.errorToast(
              "Error", "Error dikarenakan : ${e.toString()}");
        }
      },
    );
  }

  @override
  onClose() {
    titleC.dispose();
    descriptionC.dispose();
  }

  @override
  void onInit() {
    super.onInit();
    titleC.text = argsData["title"];
    descriptionC.text = argsData["description"];
  }
}
