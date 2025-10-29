import 'package:get/get.dart';
import 'package:pd_hours_control/src/controllers/employee_controller.dart';
import 'package:pd_hours_control/src/controllers/report_controller.dart';
import 'package:pd_hours_control/src/controllers/squad_controller.dart';
import 'package:pd_hours_control/src/controllers/squad_report_controller.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EmployeeController>(() => EmployeeController());
    Get.lazyPut<SquadController>(() => SquadController());
    Get.lazyPut<ReportController>(() => ReportController());
    Get.lazyPut<SquadReportController>(() => SquadReportController());
  }
}
