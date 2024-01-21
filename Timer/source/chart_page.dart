import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';
import 'concentration.dart';
import 'dart:math';
import 'utils.dart';

class _PieChart extends CustomPainter {
  /*
  percentage : 원형 도표에서 그려줄 호의 크기를 정해준다
  barColor : 원형 도표에서 그려지는 호 색깔
  textScaleFactor : 원형 도표 내부에 들어갈 글자 크기
  res : 원형 도표 내부에 들어갈 글자
  strokelen : 선 굵기
   */
  final int percentage;
  final Color barColor;
  final int strokelen;

  _PieChart(
      {required this.percentage,
      required this.barColor,
      required this.strokelen});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint() // 화면에 그릴 때 쓸 paint를 정의
      ..color = barColor
      ..strokeWidth = 5.0 // 선의 길이를 정함
      ..style = PaintingStyle.stroke // 선의 스타일을 정함
      ..strokeCap = StrokeCap.square; // stroke 스타일을 정함

    double radius = min(
        size.width / 2 - paint.strokeWidth / 2,
        size.height / 2 -
            paint.strokeWidth / 2); // 원의 반지름을 구함, 선의 굵기에 영향을 받지 않게 보정
    Offset center =
        Offset(size.width / 2, size.height / 2); // 원이 위젯 가운데에 그려지게 좌표 정함
    canvas.drawCircle(center, radius, paint); // 원을 그린다
    double arcAngle = 2 * pi * (percentage / 100); // 호의 각도를 정한다
    paint..color = HexColor('#24202E'); // 호를 그릴 때 색깔을 바꿔줌
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -pi / 2,
        arcAngle, false, paint); // 호를 그림
    //drawText(canvas, size, res); // 텍스트를 화면에 표시
  }

  // 원의 중앙에 텍스트 적용
  /*void drawText(Canvas canvas, Size size, String text) {
    double fontSize = getFontSize(size, text);
    // textspan은 text 위젯과 동일
    TextSpan sp = TextSpan(style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: HexColor('#FFFFFF')), text: text);
    TextPainter tp = TextPainter(text: sp, textDirection: TextDirection.ltr);

    // 텍스트 페인터에 그려질 텍스트의 크기와 방향을 정함
    tp.layout();
    double dx = size.width / 2 - tp.width / 2;
    double dy = size.height / 2 - tp.height / 2;

    Offset offset = Offset(dx, dy);
    tp.paint(canvas, offset);
  }*/

  // 화면 크기에 비례하도록 텍스트 폰트 크기를 정함
  /*double getFontSize(Size size, String text) {
    return size.width / text.length * textScaleFactor;
  }*/

  @override
  bool shouldRepaint(_PieChart old) {
    return old.percentage != percentage;
  }
}

class _LineChartWeekCC extends StatelessWidget {
  final List<int> Factor;
  final List<int> last_Factor;

  _LineChartWeekCC({required this.Factor, required this.last_Factor});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      sampleData1,
      swapAnimationDuration: const Duration(milliseconds: 250),
    );
  }

  LineChartData get sampleData1 => LineChartData(
        lineTouchData: lineTouchData1,
        gridData: gridData,
        titlesData: titlesData1,
        borderData: borderData,
        lineBarsData: lineBarsData1,
        minX: 0,
        maxX: 7,
        maxY: 100,
        minY: 0,
      );

  LineTouchData get lineTouchData1 => LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.5),
        ),
      );

  FlTitlesData get titlesData1 => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: bottomTitles,
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: leftTitles(),
        ),
      );

  List<LineChartBarData> get lineBarsData1 => [
        lineChartBarData1_1,
        lineChartBarData1_2,
      ];

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xF0FFFFFF),
      fontWeight: FontWeight.bold,
      fontSize: 8,
    );
    String text;
    switch (value.toInt()) {
      case 20:
        text = '20';
        break;
      case 40:
        text = '40';
        break;
      case 60:
        text = '60';
        break;
      case 80:
        text = '80';
        break;
      case 100:
        text = '100';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.center);
  }

  SideTitles leftTitles() => SideTitles(
        getTitlesWidget: leftTitleWidgets,
        showTitles: true,
        interval: 1,
        reservedSize: 18,
      );

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xF0FFFFFF),
      fontWeight: FontWeight.bold,
      fontSize: 8,
    );
    Widget text;
    switch (value.toInt()) {
      case 1:
        text = const Text('1', style: style);
        break;
      case 2:
        text = const Text('2', style: style);
        break;
      case 3:
        text = const Text('3', style: style);
        break;
      case 4:
        text = const Text('4', style: style);
        break;
      case 5:
        text = const Text('5', style: style);
        break;
      case 6:
        text = const Text('6', style: style);
        break;
      case 7:
        text = const Text('7', style: style);
        break;
      default:
        text = const Text('');
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 5,
      child: text,
    );
  }

  SideTitles get bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 15,
        interval: 1,
        getTitlesWidget: bottomTitleWidgets,
      );

  FlGridData get gridData => FlGridData(show: false);

  FlBorderData get borderData => FlBorderData(
        show: true,
        border: Border(
          bottom: BorderSide(color: Color(0xff4e4965), width: 0.2),
          left: BorderSide(color: Colors.transparent),
          right: BorderSide(color: Colors.transparent),
          top: BorderSide(color: Colors.transparent),
        ),
      );

  LineChartBarData get lineChartBarData1_1 => LineChartBarData(
        isCurved: false,
        color: const Color(0xFF4AF699),
        barWidth: 1,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(
          show: true,
          color: const Color(0x5F4AF699),
        ),
        spots: [
          FlSpot(0, 0),
          FlSpot(1, Factor[1].toDouble()),
          FlSpot(2, Factor[2].toDouble()),
          FlSpot(3, Factor[3].toDouble()),
          FlSpot(4, Factor[4].toDouble()),
          FlSpot(5, Factor[5].toDouble()),
          FlSpot(6, Factor[6].toDouble()),
          FlSpot(7, Factor[7].toDouble()),
        ],
      );

  LineChartBarData get lineChartBarData1_2 => LineChartBarData(
        isCurved: false,
        color: Color(0xFFAA4CFC),
        barWidth: 1,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(
          show: true,
          color: Color(0x5FAA4CFC),
        ),
        spots: [
          FlSpot(0, 0),
          FlSpot(1, last_Factor[1].toDouble()),
          FlSpot(2, last_Factor[2].toDouble()),
          FlSpot(3, last_Factor[3].toDouble()),
          FlSpot(4, last_Factor[4].toDouble()),
          FlSpot(5, last_Factor[5].toDouble()),
          FlSpot(6, last_Factor[6].toDouble()),
          FlSpot(7, last_Factor[7].toDouble()),
        ],
      );
}

