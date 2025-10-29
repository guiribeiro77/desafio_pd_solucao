import 'package:flutter/material.dart';
import 'package:pd_hours_control/src/views/home/widgets/add_report_modal.dart';
import 'package:pd_hours_control/src/views/home/widgets/employee_tab.dart';
import 'package:pd_hours_control/src/views/home/widgets/squad_tab.dart';
import 'package:pd_hours_control/src/views/home/widgets/squad_detail_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  int? selectedSquadId;
  String? selectedSquadName;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _openAddReportModal() => AddReportDialog.show();

  void _openSquadDetail(int id, String name) {
    setState(() {
      selectedSquadId = id;
      selectedSquadName = name;
    });
  }

  void _closeSquadDetail() {
    setState(() {
      selectedSquadId = null;
      selectedSquadName = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actionsPadding: const EdgeInsets.only(right: 16),
        actions: [
          FilledButton(
            onPressed: _openAddReportModal,
            child: const Text('Lançar Hora'),
          ),
        ],
        centerTitle: false,
        title: Image.asset('assets/logo.png', height: 80),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Squads', icon: Icon(Icons.group)),
            Tab(text: 'Usuários', icon: Icon(Icons.person)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child:
                selectedSquadId == null
                    ? SquadTab(onVisitSquad: _openSquadDetail)
                    : SquadDetailView(
                      squadId: selectedSquadId!,
                      squadName: selectedSquadName!,
                      onBack: _closeSquadDetail,
                    ),
          ),
          const EmployeeTab(),
        ],
      ),
    );
  }
}
