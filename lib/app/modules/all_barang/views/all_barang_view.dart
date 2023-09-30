import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crud_firebase/app/modules/all_barang/controllers/all_barang_controller.dart';
import 'package:flutter_crud_firebase/app/routes/app_pages.dart';
import 'package:flutter_crud_firebase/app/utils/app_color.dart';
import 'package:flutter_crud_firebase/app/widgets/custom_input.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

// import '../controllers/all_barang_controller.dart';

class AllTBarangView extends GetView<AllBarangController> {
  const AllTBarangView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Semua Data Barang',
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
        body: GetBuilder<AllBarangController>(
          builder: (con) {
            return Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: CustomInput(
                          controller: controller.searchC,
                          label: "Pencarian",
                          hint: "Cari Data Barang"),
                    ),
                    ElevatedButton(
                        onPressed: () => controller.update(),
                        child: Icon(Icons.search)),
                    ElevatedButton(
                        onPressed: () => controller.scanQr(),
                        child: Icon(Icons.qr_code_scanner)),
                  ],
                ),
                FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  future: controller.getAllResult(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return Center(child: CircularProgressIndicator());
                      case ConnectionState.active:
                      case ConnectionState.done:
                        var data = snapshot.data!.docs;
                        var items = [];
                        data.forEach((element) {
                          items.add(element.data());
                        });

                        if (controller.searchC.text.isNotEmpty) {
                          items = items
                              .where((e) => e["nama_barang"]
                                  .toString()
                                  .toLowerCase()
                                  .contains(
                                      controller.searchC.text.toLowerCase()))
                              .toList();
                        }

                        return ListView.separated(
                          itemCount: items.length,
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          padding: EdgeInsets.all(20),
                          separatorBuilder: (context, index) =>
                              SizedBox(height: 16),
                          itemBuilder: (context, index) {
                            // var todoBarang = data[index].data();
                            var todoBarang = items[index];
                            String desc;
                            return InkWell(
                              onTap: () => {
                                Get.toNamed(
                                  Routes.DETAIL_BARANG,
                                  arguments: {
                                    "id": "${todoBarang["task_id"]}",
                                    "nama_barang":
                                        "${todoBarang["nama_barang"]}",
                                    "spesifikasi":
                                        "${todoBarang["spesifikasi"]}",
                                    "merk": "${todoBarang["merk"]}",
                                    "tahun_beli": "${todoBarang["tahun_beli"]}",
                                    "sumber_dana":
                                        "${todoBarang["sumber_dana"]}",
                                    "jumlah": "${todoBarang["jumlah"]}",
                                    "image": "${todoBarang["image"]}"
                                  },
                                )
                              },
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    width: 1,
                                    color: AppColor.primaryExtraSoft,
                                  ),
                                ),
                                padding: EdgeInsets.only(
                                    left: 24, top: 20, right: 29, bottom: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Image.network(
                                          todoBarang["image"],
                                          width: 100,
                                          height: 100,
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              (todoBarang["nama_barang"] ==
                                                      null)
                                                  ? "-"
                                                  : "${todoBarang["nama_barang"]}",
                                              style: TextStyle(fontSize: 12),
                                            ),
                                            Text(
                                              "${todoBarang["spesifikasi"]}",
                                              style: TextStyle(fontSize: 12),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 40,
                                      height: 40,
                                      child: PrettyQrView.data(
                                        data: "${todoBarang["task_id"]}",
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      default:
                        return SizedBox();
                    }
                  },
                ),
              ],
            );
          },
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () {
                Get.toNamed(Routes.ADD_BARANG);
              },
              child: Icon(
                Icons.add,
              ),
            ),
            FloatingActionButton(
                onPressed: () {
                  controller.downloaditems();
                },
                child: Icon(
                  Icons.print,
                )),
          ],
        ));
  }
}
