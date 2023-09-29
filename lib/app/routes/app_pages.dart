import 'package:get/get.dart';

import '../modules/add_barang/bindings/add_barang_binding.dart';
import '../modules/add_barang/views/add_barang_view.dart';
import '../modules/add_todo/bindings/add_todo_binding.dart';
import '../modules/add_todo/views/add_todo_view.dart';
import '../modules/all_barang/bindings/all_barang_binding.dart';
import '../modules/all_barang/views/all_barang_view.dart';
import '../modules/all_todo/bindings/all_todo_binding.dart';
import '../modules/all_todo/views/all_todo_view.dart';
import '../modules/dashboard/bindings/dashboard_binding.dart';
import '../modules/dashboard/views/dashboard_view.dart';
import '../modules/detail_barang/bindings/detail_barang_binding.dart';
import '../modules/detail_barang/views/detail_barang_view.dart';
import '../modules/detail_todo/bindings/detail_todo_binding.dart';
import '../modules/detail_todo/views/detail_todo_view.dart';
import '../modules/edit_barang/bindings/edit_barang_binding.dart';
import '../modules/edit_barang/views/edit_barang_view.dart';
import '../modules/edit_todo/bindings/edit_todo_binding.dart';
import '../modules/edit_todo/views/edit_todo_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.LOGIN;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.ADD_TODO,
      page: () => AddTodoView(),
      binding: AddTodoBinding(),
    ),
    GetPage(
      name: _Paths.ALL_TODO,
      page: () => const AllTodoView(),
      binding: AllTodoBinding(),
    ),
    GetPage(
      name: _Paths.DETAIL_TODO,
      page: () => const DetailTodoView(),
      binding: DetailTodoBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_TODO,
      page: () => const EditTodoView(),
      binding: EditTodoBinding(),
    ),
    GetPage(
      name: _Paths.ADD_BARANG,
      page: () => const AddTbarangView(),
      binding: AddBarangBinding(),
    ),
    GetPage(
      name: _Paths.ALL_BARANG,
      page: () => const AllTBarangView(),
      binding: AllBarangBinding(),
    ),
    GetPage(
      name: _Paths.DETAIL_BARANG,
      page: () => const DetailBarangView(),
      binding: DetailBarangBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_BARANG,
      page: () => const EditTBarangView(),
      binding: EditBarangBinding(),
    ),
    GetPage(
      name: _Paths.DASHBOARD,
      page: () => const DashboardView(),
      binding: DashboardBinding(),
    ),
  ];
}
