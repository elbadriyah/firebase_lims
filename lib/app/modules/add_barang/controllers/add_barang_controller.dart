import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crud_firebase/app/widgets/custom_toast.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class AddBarangController extends GetxController {
  @override
  onClose() {
    namabrgC.dispose();
    spfkC.dispose();
    merkC.dispose();
    thnbeliC.dispose();
    sumberdanaC.dispose();
    jumlahC.dispose();
  }

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

  Future<void> addBarang() async {
    if (namabrgC.text.isNotEmpty && spfkC.text.isNotEmpty) {
      isLoading.value = true;

      if (isLoadingCreateBarang.isFalse) {
        await createBarangData();
        isLoading.value = false;
      }
    } else {
      isLoading.value = false;
      CustomToast.errorToast('Error', 'you need to fill all form');
    }
  }

  createBarangData() async {
    isLoadingCreateBarang.value = true;
    String adminEmail = auth.currentUser!.email!;
    try {
      String uid = auth.currentUser!.uid;
      CollectionReference<Map<String, dynamic>> childrenCollection =
          await firestore.collection("users").doc(uid).collection("items");

      var uuidItem = Uuid().v1();

      await childrenCollection.doc(uuidItem).set({
        "task_id": uuidItem,
        "nama_barang": namabrgC.text,
        "spesifikasi": spfkC.text,
        "merk": merkC,
        "tahun_beli":thnbeliC,
        "sumber_dana":sumberdanaC,
        "created_at": DateTime.now().toIso8601String(),
      });

      Get.back(); //close dialog
      Get.back(); //close form screen
      CustomToast.successToast('Success', 'Berhasil menambahkan barang');

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
