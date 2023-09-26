import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_lims/app/routes/app_pages.dart';
import 'package:firebase_lims/app/widgets/custom_alert_dialog.dart';
import 'package:firebase_lims/app/widgets/custom_toast.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  RxBool isLoading = false.obs;
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamUser() async* {
    String uid = auth.currentUser!.uid;
    yield* firestore.collection("users").doc(uid).snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamTodo() async* {
    String uid = auth.currentUser!.uid;
    yield* firestore
        .collection("users")
        .doc(uid)
        .collection("todos")
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamLastTodo() async* {
    String uid = auth.currentUser!.uid;
    yield* firestore
        .collection("users")
        .doc(uid)
        .collection("todos")
        .orderBy("created_at", descending: true)
        .limitToLast(5)
        .snapshots();
  }

  void logout() async {
    CustomAlertDialog.showPresenceAlert(
      title: "Logout System",
      message: "Apakah anda yakin akan logout dari sistem ?",
      onCancel: () => Get.back(),
      onConfirm: () async {
        Get.back(); // close modal
        Get.back(); // back page
        try {
          await auth.signOut();
          Get.offAllNamed(Routes.LOGIN);
          CustomToast.successToast('Success', 'Berhasil Logout');
        } catch (e) {
          CustomToast.errorToast(
              "Error", "Error dikarenakan : ${e.toString()}");
        }
      },
    );
  }
}
