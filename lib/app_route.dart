import 'package:get/get.dart';
import 'home.dart';
import 'createtodo.dart';

class AppRoutes {
  static const String home = '/';
  static const String createTodo = '/create';

  static final routes = [
    GetPage(name: home, page: () => TodoHome()),
    GetPage(name: createTodo, page: () => CreateTodo()),
  ];
}
