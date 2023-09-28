import 'package:get/get.dart';

import '../controllers/edit_barang_controller.dart';

class EditBarangBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditBarangController>(
      () => EditBarangController(),
    );
  }
}
