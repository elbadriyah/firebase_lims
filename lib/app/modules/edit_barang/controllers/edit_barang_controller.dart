import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crud_firebase/app/widgets/custom_toast.dart';
import 'package:get/get.dart';

class EditBarangController extends GetxController {
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

  Future<void> editBarang() async {
    if (namabrgC.text.isNotEmpty && spfkC.text.isNotEmpty) {
      isLoading.value = true;

      if (isLoadingCreateBarang.isFalse) {
        await editBarangData();
        isLoading.value = false;
      }
    } else {
      isLoading.value = false;
      CustomToast.errorToast('Error', 'you need to fill all form');
    }
  }

  editBarangData() async {
    isLoadingCreateBarang.value = true;
    String adminEmail = auth.currentUser!.email!;
    try {
      String uid = auth.currentUser!.uid;
      CollectionReference<Map<String, dynamic>> childrenCollection =
          await firestore.collection("users").doc(uid).collection("items");

      await childrenCollection.doc(argsData["id"]).update({
        "nama_barang": namabrgC.text,
        "spesifikasi": spfkC.text,
        "merk": merkC,
        "tahun_beli": thnbeliC,
        "sumber_dana": sumberdanaC
      });

      Get.back(); //close dialog
      Get.back(); //close form screen
      CustomToast.successToast('Success', 'Berhasil memperbarui data barang');

      isLoadingCreateBarang.value = false;
    } on FirebaseAuthException catch (e) {
      isLoadingCreateBarang.value = false;
      CustomToast.errorToast('Error', 'error : ${e.code}');
    } catch (e) {
      isLoadingCreateBarang.value = false;
      CustomToast.errorToast('Error', 'error : ${e.toString()}');
    }
  }
}