class _LineChartMonthCC extends StatelessWidget {
  final List<int> Factor;
  final List<int> last_Factor;

  _LineChartMonthCC({required this.Factor, required this.last_Factor});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      sampleData1,
      swapAnimationDuration: const Duration(milliseconds: 250),
    );
  }

  LineChartData get sampleData1 => LineChartData(
        lineTouchData: lineTouchData1,
        gridData: gridData,
        titlesData: titlesData1,
        borderData: borderData,
        lineBarsData: lineBarsData1,
        minX: 0,
        maxX: 31,
        maxY: 100,
        minY: 0,
      );

  LineTouchData get lineTouchData1 => LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.5),
        ),
      );

  FlTitlesData get titlesData1 => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: bottomTitles,
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: leftTitles(),
        ),
      );

  List<LineChartBarData> get lineBarsData1 => [
        lineChartBarData1_1,
        lineChartBarData1_2,
      ];

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xF0FFFFFF),
      fontWeight: FontWeight.bold,
      fontSize: 8,
    );
    String text;
    switch (value.toInt()) {
      case 20:
        text = '20';
        break;
      case 40:
        text = '40';
        break;
      case 60:
        text = '60';
        break;
      case 80:
        text = '80';
        break;
      case 100:
        text = '100';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.center);
  }

  SideTitles leftTitles() => SideTitles(
        getTitlesWidget: leftTitleWidgets,
        showTitles: true,
        interval: 1,
        reservedSize: 18,
      );

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xF0FFFFFF),
      fontWeight: FontWeight.bold,
      fontSize: 8,
    );
    Widget text;
    switch (value.toInt()) {
      case 4:
        text = const Text('4', style: style);
        break;
      case 8:
        text = const Text('8', style: style);
        break;
      case 12:
        text = const Text('12', style: style);
        break;
      case 16:
        text = const Text('16', style: style);
        break;
      case 20:
        text = const Text('20', style: style);
        break;
      case 24:
        text = const Text('24', style: style);
        break;
      case 28:
        text = const Text('28', style: style);
        break;
      case 31:
        text = const Text('31', style: style);
        break;
      default:
        text = const Text('');
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 5,
      child: text,
    );
  }

  SideTitles get bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 15,
        interval: 1,
        getTitlesWidget: bottomTitleWidgets,
      );

  FlGridData get gridData => FlGridData(show: false);

  FlBorderData get borderData => FlBorderData(
        show: true,
        border: Border(
          bottom: BorderSide(color: Color(0xff4e4965), width: 0.2),
          left: BorderSide(color: Colors.transparent),
          right: BorderSide(color: Colors.transparent),
          top: BorderSide(color: Colors.transparent),
        ),
      );

  LineChartBarData get lineChartBarData1_1 => LineChartBarData(
        isCurved: false,
        color: const Color(0xFF4AF699),
        barWidth: 1,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(
          show: true,
          color: const Color(0x5F4AF699),
        ),
        spots: [
          FlSpot(0, 0),
          FlSpot(1, Factor[1].toDouble()),
          FlSpot(2, Factor[2].toDouble()),
          FlSpot(3, Factor[3].toDouble()),
          FlSpot(4, Factor[4].toDouble()),
          FlSpot(5, Factor[5].toDouble()),
          FlSpot(6, Factor[6].toDouble()),
          FlSpot(7, Factor[7].toDouble()),
          FlSpot(8, Factor[8].toDouble()),
          FlSpot(9, Factor[9].toDouble()),
          FlSpot(10, Factor[10].toDouble()),
          FlSpot(11, Factor[11].toDouble()),
          FlSpot(12, Factor[12].toDouble()),
          FlSpot(13, Factor[13].toDouble()),
          FlSpot(14, Factor[14].toDouble()),
          FlSpot(15, Factor[15].toDouble()),
          FlSpot(16, Factor[16].toDouble()),
          FlSpot(17, Factor[17].toDouble()),
          FlSpot(18, Factor[18].toDouble()),
          FlSpot(19, Factor[19].toDouble()),
          FlSpot(20, Factor[20].toDouble()),
          FlSpot(21, Factor[21].toDouble()),
          FlSpot(22, Factor[22].toDouble()),
          FlSpot(23, Factor[23].toDouble()),
          FlSpot(24, Factor[24].toDouble()),
          FlSpot(25, Factor[25].toDouble()),
          FlSpot(26, Factor[26].toDouble()),
          FlSpot(27, Factor[27].toDouble()),
          FlSpot(28, Factor[28].toDouble()),
          FlSpot(29, Factor[29].toDouble()),
          FlSpot(30, Factor[30].toDouble()),
          FlSpot(31, Factor[31].toDouble())
        ],
      );

  LineChartBarData get lineChartBarData1_2 => LineChartBarData(
        isCurved: false,
        color: Color(0xFFAA4CFC),
        barWidth: 1,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(
          show: true,
          color: Color(0x5FAA4CFC),
        ),
        spots: [
          FlSpot(0, 0),
          FlSpot(1, last_Factor[1].toDouble()),
          FlSpot(2, last_Factor[2].toDouble()),
          FlSpot(3, last_Factor[3].toDouble()),
          FlSpot(4, last_Factor[4].toDouble()),
          FlSpot(5, last_Factor[5].toDouble()),
          FlSpot(6, last_Factor[6].toDouble()),
          FlSpot(7, last_Factor[7].toDouble()),
          FlSpot(8, last_Factor[8].toDouble()),
          FlSpot(9, last_Factor[9].toDouble()),
          FlSpot(10, last_Factor[10].toDouble()),
          FlSpot(11, last_Factor[11].toDouble()),
          FlSpot(12, last_Factor[12].toDouble()),
          FlSpot(13, last_Factor[13].toDouble()),
          FlSpot(14, last_Factor[14].toDouble()),
          FlSpot(15, last_Factor[15].toDouble()),
          FlSpot(16, last_Factor[16].toDouble()),
          FlSpot(17, last_Factor[17].toDouble()),
          FlSpot(18, last_Factor[18].toDouble()),
          FlSpot(19, last_Factor[19].toDouble()),
          FlSpot(20, last_Factor[20].toDouble()),
          FlSpot(21, last_Factor[21].toDouble()),
          FlSpot(22, last_Factor[22].toDouble()),
          FlSpot(23, last_Factor[23].toDouble()),
          FlSpot(24, last_Factor[24].toDouble()),
          FlSpot(25, last_Factor[25].toDouble()),
          FlSpot(26, last_Factor[26].toDouble()),
          FlSpot(27, last_Factor[27].toDouble()),
          FlSpot(28, last_Factor[28].toDouble()),
          FlSpot(29, last_Factor[29].toDouble()),
          FlSpot(30, last_Factor[30].toDouble()),
          FlSpot(31, last_Factor[31].toDouble()),
        ],
      );
}

