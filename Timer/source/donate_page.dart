import 'dart:ui';
import 'utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';

class DonatePage extends StatefulWidget {
  @override
  _AwesomeCarouselState createState() => _AwesomeCarouselState();
}

class _AwesomeCarouselState extends State<DonatePage> {

  List<String> data = [
    'assets/donation.png',
    'assets/donation_brand.png',
  ];

  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: HexColor("#161A24"),
      resizeToAvoidBottomInset : false,
      navigationBar: CupertinoNavigationBar(
        middle: Text(
          'Thanks, Your \'GoodStep\'',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: HexColor('#DDE26A'),
          ),
        ),
        backgroundColor: HexColor("#161A24"),
      ),
      child: Column(
          verticalDirection: VerticalDirection.down,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.6,
              alignment: Alignment.center,
              child: Stack(children: [
                AnimatedSwitcher(
                  duration: Duration(milliseconds: 0),
                  child: Container(
                    key: ValueKey<String>(data[_currentPage]),
                    decoration: BoxDecoration(
                      color: HexColor("#161A24"),
                    ),
                  ),
                ),
                FractionallySizedBox(
                  heightFactor: 0.99,
                  child: PageView.builder(
                    itemCount: data.length,
                    onPageChanged: (int page) {
                      setState(() {
                        _currentPage = page;
                      });
                    },
                    itemBuilder: (BuildContext context, int index) {
                      return FractionallySizedBox(
                        widthFactor: 1,
                        child: Container(
                          margin: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(data[index]),
                              fit: BoxFit.fill,
                            ),
                            borderRadius: BorderRadius.circular(32),
                            boxShadow: [
                              BoxShadow(
                                color: CupertinoColors.black.withOpacity(0.3),
                                spreadRadius: 5,
                                blurRadius: 10,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
              ),
            ),//기부증명서, 기부재단 소개
            Container(
              child: Text('\'GoodStep\'은 모든 수익을 기부합니다.', style: TextStyle(
                backgroundColor: HexColor("#161A24"),
                color: CupertinoColors.activeGreen,
                fontSize: 13,
                // decoration: TextDecoration.underline, //밑줄 기능인데 별로임
              ),),
            ),//굿스탭은 모든 수익을 기부합니다.
            SizedBox(
              height: 15,
            ),// 공백용도
            Container(
              height: 30,
              width: 180,
              decoration: BoxDecoration(
                color: HexColor("#161A24"),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: CupertinoColors.black,
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    final Uri url = Uri.parse("https://harvest-lightning-366.notion.site/M-B-2284071d86ac428ab857c079d9c1d478");
                    launchUrl(url);
                  },
                  child: Text(
                    '지난 기부내역',
                    style: TextStyle(
                      //fontWeight: FontWeight.bold,
                        color: HexColor('#DDE26A'),
                        fontSize: 20),
                  ),
                ),
              ),
            ),//지난 기부내역(Notion)
          ],
        ),
    );
  }
}