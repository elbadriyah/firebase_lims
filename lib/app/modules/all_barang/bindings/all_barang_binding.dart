import 'package:get/get.dart';

import '../controllers/all_barang_controller.dart';

class AllBarangBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AllBarangController>(
      () => AllBarangController(),
    );
  }
}
