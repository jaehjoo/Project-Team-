import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'utils.dart';
import 'dark_page.dart';
import 'concentration.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:url_launcher/url_launcher.dart';

// 실제로 앱 실행 시 전면부에 나올 홈페이지 및 집중시간 적용 시 이어지는 DarkPage 화면을 위한 다트 파일
// printDuration : 디지털 시계화면 출력 용도
String printDuration(Duration duration) {
  String twoDigits(int n) {
    if (n >= 10) return "$n";
    return "0$n";
  }

  //String twoDigitHours = twoDigits(duration.inHours); -> 절대 지우지 말 것
  String twoDigitMinutes = twoDigits(duration.inMinutes);
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  return "$twoDigitMinutes:$twoDigitSeconds";
}

// 홈페이지 적용을 위한 위젯
class HomePage extends StatefulWidget {
  final Future<Database> db;
  HomePage(this.db);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /* myValue : 원형 슬라이드로 적용한 시간을 저장하기 위한 용도. DarkPage에 시간을 전달하기 위한 변수이기도 함
     loLoo : 정수로 된 시간 변수 내용물을 문자열로 저장하기 위한 용도
     List<Color> pageColors = 홈페이지의 전체 화면 색상 정하는 용도
     cctTimeDay = 오늘의 집중시간
     cctScoreDay = 오늘의 집중도
     isUpdate = 집중시간 화면 전환 후, 집중시간 및 집중도 최신화 여부 확인
  */
  double myValue = 0;
  String? loLoo;
  int cctTimeDay = 0;
  int cctScoreDay = 0;
  Future<Concentration>? todayCCT;
  bool isUpdate = false;
  final List<Color> pageColors = [HexColor('#24202E'), HexColor('#24202E')];

  @override
  void initState() {
    super.initState();
    myValue = 0;
    todayCCT = getTotalDay();
    loLoo = "00:00";
  }

  Future<Concentration> getTotalDay() async {
    final Database database = await widget.db;
    List<Map<String, dynamic>> maps = await database.rawQuery(
        "SELECT date, SUM(cctTime) AS cctTime, SUM(cctScore) AS cctScore "
            "FROM concentration "
            "WHERE strftime('%Y-%m-%d', date) = strftime('%Y-%m-%d', 'now', 'localtime') "
            "GROUP BY date"
    );
    Concentration data = Concentration(
        date: maps[0]['date'].toString(),
        cctTime: maps[0]['cctTime'],
        cctScore: maps[0]['cctScore']
    );
    print('debug: ${data.cctTime}');
    return data;
  }

