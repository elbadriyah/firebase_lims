import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  //TODO: Implement RegisterController
  RxBool isloading = false.obs;
  RxBool obsecureText = true.obs;
  TextEditingController namalengkapC = new TextEditingController();
  TextEditingController emailC = new TextEditingController();
  TextEditingController passwordC = new TextEditingController();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> register() async {
    if (emailC.text.isNotEmpty && passwordC.text.isNotEmpty) {
      isloading.value = true;
      try {
        UserCredential respondentCredential =
            await auth.createUserWithEmailAndPassword(
                email: emailC.text.trim(), password: passwordC.text);
        if (respondentCredential.user != null) {
          String uid = respondentCredential.user!.uid;

          DocumentReference users = firestore.collection("users").doc(uid);
          await users.set({
            "user_id": uid,
            "name": namalengkapC.text,
            "email": emailC.text.trim(), //fungsi trim untuk menghilangkan spasi
            "created_at": DateTime.now().toIso8601String(),
          });
          await respondentCredential.user!.sendEmailVerification();
          auth.signOut();
          await auth.signInWithEmailAndPassword(
              email: emailC.text.trim(), password: passwordC.text);

          Get.back();
          Get.back();
          print("berhasil mendaftar");

          isloading.value = false;
          namalengkapC.clear();
          emailC.clear();
          passwordC.clear();
        }
      } on FirebaseAuthException catch (e) {
        isloading.value = false;
        if (e.code == 'weak-password') {
          print('Error, Kata sandi anda terlalu pendek');
        } else if (e.code == 'email-already-in-use') {
          print('Error, Email sudah ada');
        } else if (e.code == 'wrong-password') {
          print('Error, Salah kata sandi');
        } else {
          print('eror : ${e.code}');
        }
      } catch (e) {
        isloading.value = false;
        print('eror : ${e.toString()}');
      }
    } else {
      print('Email dan kata sandi tidak boleh kosong');
    }
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