class _LineChartWeek extends StatelessWidget {
  final List<int> Factor;
  final List<int> last_Factor;

  _LineChartWeek({required this.Factor, required this.last_Factor});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      sampleData1,
      swapAnimationDuration: const Duration(milliseconds: 250),
    );
  }

  LineChartData get sampleData1 => LineChartData(
        lineTouchData: lineTouchData1,
        gridData: gridData,
        titlesData: titlesData1,
        borderData: borderData,
        lineBarsData: lineBarsData1,
        minX: 0,
        maxX: 7,
        maxY: 15,
        minY: 0,
      );

  LineTouchData get lineTouchData1 => LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.5),
        ),
      );

  FlTitlesData get titlesData1 => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: bottomTitles,
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: leftTitles(),
        ),
      );

  List<LineChartBarData> get lineBarsData1 => [
        lineChartBarData1_1,
        lineChartBarData1_2,
      ];

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xF0FFFFFF),
      fontWeight: FontWeight.bold,
      fontSize: 8,
    );
    String text;
    switch (value.toInt()) {
      case 3:
        text = '3';
        break;
      case 6:
        text = '6';
        break;
      case 9:
        text = '9';
        break;
      case 12:
        text = '12';
        break;
      case 15:
        text = '15';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.center);
  }

  SideTitles leftTitles() => SideTitles(
        getTitlesWidget: leftTitleWidgets,
        showTitles: true,
        interval: 1,
        reservedSize: 18,
      );

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xF0FFFFFF),
      fontWeight: FontWeight.bold,
      fontSize: 8,
    );
    Widget text;
    switch (value.toInt()) {
      case 1:
        text = const Text('1', style: style);
        break;
      case 2:
        text = const Text('2', style: style);
        break;
      case 3:
        text = const Text('3', style: style);
        break;
      case 4:
        text = const Text('4', style: style);
        break;
      case 5:
        text = const Text('5', style: style);
        break;
      case 6:
        text = const Text('6', style: style);
        break;
      case 7:
        text = const Text('7', style: style);
        break;
      default:
        text = const Text('');
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 5,
      child: text,
    );
  }

  SideTitles get bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 15,
        interval: 1,
        getTitlesWidget: bottomTitleWidgets,
      );

  FlGridData get gridData => FlGridData(show: false);

  FlBorderData get borderData => FlBorderData(
        show: true,
        border: Border(
          bottom: BorderSide(color: Color(0xff4e4965), width: 0.2),
          left: BorderSide(color: Colors.transparent),
          right: BorderSide(color: Colors.transparent),
          top: BorderSide(color: Colors.transparent),
        ),
      );

  LineChartBarData get lineChartBarData1_1 => LineChartBarData(
        isCurved: false,
        color: const Color(0xFF4AF699),
        barWidth: 1,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(
          show: true,
          color: const Color(0x5F4AF699),
        ),
        spots: [
          FlSpot(0, 0),
          FlSpot(1, Factor[1].toDouble()),
          FlSpot(2, Factor[2].toDouble()),
          FlSpot(3, Factor[3].toDouble()),
          FlSpot(4, Factor[4].toDouble()),
          FlSpot(5, Factor[5].toDouble()),
          FlSpot(6, Factor[6].toDouble()),
          FlSpot(7, Factor[7].toDouble()),
        ],
      );

  LineChartBarData get lineChartBarData1_2 => LineChartBarData(
        isCurved: false,
        color: Color(0xFFAA4CFC),
        barWidth: 1,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(
          show: true,
          color: Color(0x5FAA4CFC),
        ),
        spots: [
          FlSpot(0, 0),
          FlSpot(1, last_Factor[1].toDouble()),
          FlSpot(2, last_Factor[2].toDouble()),
          FlSpot(3, last_Factor[3].toDouble()),
          FlSpot(4, last_Factor[4].toDouble()),
          FlSpot(5, last_Factor[5].toDouble()),
          FlSpot(6, last_Factor[6].toDouble()),
          FlSpot(7, last_Factor[7].toDouble()),
        ],
      );
}

