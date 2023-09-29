import 'package:flutter/material.dart';
import 'package:flutter_crud_firebase/app/routes/app_pages.dart';

import 'package:get/get.dart';

import '../controllers/dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({Key? key}) : super(key: key);

  //  final AuthController authC = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DASHBOARD'),
        centerTitle: true,
      ),
      body: Row(children: [
        Expanded(
            child: InkWell(
          onTap: () => Get.toNamed(Routes.ALL_BARANG),
          child: SizedBox(
            height: 200,
            child: Card(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      'assets/images/pc.png',
                      width: 130,
                    ),
                    Text('Data Barang'),
                  ]),
            ),
          ),
        )),
        Expanded(
            child: InkWell(
          onTap: () => Get.toNamed(Routes.HOME),
          child: SizedBox(
            height: 200,
            child: Card(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      'assets/images/pinjam.png',
                      width: 130,
                    ),
                    Text('Data pinjam'),
                  ]),
            ),
          ),
        )),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.logout();
        },
        child: Icon(
          Icons.logout,
        ),
      ),
    );
  }
}
