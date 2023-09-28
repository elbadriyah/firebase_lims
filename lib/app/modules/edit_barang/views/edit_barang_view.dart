import 'package:flutter/material.dart';
import 'package:flutter_crud_firebase/app/modules/edit_barang/controllers/edit_barang_controller.dart';
import 'package:flutter_crud_firebase/app/utils/app_color.dart';
import 'package:flutter_crud_firebase/app/widgets/custom_input.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class EditTBarangView extends GetView<EditBarangController> {
  const EditTBarangView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Data Barang',
          style: TextStyle(
            color: AppColor.secondary,
            fontSize: 14,
          ),
        ),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: SvgPicture.asset('assets/icons/arrow-left.svg'),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 1,
            color: AppColor.secondaryExtraSoft,
          ),
        ),
      ),
      body: ListView(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(20),
        children: [
          CustomInput(
            controller: controller.namabrgC,
            label: 'Nama Barang',
            hint: 'Tambahkan nama Barang',
          ),
          CustomInput(
            controller: controller.spfkC,
            label: 'Spesifikasi Barang',
            hint: 'Deskripsi barang',
          ),
          CustomInput(
            controller: controller.merkC,
            label: 'Merk Barang',
            hint: 'Merk Barang',
          ),
          CustomInput(
            controller: controller.thnbeliC,
            label: 'Tahun beli',
            hint: 'Tahun beli Barang',
          ),
          CustomInput(
            controller: controller.sumberdanaC,
            label: 'Sumber dana',
            hint: 'Sumber dana pembelian barang',
          ),
          CustomInput(
            controller: controller.jumlahC,
            label: 'Jumlah barang',
            hint: 'Jumlah barang',
          ),
          SizedBox(height: 32),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Obx(
              () => ElevatedButton(
                onPressed: () {
                  if (controller.isLoading.isFalse) {
                    controller.editBarang();
                  }
                },
                child: Text(
                  (controller.isLoading.isFalse) ? 'Edit todo' : 'Loading...',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'poppins',
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: AppColor.primary,
                  padding: EdgeInsets.symmetric(vertical: 18),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
