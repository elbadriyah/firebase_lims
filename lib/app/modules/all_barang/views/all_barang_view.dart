import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crud_firebase/app/modules/all_barang/controllers/all_barang_controller.dart';
import 'package:flutter_crud_firebase/app/routes/app_pages.dart';
import 'package:flutter_crud_firebase/app/utils/app_color.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';

import '../controllers/all_barang_controller.dart';

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
          return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
            future: controller.getAllResult(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(child: CircularProgressIndicator());
                case ConnectionState.active:
                case ConnectionState.done:
                  var data = snapshot.data!.docs;
                  return ListView.separated(
                    itemCount: data.length,
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.all(20),
                    separatorBuilder: (context, index) => SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      var todoBarang = data[index].data();
                      String desc;
                      return InkWell(
                        onTap: () => {
                          Get.toNamed(
                            Routes.DETAIL_BARANG,
                            arguments: {
                              "id": "${todoBarang["task_id"]}",
                              "nama_barang": "${todoBarang["nama_barang"]}",
                              "spesifikasi": "${todoBarang["spesifikasi"]}",
                              "merk": "${todoBarang["merk"]}",
                              "tahun_beli": "${todoBarang["tahun_beli"]}",
                              "sumber_dana": "${todoBarang["sumber_dana"]}",
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
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Image.network(
                                todoBarang["image"],
                                width: 100,
                                height: 100,
                              ),
                              SizedBox(
                                width: 24,
                                height: 24,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    (todoBarang["nama_barang"] == null)
                                        ? "-"
                                        : "${todoBarang["nama_barang"]}",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  Text(
                                    "${todoBarang["created_at"]}",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
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
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(Routes.ADD_BARANG);
        },
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }
}
