import 'package:get/get.dart';
import 'package:to_do_app/createtodo.dart';
import 'package:to_do_app/home.dart';

class AppRoutes {
  static const String home = '/';
  static const String createTodo = '/create';

  static final routes = [
    GetPage(name: home, page: () => TodoHome()),
    GetPage(name: createTodo, page: () => CreateTodo()),
  ];
}