  //FlutterDialog는 우상단 소개 페이지 보여주는 버튼 && 소개 페이지
  void FlutterDialog() {
    showCupertinoDialog(
        context: context,
        //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
        barrierDismissible: true,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
            //Dialog Main Title
            title: Column(
              children: <Widget>[
                Image.asset(
                  'assets/M&&B_logo.png',
                  width: 110,
                  height: 110,
                  fit: BoxFit.cover,
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("   to Make the world, Better.\n",
                  style: TextStyle(fontWeight:
                  FontWeight.bold,
                      color: CupertinoColors.activeGreen,
                      fontSize: 20),
                ),//to Make the world, Better
                Text(
                  "우리의 시작은 단순했습니다.\n"
                      "\"to make the world, better\"\n"
                      "더 나은 세상을 만들기 위해.\n"
                      "우리는 고민했습니다.\n"
                      "어떻게 하면 더 나은 세상이 될까?\n"
                      "그래서 만들기로(Make) 했습니다.\n"
                      "더 나은(Better) 세상을 위한 무언가를.\n"
                      "첫 프로젝트 <Good Step>을 시작으로,\n"
                      "한 걸음 한 걸음 묵묵히 걸으려고 합니다.\n"
                      "목적지는 ‘더 나은 세상’ 입니다.\n"
                      "같이 좀 걸을까요?",
                  textAlign: TextAlign.center,
                ),//본문
                Row(
                  children: [
                    SizedBox(
                      height: 75,
                      width: 75,
                    ),
                    Container(
                      height: 30,
                      width: 30,
                      // padding: const EdgeInsets.all(0.0),
                      // margin: const EdgeInsets.all(0.0),
                      decoration: BoxDecoration(
                        color: CupertinoColors.white,
                      ),
                      child: Center(
                        child: GestureDetector(
                          onTap: () {
                            final Uri url = Uri.parse("https://www.instagram.com/make_better_123/");
                            launchUrl(url);
                          },
                          child: Image.asset(
                            'assets/Instagram_logo.png',
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),//instagram
                    SizedBox(
                      height: 40,
                      width: 40,
                    ),
                    Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: CupertinoColors.white,
                      ),
                      child: Center(
                        child: GestureDetector(
                          onTap: () {
                            final Uri url = Uri.parse("https://harvest-lightning-366.notion.site/M-B-2284071d86ac428ab857c079d9c1d478");
                            launchUrl(url);
                          },
                          child: Image.asset(
                            'assets/Notion_logo.png',
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),//notion
                  ],
                ),//notion
              ],
            ),
          );
        });
  }

  Widget totalCctTimeBuilder(BuildContext context, AsyncSnapshot<Concentration> snapshot)
  {
    switch (snapshot.connectionState) {
      case ConnectionState.none:
        return Text('0');
      case ConnectionState.waiting:
        return Text('0');
      case ConnectionState.active:
        return Text('0');
      case ConnectionState.done:
        if (snapshot.hasData) {
          Concentration today = (snapshot.data as Concentration);
          int? totalCctTime = today.cctTime;
          return Text(
            '${(totalCctTime!/3600).toInt().toString()}',
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.03,
              color: HexColor("#FFFFFF"),
            ),
          );
        } else {
          return Text('0');
        }
    }
  }

  Widget totalCctScoreBuilder(BuildContext context, AsyncSnapshot<Concentration> snapshot)
  {
    switch (snapshot.connectionState) {
      case ConnectionState.none:
        return Text('0');
      case ConnectionState.waiting:
        return Text('0');
      case ConnectionState.active:
        return Text('0');
      case ConnectionState.done:
        if (snapshot.hasData) {
          Concentration today = (snapshot.data as Concentration);
          int? totalCctScore = 0;
          if (today.cctTime! > 0)
            totalCctScore = (today.cctScore! / today.cctTime!).toInt();
          return Text(
            '${totalCctScore!.toString()}',
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.03,
              color: HexColor("#FFFFFF"),
            ),
          );
        } else {
          return Text('0');
        }
    }
  }

  // 원형 슬라이더, 슬라이더 내부 버튼, 하단부 상징물을 화면에 띄우는 위젯
  @override
  Widget build(BuildContext context) {
    /* slider : 원형 슬라이더의 다양한 설정을 적용하기 위한 변수.
       SleekCircularSlider : 원형 슬라이더 정의
    */
    final slider = SleekCircularSlider(
      // appearance : 슬라이더 세부 설정 적용
        appearance: CircularSliderAppearance(
          // customWidths : 슬라이더가 돌아가는 구간(track), 슬라이더(progressBar), 궤적에 보이는 그림자(shadow) 크기 적용
          customWidths: CustomSliderWidths(
              trackWidth: MediaQuery.of(context).size.height * 0.02,
              progressBarWidth: MediaQuery.of(context).size.height * 0.015,
              shadowWidth: MediaQuery.of(context).size.height * 0.02
          ),
          // curstomColors : 슬라이더 색깔을 정한다
          customColors: CustomSliderColors(
              dotColor: HexColor('#FFFFFF'),
              trackColor: HexColor('#000000'),
              progressBarColors: [HexColor('#1AB584'), HexColor('#797EF6')],
              shadowColor: HexColor('#000000'),
              shadowMaxOpacity: 0.05
          ),
          // startAngle : 슬라이더 시작 위치, angleRange: 슬라이더가 얼마나 돌아갈지, size : 슬라이더 크기
          startAngle: 270,
          angleRange: 360,
          size: MediaQuery.of(context).size.height * 0.25,
        ),
        /* 슬라이더 원주 길이
           min : 원주가 최초로 시작하는 지점 크기, max : 원주를 돌아 끝에 달했을 때 크기, initialValue : 원주 시작점
         */
        min: 0,
        max: 7500,
        initialValue: 0,
        /* innerWidget : 슬라이더 내부에 뭐를 넣을지 결정. 여기서는 슬라이더 내부에 들어간 버튼을 의미
           double value : 슬라이더를 돌려서 멈춘 지점의 값
         */
        innerWidget: (double value) {
          // Center : 정중앙에 위젯 설치, SizedBox : 위젯 크기 설정, FittedBox : 위젯을 설정한 크기에 딱 맞춘다
          return Center(
              child : SizedBox(
                height: MediaQuery.of(context).size.height * 0.215,
                child: FittedBox(
                  child: FloatingActionButton(
                    backgroundColor: HexColor("#3b444b"),
                    onPressed: () async {
                      // 버튼을 누르면 building context로 위젯 띄우고 그 위젯에 myValue 값 전달
                      isUpdate = await Navigator.push(
                        context,
                        CupertinoPageRoute(builder: (context) => DarkPage(myValue, widget.db)),
                      );
                      /*if (isUpdate) {
                        // setState를 통해 DB에 누적된 값을 다시 받아온다
                        setState(() {
                          if (isUpdate) {
                            todayCCT = getTotalDay();
                            isUpdate = false;
                          }
                        });
                      }*/
                    },
                    // 버튼에 들어가는 상징물
                    child: Container(
                      height: MediaQuery.of(context).size.width * 0.11,
                      width: MediaQuery.of(context).size.width * 0.11,
                      child: Image.asset(
                        'assets/start_icon.png',
                        // color: HexColor('#FFFFFF'),
                      ),
          ),
                    ),
                )
              )
          );
        },
        // value 값이 바뀔 때마다 바뀐 value 값을 myValue에 저장하고 디지털 시계 출력용으로 만든 문자열을 loLoo에 저장
        onChange: (double value) {
          print(value);
          setState(() {
            myValue = (value - value%300);
            loLoo = printDuration(Duration(seconds: myValue.toInt()));
          });
        }
    );
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle : Text(
            'Good Step',
            style: TextStyle(
              fontFamily: 'Harsh',
              fontSize: 22,
              color: HexColor('#FFFFFF'),
          ),
        ),
        // title: Text(
        //   'Thanks, Your \'GoodStep\'',
        //   style: TextStyle(
        //     fontWeight: FontWeight.bold,
        //     fontSize: 25,
        //     color: Colors.lightGreenAccent,
        //   ),),
        trailing: CupertinoButton(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
            onPressed: () => FlutterDialog(),
            child: Image.asset(
              'assets/logo.png',
              fit: BoxFit.fitHeight,
            ),
          ),
        backgroundColor: HexColor("#24202E"),
      ),
      // onPressed: () => FlutterDialog(),
      child: Container(
        // decoration : Container로 둘러싼 화면을 어떻게 꾸밀지 정하는 분야
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: pageColors,
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                tileMode: TileMode.clamp
            )),
        // 원형 슬라이더, 디지털 시계, 하단부 상징물을 세로로 배열에서 화면에 띄운다
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // 열심히 만들어 놓은 원형 슬라이더 설정을 저장해 놓은 slider 변수를 불러서 화면에 띄운다
            Center(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.3,
                child: slider
              ),
            ),
            // 원형 슬라이더와 일정 거리를 두고 디지털 시계용으로 만들어 놓은 문자열 loLoo를 출력
            Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.05,
                  bottom: MediaQuery.of(context).size.height * 0.1
              ),
              child: Text(
                  '$loLoo',
                  style: TextStyle(
                    color: HexColor("#FFFFFF"),
                    fontSize: MediaQuery.of(context).size.height * 0.09,
                    fontWeight: FontWeight.w600,
                  )
              )
            ),
            // 하단부에 배치하기로 한 상징물 2개를 가로로 배열
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Icon(
                        CupertinoIcons.timer,
                        size: MediaQuery.of(context).size.width * 0.1,
                        color: HexColor("#FFFFFF")
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                        '집중시간',
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.025,
                          color: HexColor("#FFFFFF"),
                        ),
                    ),
                    FutureBuilder(
                      builder: totalCctTimeBuilder,
                      future: todayCCT,
                    ),
                  ]
                ),
                Column(
                  children: <Widget>[
                    Icon(
                        CupertinoIcons.lightbulb,
                        size: MediaQuery.of(context).size.width * 0.1,
                        color: HexColor("#FFFFFF")
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      '집중도',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.025,
                        color: HexColor("#FFFFFF"),
                      )
                    ),
                    FutureBuilder(
                      builder: totalCctScoreBuilder,
                      future: todayCCT,
                    ),
                  ]
                ),
              ]
            )
          ],
        ),
      ),
    );
  }
}