class _LineChartMonth extends StatelessWidget {
  final List<int> Factor;
  final List<int> last_Factor;

  _LineChartMonth({required this.Factor, required this.last_Factor});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      sampleData1,
      swapAnimationDuration: const Duration(milliseconds: 250),
    );
  }

  LineChartData get sampleData1 => LineChartData(
        lineTouchData: lineTouchData1,
        gridData: gridData,
        titlesData: titlesData1,
        borderData: borderData,
        lineBarsData: lineBarsData1,
        minX: 0,
        maxX: 31,
        maxY: 15,
        minY: 0,
      );

  LineTouchData get lineTouchData1 => LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.5),
        ),
      );

  FlTitlesData get titlesData1 => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: bottomTitles,
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: leftTitles(),
        ),
      );

  List<LineChartBarData> get lineBarsData1 => [
        lineChartBarData1_1,
        lineChartBarData1_2,
      ];

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xF0FFFFFF),
      fontWeight: FontWeight.bold,
      fontSize: 8,
    );
    String text;
    switch (value.toInt()) {
      case 3:
        text = '3';
        break;
      case 6:
        text = '6';
        break;
      case 9:
        text = '9';
        break;
      case 12:
        text = '12';
        break;
      case 15:
        text = '15';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.center);
  }

  SideTitles leftTitles() => SideTitles(
        getTitlesWidget: leftTitleWidgets,
        showTitles: true,
        interval: 1,
        reservedSize: 18,
      );

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xF0FFFFFF),
      fontWeight: FontWeight.bold,
      fontSize: 8,
    );
    Widget text;
    switch (value.toInt()) {
      case 4:
        text = const Text('4', style: style);
        break;
      case 8:
        text = const Text('8', style: style);
        break;
      case 12:
        text = const Text('12', style: style);
        break;
      case 16:
        text = const Text('16', style: style);
        break;
      case 20:
        text = const Text('20', style: style);
        break;
      case 24:
        text = const Text('24', style: style);
        break;
      case 28:
        text = const Text('28', style: style);
        break;
      case 31:
        text = const Text('31', style: style);
        break;
      default:
        text = const Text('');
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 5,
      child: text,
    );
  }

  SideTitles get bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 15,
        interval: 1,
        getTitlesWidget: bottomTitleWidgets,
      );

  FlGridData get gridData => FlGridData(show: false);

  FlBorderData get borderData => FlBorderData(
        show: true,
        border: Border(
          bottom: BorderSide(color: Color(0xff4e4965), width: 0.2),
          left: BorderSide(color: Colors.transparent),
          right: BorderSide(color: Colors.transparent),
          top: BorderSide(color: Colors.transparent),
        ),
      );

  LineChartBarData get lineChartBarData1_1 => LineChartBarData(
        isCurved: false,
        color: const Color(0xFF4AF699),
        barWidth: 1,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(
          show: true,
          color: const Color(0x5F4AF699),
        ),
        spots: [
          FlSpot(0, 0),
          FlSpot(1, Factor[1].toDouble()),
          FlSpot(2, Factor[2].toDouble()),
          FlSpot(3, Factor[3].toDouble()),
          FlSpot(4, Factor[4].toDouble()),
          FlSpot(5, Factor[5].toDouble()),
          FlSpot(6, Factor[6].toDouble()),
          FlSpot(7, Factor[7].toDouble()),
          FlSpot(8, Factor[8].toDouble()),
          FlSpot(9, Factor[9].toDouble()),
          FlSpot(10, Factor[10].toDouble()),
          FlSpot(11, Factor[11].toDouble()),
          FlSpot(12, Factor[12].toDouble()),
          FlSpot(13, Factor[13].toDouble()),
          FlSpot(14, Factor[14].toDouble()),
          FlSpot(15, Factor[15].toDouble()),
          FlSpot(16, Factor[16].toDouble()),
          FlSpot(17, Factor[17].toDouble()),
          FlSpot(18, Factor[18].toDouble()),
          FlSpot(19, Factor[19].toDouble()),
          FlSpot(20, Factor[20].toDouble()),
          FlSpot(21, Factor[21].toDouble()),
          FlSpot(22, Factor[22].toDouble()),
          FlSpot(23, Factor[23].toDouble()),
          FlSpot(24, Factor[24].toDouble()),
          FlSpot(25, Factor[25].toDouble()),
          FlSpot(26, Factor[26].toDouble()),
          FlSpot(27, Factor[27].toDouble()),
          FlSpot(28, Factor[28].toDouble()),
          FlSpot(29, Factor[29].toDouble()),
          FlSpot(30, Factor[30].toDouble()),
          FlSpot(31, Factor[31].toDouble())
        ],
      );

  LineChartBarData get lineChartBarData1_2 => LineChartBarData(
        isCurved: false,
        color: Color(0xFFAA4CFC),
        barWidth: 1,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(
          show: true,
          color: Color(0x5FAA4CFC),
        ),
        spots: [
          FlSpot(0, 0),
          FlSpot(1, last_Factor[1].toDouble()),
          FlSpot(2, last_Factor[2].toDouble()),
          FlSpot(3, last_Factor[3].toDouble()),
          FlSpot(4, last_Factor[4].toDouble()),
          FlSpot(5, last_Factor[5].toDouble()),
          FlSpot(6, last_Factor[6].toDouble()),
          FlSpot(7, last_Factor[7].toDouble()),
          FlSpot(8, last_Factor[8].toDouble()),
          FlSpot(9, last_Factor[9].toDouble()),
          FlSpot(10, last_Factor[10].toDouble()),
          FlSpot(11, last_Factor[11].toDouble()),
          FlSpot(12, last_Factor[12].toDouble()),
          FlSpot(13, last_Factor[13].toDouble()),
          FlSpot(14, last_Factor[14].toDouble()),
          FlSpot(15, last_Factor[15].toDouble()),
          FlSpot(16, last_Factor[16].toDouble()),
          FlSpot(17, last_Factor[17].toDouble()),
          FlSpot(18, last_Factor[18].toDouble()),
          FlSpot(19, last_Factor[19].toDouble()),
          FlSpot(20, last_Factor[20].toDouble()),
          FlSpot(21, last_Factor[21].toDouble()),
          FlSpot(22, last_Factor[22].toDouble()),
          FlSpot(23, last_Factor[23].toDouble()),
          FlSpot(24, last_Factor[24].toDouble()),
          FlSpot(25, last_Factor[25].toDouble()),
          FlSpot(26, last_Factor[26].toDouble()),
          FlSpot(27, last_Factor[27].toDouble()),
          FlSpot(28, last_Factor[28].toDouble()),
          FlSpot(29, last_Factor[29].toDouble()),
          FlSpot(30, last_Factor[30].toDouble()),
          FlSpot(31, last_Factor[31].toDouble()),
        ],
      );
}

