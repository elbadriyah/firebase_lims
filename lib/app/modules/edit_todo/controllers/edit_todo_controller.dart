import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crud_firebase/app/modules/add_todo/views/camera_view.dart';
import 'package:get/get.dart';

import '../../../widgets/custom_toast.dart';

class EditTodoController extends GetxController {
  //TODO: Implement EditTodoController

  final count = 0.obs;
  final Map<String, dynamic> argsData = Get.arguments;

  RxBool isLoading = false.obs;
  RxBool isLoadingCreateTodo = false.obs;
  RxString radio = "tersedia".obs;
  String image = "";
  File? file;

  TextEditingController titleC = TextEditingController();
  TextEditingController descriptionC = TextEditingController();
  TextEditingController namaC = TextEditingController();
  TextEditingController tanggalC = TextEditingController();
  TextEditingController tanggalKemC = TextEditingController();
  TextEditingController statusC = TextEditingController();
  TextEditingController keteranganC = TextEditingController();

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
    radio.value = argsData["status"];
    keteranganC.text = argsData["keterangan"];
    image = argsData["image"];
  }

  @override
  void onReady() {
    super.onReady();
  }

  void setRadio(value) {
    radio.value = value;
  }

  @override
  void onClose() {
    super.onClose();
    titleC.dispose();
    descriptionC.dispose();
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

  Future<void> editTodo() async {
    if (titleC.text.isNotEmpty && descriptionC.text.isNotEmpty) {
      isLoading.value = true;

      if (isLoadingCreateTodo.isFalse) {
        await editTodoData();
        isLoading.value = false;
      }
    } else {
      isLoading.value = false;
      CustomToast.errorToast('Error', 'you need to fill all form');
    }
  }

  editTodoData() async {
    isLoadingCreateTodo.value = true;
    String adminEmail = auth.currentUser!.email!;
    // if (file != null) {
    try {
      String uid = auth.currentUser!.uid;
      CollectionReference<Map<String, dynamic>> childrenCollection =
          await firestore.collection("todos");

      DocumentReference todo =
          await firestore.collection("todos").doc(argsData["id"]);

      if (file != null) {
        String fileName = file!.path.split('/').last;
        String ext = fileName.split(".").last;
        String upDir = "image/${argsData["id"]}.$ext";

        var snapshot =
            await firebaseStorage.ref().child('images/$upDir').putFile(file!);
        var downloadUrl = await snapshot.ref.getDownloadURL();

        await childrenCollection.doc(argsData["id"]).update({
          "title": titleC.text,
          "description": descriptionC.text,
          "nama_peminjam": namaC.text,
          "tanggal_pinjam": tanggalC.text,
          "tanggal_kembali": tanggalKemC.text,
          "status": radio.value,
          "keterangan": keteranganC.text,
          "image": downloadUrl,
        });
      } else {
        await childrenCollection.doc(argsData["id"]).update({
          "title": titleC.text,
          "description": descriptionC.text,
          "nama_peminjam": namaC.text,
          "tanggal_pinjam": tanggalC.text,
          "tanggal_kembali": tanggalKemC.text,
          "status": radio.value,
          "keterangan": keteranganC.text,
        });
      }

      Get.back(); //close dialog
      Get.back(); //close form screen
      CustomToast.successToast('Success', 'Berhasil memperbarui data peminjaman');

      isLoadingCreateTodo.value = false;
    } on FirebaseAuthException catch (e) {
      isLoadingCreateTodo.value = false;
      CustomToast.errorToast('Error', 'error : ${e.code}');
    } catch (e) {
      isLoadingCreateTodo.value = false;
      CustomToast.errorToast('Error', 'error : ${e.toString()}');
    }
    // } else {
    //   CustomToast.errorToast('Error', 'gambar tidak boleh kosong !!');
    // }
  }
}
