import 'package:flutter/material.dart';

class LabScreen extends StatefulWidget {
  final String title;
  final List<Map<String, dynamic>> calculators;

  const LabScreen({
    Key? key,
    required this.title,
    required this.calculators,
  }) : super(key: key);

  @override
  _LabScreenState createState() => _LabScreenState();
}

class _LabScreenState extends State<LabScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: widget.calculators.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        bottom: TabBar(
          controller: _tabController,
          tabs: widget.calculators
              .map((calc) => Tab(text: calc['title']))
              .toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children:
            widget.calculators.map((calc) => calc['widget'] as Widget).toList(),
      ),
    );
  }
}
