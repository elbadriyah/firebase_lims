import 'package:flutter/material.dart';
import 'package:flutter_crud_firebase/app/modules/detail_barang/controllers/detail_barang_controller.dart';
import 'package:flutter_crud_firebase/app/modules/detail_todo/controllers/detail_todo_controller.dart';
import 'package:flutter_crud_firebase/app/routes/app_pages.dart';
import 'package:flutter_crud_firebase/app/utils/app_color.dart';
import 'package:flutter_crud_firebase/app/widgets/custom_input.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class DetailBarangView extends GetView<DetailBarangController> {
  const DetailBarangView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detail Barang',
          style: TextStyle(
            color: AppColor.secondary,
            fontSize: 14,
          ),
        ),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: SvgPicture.asset('assets/icons/arrow-left.svg'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.toNamed(Routes.EDIT_BARANG, arguments: controller.argsData);
            },
            child: Text('Edit'),
            style: TextButton.styleFrom(
              primary: AppColor.primary,
            ),
          ),
        ],
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
            disabled: true,
          ),
          CustomInput(
            controller: controller.spfkC,
            label: 'Spesifikasi Barang',
            hint: 'Deskripsi barang',
            disabled: true,
          ),
          CustomInput(
            controller: controller.merkC,
            label: 'Merk Barang',
            hint: 'Merk Barang',
            disabled: true,
          ),
          CustomInput(
            controller: controller.thnbeliC,
            label: 'Tahun beli',
            hint: 'Tahun beli Barang',
            disabled: true,
          ),
          CustomInput(
            controller: controller.sumberdanaC,
            label: 'Sumber dana',
            hint: 'Sumber dana pembelian barang',
            disabled: true,
          ),
          CustomInput(
            controller: controller.jumlahC,
            label: 'Jumlah barang',
            hint: 'Jumlah barang',
            disabled: true,
          ),
          Center(
            child: SizedBox(
              width: 200,
              height: 200,
              child: PrettyQrView.data(
                data: controller.argsData["id"],
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Image.network(controller.image),
          const SizedBox(
            height: 16,
          ),
          ElevatedButton(
            onPressed: () {
              controller.deleteBarang();
            },
            child: Text(
              'Delete Barang',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'poppins',
              ),
            ),
            style: ElevatedButton.styleFrom(
              primary: AppColor.warning,
              padding: EdgeInsets.symmetric(vertical: 18),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
