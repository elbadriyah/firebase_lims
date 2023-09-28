import 'package:flutter/material.dart';
import 'package:flutter_crud_firebase/app/routes/app_pages.dart';

import 'package:get/get.dart';

import '../controllers/dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({Key? key}) : super(key: key);
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
          child: Card(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Data Barang'),
                ]),
          ),
        )),
        Expanded(
            child: InkWell(
          onTap: () => Get.toNamed(Routes.HOME),
          child: Card(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Data pinjam'),
                ]),
          ),
        )),
      ]),
    );
  }
}
