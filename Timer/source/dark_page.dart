import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'home_page.dart';
import 'utils.dart';
import 'notification.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'concentration.dart';
import 'dart:async';
import 'package:google_mobile_ads/google_mobile_ads.dart';

// 원형 슬라이더 내부 버튼을 누르고 튀어 나올 검은 화면을 정의할 클래스
class DarkPage extends StatefulWidget {
  // HomePageState에서 DarkPage로 넘겨준 myValue를 불러온다
  final Future<Database> db;
  final double myValue;
  const DarkPage(this.myValue, this.db);

  @override
  DarkPageState createState() => DarkPageState();
}

class DarkPageState extends State<DarkPage> with WidgetsBindingObserver {
  /* _timer : 실제 시간과 같은 흐름을 적용하기 위한 객체
     loLoo : 디지털 시계 출력용 문자열
     trigger : 위 _timer를 적용하기 위한 스위치
     countTime : 시간이 지나가는 걸 세어줄 변수
     total : myValue 값을 저장하기 위한 변수
     cctTime : DB에 넘겨주기 위한 집중시간 최종값
     ccTScore : DB에 넘겨주기 위한 집중도 최종값
     isRestart : 시간을 새는 행위가 정지된 경우를 판별
  */
  Timer? _timer;
  String? loLoo;
  bool trigger = true;
  bool giveUp = false;
  bool isAlarm = true;
  bool isRestart = false;
  double countTime = 0;
  double total = 0;
  int cctTime = 0;
  int cctScore = 100;
  int finalScore = 0;
  late final InterstitialAd interstitialAd;
  final String interstitialAdUnitId = "ca-app-pub-3940256099942544/1033173712";
  late final RewardedAd rewardedAd;