class ChartPage extends StatefulWidget {
  final Future<Database> db;
  ChartPage(this.db);

  @override
  _ChartPageState createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  Future<List<Concentration>>? cctList;

  // DB에서 자료를 긁어와 만들 리스트
  List<int> lastMonthCC = [
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0,
  ];
  List<int> curMonthCC = [
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0,
  ];
  List<int> lastMonthCCT = [
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0,
  ];
  List<int> curMonthCCT = [
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0,
  ];
  List<int> lastWeekCC = [
    0, 0, 0, 0, 0, 0, 0, 0,
  ];
  List<int> curWeekCC = [
    0, 0, 0, 0, 0, 0, 0, 0,
  ];
  List<int> lastWeekCCT = [
    0, 0, 0, 0, 0, 0, 0, 0,
  ];
  List<int> curWeekCCT = [
    0, 0, 0, 0, 0, 0, 0, 0,
  ];
  // 탭 변경에 따라 화면 전환할 스위치
  int selectedTabWeeks = 0;
  int selectedTabMonths = 0;
  int selectedPeriodCCT = 0;
  int selectedPeriodCC = 0;
  // 집중시간, 집중도 최대값
  int limitedCCT = 1620000;
  int limitedCCTW = 405000;
  int limitedCC = 100;
  // 지난주(월), 이번주(월) 집중시간 및 집중도 총합
  int totalCCT = 0;
  int totalCCTW = 0;
  int last_totalCCT = 0;
  int last_totalCCTW = 0;
  int totalCC = 0;
  int totalCCW = 0;
  int last_totalCC = 0;
  int last_totalCCW = 0;
  // 스위치 전환에 따른 총합값 변환을 위한 변수
  int insertLimitedCCT = 0;
  int insertTotalCCT = 0;
  int insertLastCCT = 0;
  int insertTotalCC = 0;
  int insertLastCC = 0;
  Future<int>? checkDB;

  late List _periodsCCT = [
    MonthCCTBuilder,
    WeekCCTBuilder,
  ];

  List _TabColor = [
    HexColor('#212B55'),
    HexColor('#FFFFFF'),
  ];

  late List _periodsCC = [
    MonthCCBuilder,
    WeekCCBuilder,
  ];

  List _changePeriods = [
    '달',
    '주',
  ];

  void initMonthList(List<Concentration> list) {
    for (int i = 0; i < list.length; i++) {
      // 2022-10-02
      int day = int.parse(list[i].date!.substring(8, 10));
      curMonthCCT[day] = (list[i].cctTime! / 3600).toInt();
      curMonthCC[day] = (list[i].cctScore! / list[i].cctTime!).toInt();
    }
  }

  void initLastMonthList(List<Concentration> list) {
    for (int i = 0; i < list.length; i++) {
      // 2022-10-02
      int day = int.parse(list[i].date!.substring(8, 10));
      lastMonthCCT[day] = (list[i].cctTime! / 3600).toInt();
      lastMonthCC[day] = (list[i].cctScore! / list[i].cctTime!).toInt();
    }
  }

  void initWeekList(List<Concentration> list) {
    for (int i = 0; i < list.length; i++) {
      int day = int.parse(list[i].date!.substring(8, 10));
      var now = DateTime.now();
      var firstday = now.subtract(Duration(days: now.weekday - 1));
      String week_firstday = DateFormat('dd').format(firstday);
      int weekday = day - int.parse(week_firstday) + 1;
      curWeekCCT[weekday] = (list[i].cctTime! / 3600).toInt();
      curWeekCC[weekday] = (list[i].cctScore! / list[i].cctTime!).toInt();
    }
  }

  void initLastWeekList(List<Concentration> list) {
    for (int i = 0; i < list.length; i++) {
      int day = int.parse(list[i].date!.substring(8, 10));
      var now = DateTime.now();
      var firstday = now.subtract(Duration(days: now.weekday - 1));
      String week_firstday = DateFormat('dd').format(firstday);
      int weekday = day - int.parse(week_firstday) + 1;
      lastWeekCCT[weekday] = (list[i].cctTime! / 3600).toInt();
      lastWeekCC[weekday] = (list[i].cctScore! / list[i].cctTime!).toInt();
    }
  }

