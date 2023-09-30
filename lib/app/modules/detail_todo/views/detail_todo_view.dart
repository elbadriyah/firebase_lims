import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

import '../../../routes/app_pages.dart';
import '../../../utils/app_color.dart';
import '../../../widgets/custom_input.dart';
import '../controllers/detail_todo_controller.dart';

class DetailTodoView extends GetView<DetailTodoController> {
  const DetailTodoView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detail peminjaman',
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
              Get.toNamed(Routes.EDIT_TODO, arguments: controller.argsData);
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
      body: GetBuilder<DetailTodoController>(builder: (controller) {
        return ListView(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.all(20),
          children: [
            CustomInput(
              controller: controller.titleC,
              label: 'Nama barang',
              hint: 'Nama Barang yang dipinjam',
              disabled: true,
            ),
            CustomInput(
              controller: controller.descriptionC,
              label: 'Identitas',
              hint: 'No KTP/NIP/NISN',
              disabled: true,
            ),
            CustomInput(
              controller: controller.namaC,
              label: 'Nama peminjam',
              hint: 'Nama peminjam alat',
              disabled: true,
            ),
            CustomInput(
              controller: controller.tanggalC,
              disabled: true,
              label: 'Tanggal pinjam',
              hint: DateFormat('d-M-yyyy').format(DateTime.now()),
            ),
            CustomInput(
              controller: controller.tanggalKemC,
              disabled: true,
              label: 'Tanggal kembali',
              hint: DateFormat('d-M-yyyy')
                  .format(DateTime.now().add(Duration(days: 3))),
            ),
            CustomInput(
              controller: controller.statusC,
              label: 'Keterangan',
              hint: 'Keterangan kondisi alat',
              disabled: true,
            ),
            CustomInput(
              controller: controller.keteranganC,
              label: 'Keterangan',
              hint: 'Keterangan kondisi alat',
              disabled: true,
            ),
            Center(
              child: SizedBox(
                width: 200,
                height: 200,
                child: PrettyQrView.data(
                  data: 'lorem ipsum dolor sit amet',
                  decoration: const PrettyQrDecoration(
                    image: PrettyQrDecorationImage(
                      image: AssetImage('images/flutter.png'),
                    ),
                  ),
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
                controller.deleteTodo();
              },
              child: Text(
                'Delete peminjaman',
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
        );
      }),
    );
  }
}
