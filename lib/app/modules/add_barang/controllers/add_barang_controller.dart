import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crud_firebase/app/modules/add_barang/views/camera_view.dart';
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
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  File? file;
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

  createBarangData() async {
    isLoadingCreateBarang.value = true;
    String adminEmail = auth.currentUser!.email!;
    try {
      String uid = auth.currentUser!.uid;
      CollectionReference<Map<String, dynamic>> childrenCollection =
          await firestore.collection("items");

      var uuidItem = Uuid().v1();
      String fileName = file!.path.split('/').last;
      String ext = fileName.split(".").last;
      String upDir = "${uuidItem}.$ext";

      var snapshot =
          await firebaseStorage.ref().child('images/$upDir').putFile(file!);
      var downloadUrl = await snapshot.ref.getDownloadURL();

      await childrenCollection.doc(uuidItem).set({
        "task_id": uuidItem,
        "nama_barang": namabrgC.text,
        "spesifikasi": spfkC.text,
        "merk": merkC.text,
        "tahun_beli": thnbeliC.text,
        "sumber_dana": sumberdanaC.text,
        "jumlah": jumlahC.text,
        "image": downloadUrl,
        "created_at": DateTime.now().toIso8601String(),
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