  Future<int> getDB() async {
    final Database database = await widget.db;
    List<Map<String, dynamic>> maps;
    List<Concentration> list;

    // 이번달 데이터 추출
    maps = await database.rawQuery(
        "SELECT date, SUM(cctTime) AS cctTime, SUM(cctScore) AS cctScore "
            "FROM concentration "
            "WHERE strftime('%Y-%m', date) = strftime('%Y-%m', 'now', 'localtime') "
            "GROUP BY date "
            "ORDER BY date");
    list = List.generate(maps.length, (i) {
      return Concentration(
          date: maps[i]['date'].toString(),
          cctTime: maps[i]['cctTime'],
          cctScore: maps[i]['cctScore']);
    });
    initMonthList(list);

    // 저번달 데이터 추출
    maps = await database.rawQuery(
        "SELECT date, SUM(cctTime) AS cctTime, SUM(cctScore) AS cctScore "
            "FROM concentration "
            "WHERE strftime('%Y-%m', date) = strftime('%Y-%m', 'now', 'localtime', '-1 months') "
            "GROUP BY date "
            "ORDER BY date");
    list = List.generate(maps.length, (i) {
      return Concentration(
          date: maps[i]['date'].toString(),
          cctTime: maps[i]['cctTime'],
          cctScore: maps[i]['cctScore']);
    });
    initLastMonthList(list);

    // 이번주 데이터 추출
    maps = await database.rawQuery(
        "SELECT date, SUM(cctTime) AS cctTime, SUM(cctScore) AS cctScore "
            "FROM concentration "
            "WHERE strftime('%Y-%m-%d', date) >= strftime('%Y-%m-%d', 'now', 'localtime', '-6 days', 'weekday 1') "
            "GROUP BY date "
            "ORDER BY date");
    list = List.generate(maps.length, (i) {
      return Concentration(
          date: maps[i]['date'].toString(),
          cctTime: maps[i]['cctTime'],
          cctScore: maps[i]['cctScore']);
    });
    initWeekList(list);

    // 저번주 데이터 추출
    maps = await database.rawQuery(
        "SELECT date, SUM(cctTime) AS cctTime, SUM(cctScore) AS cctScore "
            "FROM concentration "
            "WHERE strftime('%Y-%m-%d', date) >= strftime('%Y-%m-%d', 'now', 'localtime', '-13 days', 'weekday 1') "
            "AND strftime('%Y-%m-%d', date) <= strftime('%Y-%m-%d', 'now', 'localtime', '-7 days', 'weekday 0') "
            "GROUP BY date "
            "ORDER BY date");
    list = List.generate(maps.length, (i) {
      return Concentration(
          date: maps[i]['date'].toString(),
          cctTime: maps[i]['cctTime'],
          cctScore: maps[i]['cctScore']);
    });
    initLastWeekList(list);

    _initTotal();
    return 1;
  }

  Widget MonthCCTBuilder(BuildContext context, AsyncSnapshot<int> snapshot) {
    switch (snapshot.connectionState) {
      case ConnectionState.none:
        return CircularProgressIndicator();
      case ConnectionState.waiting:
        return CircularProgressIndicator();
      case ConnectionState.active:
        return CircularProgressIndicator();
      case ConnectionState.done:
        return _LineChartMonth(Factor: curMonthCCT, last_Factor: lastMonthCCT);
    }
  }

  Widget WeekCCTBuilder(BuildContext context, AsyncSnapshot<int> snapshot) {
    switch (snapshot.connectionState) {
      case ConnectionState.none:
        return CircularProgressIndicator();
      case ConnectionState.waiting:
        return CircularProgressIndicator();
      case ConnectionState.active:
        return CircularProgressIndicator();
      case ConnectionState.done:
        return _LineChartWeek(Factor: curWeekCCT, last_Factor: lastWeekCCT);
    }
  }

  Widget MonthCCBuilder(BuildContext context, AsyncSnapshot<int> snapshot) {
    switch (snapshot.connectionState) {
      case ConnectionState.none:
        return CircularProgressIndicator();
      case ConnectionState.waiting:
        return CircularProgressIndicator();
      case ConnectionState.active:
        return CircularProgressIndicator();
      case ConnectionState.done:
        return _LineChartMonthCC(Factor: curMonthCC, last_Factor: lastMonthCC);
    }
  }

  Widget WeekCCBuilder(BuildContext context, AsyncSnapshot<int> snapshot) {
    switch (snapshot.connectionState) {
      case ConnectionState.none:
        return CircularProgressIndicator();
      case ConnectionState.waiting:
        return CircularProgressIndicator();
      case ConnectionState.active:
        return CircularProgressIndicator();
      case ConnectionState.done:
        return _LineChartWeekCC(Factor: curWeekCC, last_Factor: lastWeekCC);
    }
  }

  Widget totalCCBuilder(BuildContext context, AsyncSnapshot<int> snapshot) {
    switch (snapshot.connectionState) {
      case ConnectionState.none:
        return CircularProgressIndicator();
      case ConnectionState.waiting:
        return CircularProgressIndicator();
      case ConnectionState.active:
        return CircularProgressIndicator();
      case ConnectionState.done:
        return Text('${insertTotalCC.toString()} %',
            style: TextStyle(
                fontFamily: 'Cafe24',
                fontSize: MediaQuery.of(context)
                    .size
                    .width *
                    0.04,
                color: HexColor('#FFFFFF')));
    }
  }

  Widget totalLastCCBuilder(BuildContext context, AsyncSnapshot<int> snapshot) {
    switch (snapshot.connectionState) {
      case ConnectionState.none:
        return CircularProgressIndicator();
      case ConnectionState.waiting:
        return CircularProgressIndicator();
      case ConnectionState.active:
        return CircularProgressIndicator();
      case ConnectionState.done:
        return Text('${insertLastCC.toString()} %',
            style: TextStyle(
                fontFamily: 'Cafe24',
                fontSize: MediaQuery.of(context)
                    .size
                    .width *
                    0.04,
                color: HexColor('#FFFFFF')));
    }
  }