  //광고
  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad){
            interstitialAd = ad;
            _setFullScreenContentCallback(ad);
          },
          onAdFailedToLoad: (LoadAdError loadAdError){
            print("Interstitial ad failed to load: $loadAdError");
          }
      ),
    );
  }
  //광고
  void _setFullScreenContentCallback(InterstitialAd ad){

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) => print("$ad onAdShowedFullScreenContent"),
      onAdDismissedFullScreenContent: (InterstitialAd ad){
        print("$ad onAdDismissedFullScreenContent");
        ad.dispose();
      },

      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error){
        print("onAdFailedToShowFullScreenContent: $error ");
      },

      onAdImpression: (InterstitialAd ad) => print("$ad Impression occured"),
    );

  }
  //광고
  void _showInterstitialAd(){
    interstitialAd.show();
  }

  @override
  void dispose() {
    // 본 클래스가 앱 상태에서 벗어날 시, timer도 종료
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    /* 본 클래스가 상태로 올라갈 때, total에 myValue 값을 적용,
       loLoo는 myValue를 디지털 시계로 변환한 값 저장, countTime은 시간을 세어주기 위해 0으로 초기화
       또한, 앱 상태 전환을 인지하기 위한 WidgetBinding 추가 */
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    initNotification();
    total = widget.myValue;
    countTime = 0;
    isAlarm = true;
    loLoo = printDuration(Duration(seconds: total.toInt()));
  }

  /*
  앱이 비활성화 되었을 때, 경고 알림창을 띄운다
   */
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    //앱 기능이 정지했을 시, 집중도를 -10점하고 알림창 띄우기, 시간 새는 것 정지 순으로 이어진다
    if (state == AppLifecycleState.paused && isAlarm) {
      cctScore -= 10;
      showNotification();
      _pause();
    }
  }
  void _pause() {
    _timer?.cancel();
    isRestart = true;
  }

  void _insertData(Concentration data) async {
    final Database database = await widget.db;
    await database.insert('concentration', data.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // _start : timer 실행, 디지털 시계 출력, 사전에 설정한 집중시간을 넘겼을 시(countTime < total) 화면 빠져나오기를 적용하는 함수
  void _start() {
    const oneSec = const Duration(seconds: 1);

    var callback = (timer) => {
      setState(() {
        if (countTime < total) {
          countTime++;
          loLoo = printDuration(Duration(seconds: (total - countTime).toInt()));
        } else {
          isAlarm = false;
          // 포기하지 않으면 집중시간은 total과 동일
          if (!giveUp) {
            // 포기하지 않았을 떄, 들어갈 광고
            _showInterstitialAd();
            cctTime = total.toInt();
          } else {
            // 포기했을 때, 들어갈 광고
            _showInterstitialAd();
          }
          // 집중도는 최소한도가 0이기 때문에 음수로 내려가면 안됨
          if (cctScore < 0) {
            cctScore = 0;
          }
          finalScore = cctScore * cctTime;
          // DB 리스트 전달 관련 내용 들어갈 예정
          var now = new DateTime.now();
          String date;
          String time;

          date = DateFormat('yyyy-MM-dd').format(now);
          time = DateFormat('HH:mm').format(now);
          Concentration data = Concentration(
            date: date,
            time: time,
            cctTime: cctTime,
            cctScore: finalScore,
          );
          _insertData(data);
          Navigator.pop(context, true);
        }
      })
    };

    _timer = Timer.periodic(oneSec, callback);
  }



  @override
  Widget build(BuildContext context) {
    // _start() 함수를 한 번 실행하고 난 뒤, 추가 실행하지 않는다. 안 그러면 위젯 내부에서 여러번 _start가 중복됨
    if (trigger) {
      _loadInterstitialAd();
      _start();
      trigger = false;
    }
    return CupertinoPageScaffold(
      // 화면 전체에 터치 이벤트를 넣기 위해 body 부분을 GestureDetector로 감싼다
      backgroundColor: HexColor("#00000"),
      child: GestureDetector(
        // behavior : 터치 이벤트가 적용되는 부분을 사전에 설정된 범위가 아닌 화면 전 범위로 설정
          behavior: HitTestBehavior.translucent,
          onTap: () {
            // tab하고 팝업창을 띄우기 위한 설정
            if (!giveUp) {
              showCupertinoDialog(
                  barrierDismissible: true,
                  context: context,
                  builder: (BuildContext context) {
                    return CupertinoAlertDialog(
                      content: Container(
                        height: MediaQuery
                            .of(context)
                            .size
                            .height * 0.05,
                        alignment: Alignment.center,
                        child: Text(
                          isRestart ? '재시작하시겠습니까?' : '포기하시겠습니까?',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      // 팝업창에서 실제 이벤트가 벌어지는 부분
                      actions: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Expanded(
                              child: CupertinoDialogAction(
                                isDefaultAction: true,
                                child: Text('예'),
                                onPressed: () {
                                  isAlarm = false;
                                  // 예를 누르면 팝업창 빠져나오고 동시에 countTime = total이 되면서 검은 화면도 탈출
                                  if (isRestart) {
                                    isRestart = false;
                                    _start();
                                  } else {
                                    cctTime = (countTime).toInt();
                                    cctScore -= 50;
                                    countTime = total;
                                    giveUp = true;
                                  }
                                  Navigator.of(context).pop();
                                },
                              ),
                            ),
                            Expanded(
                              child: CupertinoDialogAction(
                                isDefaultAction: true,
                                child: Text('아니오'),
                                onPressed: () {
                                  // 아니오를 누르면 팝업창만 탈출
                                  if (!isRestart) {
                                    cctScore -= 5;
                                  }
                                  Navigator.of(context).pop();
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  }
              );
            };
            },
            // 터치 이벤트가 없을 시, 아래 내용이 기본적으로 화면에 출력됨
            child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
            Center(
            // 디지털 시계를 출력하는 부분
            child: Text('$loLoo',
            style: TextStyle(
            color: HexColor("#FFFFFF"),
            fontSize: MediaQuery.of(context).size.width * 0.2,
            fontWeight: FontWeight.w600,
            ),
            ),
            ),
            ]
            )
      ),
    );
  }
}

