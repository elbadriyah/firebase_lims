import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crud_firebase/app/modules/add_barang/views/camera_view.dart';
import 'package:flutter_crud_firebase/app/widgets/custom_toast.dart';
import 'package:get/get.dart';

class EditBarangController extends GetxController {
  final count = 0.obs;
  final Map<String, dynamic> argsData = Get.arguments;

  RxBool isLoading = false.obs;
  RxBool isLoadingCreateBarang = false.obs;
  String image = "";
  File? file;

  TextEditingController namabrgC = TextEditingController();
  TextEditingController spfkC = TextEditingController();
  TextEditingController merkC = TextEditingController();
  TextEditingController thnbeliC = TextEditingController();
  TextEditingController sumberdanaC = TextEditingController();
  TextEditingController jumlahC = TextEditingController();

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

  void pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      file = File(result.files.single.path ?? '');
    } else {
      // User canceled the picker
    }
    update();
  }

  void toCamera() {
    Get.to(CameraView())!.then((result) {
      file = result;
      update();
    });
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
          await firestore.collection("items");
      String fileName = file!.path.split('/').last;
      String ext = fileName.split(".").last;
      String upDir = "image/${argsData["id"]}.$ext";

      var snapshot =
          await firebaseStorage.ref().child('images/$upDir').putFile(file!);
      var downloadUrl = await snapshot.ref.getDownloadURL();

      await childrenCollection.doc(argsData["id"]).update({
        "nama_barang": namabrgC.text,
        "spesifikasi": spfkC.text,
        "merk": merkC,
        "tahun_beli": thnbeliC,
        "sumber_dana": sumberdanaC,
        "jumlah": jumlahC,
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
