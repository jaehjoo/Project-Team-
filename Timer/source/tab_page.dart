import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'chart_page.dart';
import 'utils.dart';
import 'home_page.dart';
import 'package:sqflite/sqflite.dart';
import 'donate_page.dart';

// 실제로 우리가 원하는 홈화면을 보여주기 위해 TapPageState를 상태로 올린다
class TabPage extends StatefulWidget{
  final Future<Database> db;
  TabPage(this.db);

  @override
  _TabPageState createState() => _TabPageState();
}

// 상태로 올라간 TabPageState. 하단 부의 메뉴 막대와 막대 위 화면을 보여줄 페이지 리스트로 구성
class _TabPageState extends State<TabPage> {
  /* selectedPageIndex : 실제로 보여줄 페이지를 전환하기 위한 스위치
     pages : 스위치 전환 시, 해당 스위치에 해당하는 내용물을 보여주기 위한 리스트*/
  int _selectedPageIndex = 0;

  late List _pages = [
    HomePage(widget.db),
    ChartPage(widget.db),
    DonatePage(),
  ];

  List _color = [
    HexColor('#24202E'),
    HexColor('#24202E'),
    HexColor('#24202E'),
  ];

  // 위젯은 마테리얼 디자인(Scaffold)으로 구성된 화면을 띄운다
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /* body : Container로 화면을 감싸고 그 위에 위젯을 띄운다. 위젯은 page 리스트에서 스위치 전환을 통해 불러옴
         bottomNavigationBar : 하단 메뉴 막대. CurvedNavigationBar는 패키지로 물결 무늬 애니메이션 적용 */
      body: Container(
          child: _pages[_selectedPageIndex]
      ),
      bottomNavigationBar: CurvedNavigationBar(
        height: 55,
        backgroundColor: _color[_selectedPageIndex],
        color: HexColor("#D9DDDC"),
        onTap: (index) {
          // 실제로 아이콘을 tap하여 스위칭할 시, state를 바꿔주지 않으면 내용물이 변경되지 않는다 그래서 setState 적용
          setState(() {
            _selectedPageIndex = index;
          });
        },
        // items는 하단 메뉴 막대에 시각적 효과를 위해 상징물을 띄우기 위한 용도
        items: [
          Icon(Icons.home, size: MediaQuery.of(context).size.width * 0.08, color: HexColor('#000000'),),
          Icon(Icons.bar_chart, size: MediaQuery.of(context).size.width * 0.08, color: HexColor('#000000'),),
          Icon(Icons.volunteer_activism, size: MediaQuery.of(context).size.width * 0.08, color: HexColor('#000000'),),
        ],
      ),
    );
  }
}