  Widget totalCCTBuilder(BuildContext context, AsyncSnapshot<int> snapshot) {
    switch (snapshot.connectionState) {
      case ConnectionState.none:
        return CircularProgressIndicator();
      case ConnectionState.waiting:
        return CircularProgressIndicator();
      case ConnectionState.active:
        return CircularProgressIndicator();
      case ConnectionState.done:
        return Text(
            '${(insertTotalCCT / 3600).toInt().toString()} 시간',
            style: TextStyle(
                fontFamily: 'Cafe24',
                fontSize: MediaQuery.of(context)
                    .size
                    .width *
                    0.04,
                color: HexColor('#FFFFFF')));
    }
  }

  Widget totalLastCCTBuilder(BuildContext context, AsyncSnapshot<int> snapshot) {
    switch (snapshot.connectionState) {
      case ConnectionState.none:
        return CircularProgressIndicator();
      case ConnectionState.waiting:
        return CircularProgressIndicator();
      case ConnectionState.active:
        return CircularProgressIndicator();
      case ConnectionState.done:
        return Text(
            '${(insertLastCCT / 3600).toInt().toString()} 시간',
            style: TextStyle(
                fontFamily: 'Cafe24',
                fontSize: MediaQuery.of(context)
                    .size
                    .width *
                    0.04,
                color: HexColor('#FFFFFF')));
    }
  }

  void _insertDB() {
    /*
    들어가야 하는 내용
    1. DB 변환 : CC는 일자 별 총 시간으로 한 번 씩 나누고 들어가야 함, CCT는 삽입 전에 3600으로 나눌 것
    2. 일자 확인 : 현재 일자(Datetime) 기준, 속하는 달을 이번달 리스트, 과거는 저번달 리스트
    3. DB 없을 때 처리 : 원하는 일자에 DB가 존재하지 않으면 해당 배열값은 0.
     */
    checkDB = getDB();
  }

  void _initTotal() {
    int curweekcount = 0;
    int lastweekcount = 0;
    int curcount = 0;
    int lastcount = 0;
    for (int i = 1; i <= 31; i++) {
      if (i <= 7) {
        if (curWeekCCT[i] != 0) {
          curweekcount += 1;
        }
        if (lastWeekCCT[i] != 0) {
          lastweekcount += 1;
        }
        totalCCTW += curWeekCCT[i];
        totalCCW += curWeekCC[i];
        last_totalCCTW += lastWeekCCT[i];
        last_totalCCW += lastWeekCC[i];
      }
      if (curMonthCCT[i] != 0) {
        curcount += 1;
      }
      if (lastMonthCCT[i] != 0) {
        lastcount += 1;
      }
      totalCCT += curMonthCCT[i];
      totalCC += curMonthCC[i];
      last_totalCCT += lastMonthCCT[i];
      last_totalCC += lastMonthCC[i];
    }
    if (curcount == 0) {
      curcount = 1;
    }
    if (lastcount == 0) {
      lastcount = 1;
    }
    if (curweekcount == 0) {
      curweekcount = 1;
    }
    if (lastweekcount == 0) {
      lastweekcount = 1;
    }
    last_totalCC = (last_totalCC / lastcount).toInt();
    last_totalCCW = (last_totalCCW / lastweekcount).toInt();
    totalCC = (totalCC / curcount).toInt();
    totalCCW = (totalCCW / curweekcount).toInt();
    totalCCTW *= 3600;
    totalCCT *= 3600;
    last_totalCCTW *= 3600;
    last_totalCCT *= 3600;

    insertTotalCC = totalCCW;
    insertLastCC = last_totalCCW;
    insertTotalCCT = totalCCTW;
    insertLastCCT = last_totalCCTW;
    insertLimitedCCT = limitedCCTW;
  }

