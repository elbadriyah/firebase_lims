import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../utils/app_color.dart';
import '../../../widgets/custom_input.dart';
import '../controllers/edit_todo_controller.dart';

class EditTodoView extends GetView<EditTodoController> {
  const EditTodoView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit data peminjam',
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
      body: GetBuilder<EditTodoController>(builder: (controller) {
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
            ),
            CustomInput(
              controller: controller.namaC,
              label: 'Nama peminjam',
              hint: 'Nama peminjam alat',
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
            Obx(
              () => Row(
                children: <Widget>[
                  Row(
                    children: [
                      Radio(
                        value: 'tersedia',
                        groupValue: controller.radio
                            .value, // Pastikan controller.status sesuai dengan nilai radio button yang dipilih
                        onChanged: (value) {
                          controller.setRadio(value);
                        },
                      ),
                      Text("Tersedia"),
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                        value: 'dipinjam',
                        groupValue: controller.radio
                            .value, // Pastikan controller.status sesuai dengan nilai radio button yang dipilih
                        onChanged: (value) {
                          controller.setRadio(value);
                        },
                      ),
                      Text("Dipinjam"),
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                        value: 'terlambat',
                        groupValue: controller.radio
                            .value, // Pastikan controller.status sesuai dengan nilai radio button yang dipilih
                        onChanged: (value) {
                          controller.setRadio(value);
                        },
                      ),
                      Text("Terlambat"),
                    ],
                  ),
                  // RadioListTile(
                  //   value: 'Available',
                  //   groupValue: controller
                  //       .radio, // Pastikan controller.status sesuai dengan nilai radio button yang dipilih
                  //   onChanged: (value) {
                  //     controller.setRadio(value);
                  //   },
                  //   title: Text('Tersedia'),
                  // ),
                  // RadioListTile(
                  //   value: 'Borrowed',
                  //   groupValue: controller.radio,
                  //   onChanged: (value) {
                  //     controller.setRadio(value);
                  //   },
                  //   title: Text('Dipinjam'),
                  // ),
                  // RadioListTile(
                  //   value: 'Returned',
                  //   groupValue: controller.radio,
                  //   onChanged: (value) {
                  //     controller.setRadio(value);
                  //   },
                  //   title: Text('Dikembalikan'),
                  // ),
                ],
              ),
            ),
            // CustomInput(
            //   controller: controller.descriptionC,
            //   label: 'Status',
            //   hint: 'Status alat',
            // ),
            CustomInput(
              controller: controller.keteranganC,
              label: 'Keterangan',
              hint: 'Keterangan kondisi alat',
            ),
            (controller.file != null)
                ? Image.file(controller.file!)
                : Image.network(controller.image),
            const SizedBox(
              height: 16,
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => controller.toCamera(),
                    child: Text(
                      'Kamera',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'poppins',
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: AppColor.primary,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => controller.pickFile(),
                    child: Text(
                      'Galeri',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'poppins',
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: AppColor.primary,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 32),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Obx(
                () => ElevatedButton(
                  onPressed: () {
                    if (controller.isLoading.isFalse) {
                      controller.editTodo();
                    }
                  },
                  child: Text(
                    (controller.isLoading.isFalse)
                        ? 'Edit data peminjaman'
                        : 'Loading...',
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
        );
      }),
    );
  }
}
