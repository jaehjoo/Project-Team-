import 'package:flutter/cupertino.dart';
import 'tab_page.dart';
import 'package:sqflite/sqflite.dart';

// Root Page를 통해 위젯 형태로 TabPage를 실제 앱 화면에 띄운다
class RootPage extends StatelessWidget {
  final Future<Database> db;
  RootPage(this.db);

  @override
  Widget build(BuildContext context) {
    return TabPage(db);
  }
}