  @override
  void initState() {
    super.initState();
    selectedPeriodCCT = 1;
    selectedPeriodCC = 1;
    selectedTabMonths = 0;
    selectedTabWeeks = 1;
    _insertDB();
    insertTotalCC = totalCCW;
    insertLastCC = last_totalCCW;
    insertTotalCCT = totalCCTW;
    insertLastCCT = last_totalCCTW;
    insertLimitedCCT = limitedCCTW;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: HexColor('#24202E'),
      child: Column(children: <Widget>[
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.05,
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.25,
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '  종합',
                      style: TextStyle(
                        color: HexColor('#FFFFFF'),
                        fontFamily: 'pyeongchang',
                        fontSize: MediaQuery.of(context).size.height * 0.03,
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).size.height * 0.003,
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: _TabColor[selectedTabWeeks],
                            width: MediaQuery.of(context).size.height * 0.002,
                          ),
                        ),
                      ),
                      child: CupertinoButton(
                        minSize: 0,
                        padding: EdgeInsets.all(0),
                        onPressed: () {
                          setState(() {
                            selectedPeriodCCT = 1;
                            selectedPeriodCC = 1;
                            selectedTabWeeks = 1;
                            selectedTabMonths = 0;
                            insertLimitedCCT = limitedCCTW;
                            insertTotalCCT = totalCCTW;
                            insertTotalCC = totalCCW;
                            insertLastCCT = last_totalCCTW;
                            insertLastCC = last_totalCCW;
                          });
                        },
                        child: Text(
                          'Week',
                          style: TextStyle(
                            fontSize:
                                MediaQuery.of(context).size.height * 0.017,
                            color: HexColor('#FFFFFF'),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 0.025,
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).size.height * 0.003,
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: _TabColor[selectedTabMonths],
                            width: MediaQuery.of(context).size.height * 0.002,
                          ),
                        ),
                      ),
                      child: CupertinoButton(
                        minSize: 0,
                        padding: EdgeInsets.all(0),
                        onPressed: () {
                          setState(() {
                            selectedPeriodCCT = 0;
                            selectedPeriodCC = 0;
                            selectedTabWeeks = 0;
                            selectedTabMonths = 1;
                            insertLastCC = last_totalCC;
                            insertLastCCT = last_totalCCT;
                            insertLimitedCCT = limitedCCT;
                            insertTotalCC = totalCC;
                            insertTotalCCT = totalCCT;
                          });
                        },
                        child: Text(
                          'Month',
                          style: TextStyle(
                            fontSize:
                                MediaQuery.of(context).size.height * 0.017,
                            color: HexColor('#FFFFFF'),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.05,
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                Row(
                  children: <Widget>[
                    Flexible(
                      flex: 1,
                      fit: FlexFit.loose,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.1,
                      ),
                    ),
                    Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        Container(
                          child: CustomPaint(
                            size: Size(
                              MediaQuery.of(context).size.height * 0.15,
                              MediaQuery.of(context).size.height * 0.15,
                            ),
                            painter: _PieChart(
                              percentage:
                                  (((insertLimitedCCT - insertTotalCCT) /
                                              insertLimitedCCT) *
                                          100)
                                      .toInt(),
                              barColor: HexColor('#FFD740'),
                              strokelen:
                                  (MediaQuery.of(context).size.width * 0.2)
                                      .toInt(),
                            ),
                          ),
                        ),
                        Container(
                          child: CustomPaint(
                            size: Size(
                              MediaQuery.of(context).size.height * 0.13,
                              MediaQuery.of(context).size.height * 0.13,
                            ),
                            painter: _PieChart(
                              percentage:
                                  (((limitedCC - insertTotalCC) / limitedCC) *
                                          100)
                                      .toInt(),
                              barColor: HexColor('#90EE90'),
                              strokelen:
                                  (MediaQuery.of(context).size.width * 0.2)
                                      .toInt(),
                            ),
                          ),
                        ),
                        Container(
                            child: Icon(
                          CupertinoIcons.drop,
                          size: MediaQuery.of(context).size.height * 0.1,
                          color: HexColor('#FFFFFF'),
                        )),
                      ],
                    ),
                    Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.3,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Icon(
                              CupertinoIcons.timer,
                              size: MediaQuery.of(context).size.height * 0.05,
                              color: HexColor('#FFD740'),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.03,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.45,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.2,
                                    child: Column(
                                      children: <Widget>[
                                        Text(
                                          '저번${_changePeriods[selectedTabWeeks]}',
                                          style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.03,
                                            fontWeight: FontWeight.w800,
                                            color: HexColor('#D3D3D3'),
                                          ),
                                        ),
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.01,
                                        ),
                                        FutureBuilder(
                                          builder: totalLastCCTBuilder,
                                          future: checkDB,
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.015,
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.2,
                                    child: Column(
                                      children: <Widget>[
                                        Text(
                                          '이번${_changePeriods[selectedTabWeeks]}',
                                          style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.03,
                                            fontWeight: FontWeight.w800,
                                            color: HexColor('#D3D3D3'),
                                          ),
                                        ),
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.01,
                                        ),
                                        FutureBuilder(
                                          builder: totalCCTBuilder,
                                          future: checkDB,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        Row(
                          children: <Widget>[
                            Icon(
                              CupertinoIcons.lightbulb,
                              size: MediaQuery.of(context).size.height * 0.05,
                              color: HexColor('#90EE90'),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.03,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.45,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.2,
                                    child: Column(
                                      children: <Widget>[
                                        Text(
                                          '저번${_changePeriods[selectedTabWeeks]}',
                                          style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.03,
                                            fontWeight: FontWeight.w800,
                                            color: HexColor('#D3D3D3'),
                                          ),
                                        ),
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.01,
                                        ),
                                        FutureBuilder(
                                          builder: totalLastCCBuilder,
                                          future: checkDB,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.015,
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.2,
                                    child: Column(
                                      children: <Widget>[
                                        Text(
                                          '이번${_changePeriods[selectedTabWeeks]}',
                                          style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width * 0.03,
                                            fontWeight: FontWeight.w800,
                                            color: HexColor('#D3D3D3'),
                                          ),
                                        ),
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height * 0.01,
                                        ),
                                        FutureBuilder(
                                          builder: totalCCBuilder,
                                          future: checkDB,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.05
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.03),
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.25,
          child: Stack(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '  집중시간',
                        style: TextStyle(
                          color: HexColor('#FFFFFF'),
                          fontSize: MediaQuery.of(context).size.width * 0.05,
                          fontFamily: 'pyeongchang',
                          letterSpacing: 2,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      Flexible(
                        flex: 1,
                        fit: FlexFit.tight,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                              color: Color(0xFFAA4CFC),
                              shape: BoxShape.circle,
                            ),
                            width: MediaQuery.of(context).size.width * 0.02,
                            height: MediaQuery.of(context).size.width * 0.02,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.015,
                          ),
                          Text(
                            '저번${_changePeriods[selectedTabWeeks]}',
                            style: TextStyle(
                              color: HexColor('#FFFFFF'),
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.015,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                      Row(
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                              color: Color(0xFF4AF699),
                              shape: BoxShape.circle,
                            ),
                            width: MediaQuery.of(context).size.width * 0.02,
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.015,
                          ),
                          Text(
                            '이번${_changePeriods[selectedTabWeeks]}',
                            style: TextStyle(
                              color: HexColor('#FFFFFF'),
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.015,
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.05,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16, left: 6),
                      child: FutureBuilder(
                        builder: _periodsCCT[selectedPeriodCCT],
                        future: checkDB,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.03),
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.25,
          child: Stack(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  Text(
                    '  집중도',
                    style: TextStyle(
                      color: HexColor('#FFFFFF'),
                      fontSize: MediaQuery.of(context).size.width * 0.05,
                      fontFamily: 'pyeongchang',
                      letterSpacing: 2,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16, left: 6),
                      child: FutureBuilder(
                        builder: _periodsCC[selectedPeriodCC],
                        future: checkDB,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                ],
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
