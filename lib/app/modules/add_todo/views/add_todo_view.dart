import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../utils/app_color.dart';
import '../../../widgets/custom_input.dart';
import '../controllers/add_todo_controller.dart';

class AddTodoView extends GetView<AddTodoController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tambah data peminjaman',
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
      body: GetBuilder<AddTodoController>(builder: (controller) {
        return ListView(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.all(20),
          children: [
            DropDownTextField(
              controller: controller.cnt,
              clearOption: true,
              enableSearch: true,
              searchFocusNode: controller.searchFocusNode,
              searchDecoration: const InputDecoration(
                  hintText: "pilih barang yang akan dipinjam"),
              validator: (value) {
                if (value == null) {
                  return "data barang kosong";
                } else {
                  return null;
                }
              },
              dropDownItemCount: 6,
              dropDownList: (controller.items != null)
                  ? controller.items!.map((val) {
                      var item = val.data();
                      return DropDownValueModel(
                        name: item["nama_barang"],
                        value: {
                          "nama_barang": item["nama_barang"],
                        },
                      );
                    }).toList()
                  : [],
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
                ],
              ),
            ),
            CustomInput(
              controller: controller.keteranganC,
              label: 'Keterangan',
              hint: 'Keterangan kondisi alat',
            ),
            (controller.file != null)
                ? Image.file(controller.file!)
                : const SizedBox(),
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
                      controller.addTodo();
                    }
                  },
                  child: Text(
                    (controller.isLoading.isFalse)
                        ? 'Tambah data pinjam'
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
