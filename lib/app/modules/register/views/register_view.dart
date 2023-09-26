import 'package:firebase_lims/app/widgets/costume_input.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: ListView(
          children: [
            CustomInput(
                obsecureText: false,
                hint: "Nama Lengkap",
                label: "Nama lengkap",
                controller: controller.namalengkapC,
                suffixIcon: Icon(Icons.person)),
            CustomInput(
                obsecureText: false,
                hint: "email",
                label: "email",
                controller: controller.emailC,
                suffixIcon: Icon(Icons.email)),
            CustomInput(
                obsecureText: true,
                hint: "Password",
                label: "Password",
                controller: controller.passwordC,
                suffixIcon: Icon(Icons.lock)),
            ElevatedButton(
              
              onPressed: () => controller.register(),
              child: Text("Daftar"),
            ),
          ],
        ),
      ),
    );
  }
}
