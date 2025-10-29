// src/page_routes/app_pages.dart

import 'package:get/get.dart';
import 'package:pd_hours_control/src/views/home/home_page.dart';

class AppPages {
  static final pages = [
    GetPage(name: AppRoutes.home, page: () => const HomePage()),
  ];
}

abstract class AppRoutes {
  static const home = '/home';
}
