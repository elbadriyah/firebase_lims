import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_crud_firebase/app/modules/add_todo/views/camera_view.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../../widgets/custom_toast.dart';

class AddTodoController extends GetxController {
  //TODO: Implement AddTodoController

  final count = 0.obs;
  RxBool isLoading = false.obs;
  RxBool isLoadingCreateTodo = false.obs;
  RxString radio = "tersedia".obs;

  // TextEditingController titleC = TextEditingController();
  TextEditingController descriptionC = TextEditingController();
  TextEditingController namaC = TextEditingController();
  TextEditingController tanggalC = TextEditingController();
  TextEditingController tanggalKemC = TextEditingController();
  TextEditingController statusC = TextEditingController();
  TextEditingController keteranganC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  File? file;
  List<QueryDocumentSnapshot<Map<String, dynamic>>>? items;
  Map<String, dynamic> selectedItem = {};

  SingleValueDropDownController cnt = SingleValueDropDownController();
  FocusNode searchFocusNode = FocusNode();

  @override
  void onInit() {
    super.onInit();

    tanggalC.text = DateFormat('d-M-yyyy').format(DateTime.now());
    tanggalKemC.text =
        DateFormat('d-M-yyyy').format(DateTime.now().add(Duration(days: 3)));

    getAllItems();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();

    // titleC.dispose();
    descriptionC.dispose();
  }

  void setRadio(value) {
    radio.value = value;
  }

  void increment() => count.value++;

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

  Future<void> getAllItems() async {
    String uid = auth.currentUser!.uid;
    QuerySnapshot<Map<String, dynamic>> query = await firestore
        .collection("items")
        .orderBy(
          "created_at",
          descending: true,
        )
        .get();

    items = query.docs;
    update();
  }

  Future<void> addTodo() async {
    if (descriptionC.text.isNotEmpty) {
      isLoading.value = true;

      if (isLoadingCreateTodo.isFalse) {
        await createTodoData();
        isLoading.value = false;
      }
    } else {
      isLoading.value = false;
      CustomToast.errorToast('Error', 'you need to fill all form');
    }
  }

  createTodoData() async {
    isLoadingCreateTodo.value = true;
    String adminEmail = auth.currentUser!.email!;
    if (file != null) {
      try {
        String uid = auth.currentUser!.uid;
        CollectionReference<Map<String, dynamic>> childrenCollection =
            await firestore.collection("todos");

        var uuidTodo = Uuid().v1();

        String fileName = file!.path.split('/').last;
        String ext = fileName.split(".").last;
        String upDir = "image/${uuidTodo}.$ext";

        var snapshot =
            await firebaseStorage.ref().child('images/$upDir').putFile(file!);
        var downloadUrl = await snapshot.ref.getDownloadURL();

        await childrenCollection.doc(uuidTodo).set({
          "task_id": uuidTodo,
          "item": cnt.dropDownValue!.value,
          "description": descriptionC.text,
          "nama_peminjam": namaC.text,
          "tanggal_pinjam": tanggalC.text,
          "tanggal_kembali": tanggalKemC.text,
          "status": radio.value,
          "keterangan": keteranganC.text,
          "image": downloadUrl,
          "created_at": DateTime.now().toIso8601String(),
        });

        Get.back(); //close dialog
        Get.back(); //close form screen
        CustomToast.successToast('Success', 'Berhasil menambahkan data pinjam');

        isLoadingCreateTodo.value = false;
      } on FirebaseAuthException catch (e) {
        isLoadingCreateTodo.value = false;
        CustomToast.errorToast('Error', 'error : ${e.code}');
      } catch (e) {
        isLoadingCreateTodo.value = false;
        CustomToast.errorToast('Error', 'error : ${e.toString()}');
      }
    } else {
      CustomToast.errorToast('Error', 'gambar tidak boleh kosong !!');
    }
  }
}
