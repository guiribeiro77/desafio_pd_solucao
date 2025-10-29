import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pd_hours_control/src/bindings/app_bindings.dart';
import 'src/page_routes/app_pages.dart';

void main() {
  runApp(const PDHoursApp());
}

class PDHoursApp extends StatelessWidget {
  const PDHoursApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: AppBindings(),
      debugShowCheckedModeBanner: false,
      title: 'PD Hours',
      initialRoute: AppRoutes.home,
      getPages: AppPages.pages,
    );
  }
}
