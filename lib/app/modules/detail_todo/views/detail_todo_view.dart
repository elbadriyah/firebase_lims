import 'package:firebase_lims/app/modules/detail_todo/controllers/detail_todo_controller.dart';
import 'package:firebase_lims/app/routes/app_pages.dart';
import 'package:firebase_lims/app/utils/app_color.dart';
import 'package:firebase_lims/app/widgets/costume_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class DetailTodoView extends GetView<DetailTodoController> {
  const DetailTodoView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detail Todo',
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
      body: ListView(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(20),
        children: [
          CustomInput(
            controller: controller.titleC,
            label: 'Nama Todo',
            hint: 'Menyelesaikan tugas',
            disabled: true,
          ),
          CustomInput(
            controller: controller.descriptionC,
            label: 'Deskripsi Todo',
            hint: 'Diselesaikan sebelum tanggal 25',
            disabled: true,
          ),
           ElevatedButton(
            onPressed: () {
              controller.deleteTodo();
            },
            child: Text(
              'Delete todo',
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
