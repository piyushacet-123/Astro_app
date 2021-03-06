
import 'package:astro_app/Dashboard/CardSection/ProfileCardAlignment.dart';
import 'package:astro_app/Dashboard/Profile/ProfilePage.dart';
import 'package:astro_app/constants/constants.dart';
import 'package:astro_app/model/MatchesDetails.dart';
import 'package:astro_app/utils/Theme/AppTheme.dart';
import 'package:astro_app/utils/rest/api/searchApi.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'dart:math';

List<T> map<T>(List list, Function handler) {
  List<T> result = [];
  for (var i = 0; i < list.length; i++) {
    result.add(handler(i, list[i]));
  }

  return result;
}

List<Alignment> cardsAlign = [
  new Alignment(0.0, 1.0),
  new Alignment(0.0, 0.8),
  new Alignment(0.0, 0.0)
];
List<Size> cardsSize = new List(3);

class CardsSectionAlignment extends StatefulWidget {
  CardsSectionAlignment(BuildContext context) {
    cardsSize[0] = new Size(MediaQuery.of(context).size.width * 0.9,
        MediaQuery.of(context).size.height * 0.6);
    cardsSize[1] = new Size(MediaQuery.of(context).size.width * 0.85,
        MediaQuery.of(context).size.height * 0.55);
    cardsSize[2] = new Size(MediaQuery.of(context).size.width * 0.8,
        MediaQuery.of(context).size.height * 0.5);
  }

  @override
  _CardsSectionState createState() => new _CardsSectionState();
}

class _CardsSectionState extends State<CardsSectionAlignment>
    with SingleTickerProviderStateMixin {
  int cardsCounter = 0;
  int _current = 0;

  List<ProfileCardAlignment> cards = new List();
  AnimationController _controller;

  final Alignment defaultFrontCardAlign = new Alignment(0.0, 0.0);
  Alignment frontCardAlign;
  double frontCardRot = 0.0;

  Widget swipeWidgetText(image, upperText, [lowerText = ""]) {
    return FittedBox(
          child: Container(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  image,
                  width: 26,
                  height: 26,
                ),
                SizedBox(
                  width: 6,
                ),
                Text(
                  upperText,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              lowerText,
              style: TextStyle(
                color: Colors.grey,
              ),
            )
          ],
        ),
      ),
    );
  }

  String age = '21-25';
  int preference = 3;
  String seeking = 'M';
  int startLimit = 0;
  int endLimit = 1;

  //Future<List> searchDetails;
  List<MatchesDetails> matchList;
  _loadMatches() async{
    List<MatchesDetails> matchDetailsList;
    matchDetailsList = await SearchApi.getMatches(age, preference, seeking, startLimit, endLimit);
    if (matchList == null) {
      matchList = new List<MatchesDetails>();
    }
    matchList.addAll(matchDetailsList);
    print('afgrtfgaa'+matchList[0].zodiaccard);
  }

  @override
  void initState() {
    super.initState();
    //searchDetails = SearchApi.getSearchDetails(age, preference, seeking, startLimit, endLimit);
    
    // Init cards
    // for (cardsCounter = 0; cardsCounter < 3; cardsCounter++) {
    //   cards.add(new ProfileCardAlignment(cardsCounter));
    // }

    abc();

    frontCardAlign = cardsAlign[2];

    // Init the animation controller
    _controller = new AnimationController(
        duration: new Duration(milliseconds: 700), vsync: this);
    _controller.addListener(() => setState(() {}));
    _controller.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) changeCardsOrder();
    });
    
  }

  void abc() async{
    await _loadMatches();
    setState(() {
      
    });
    print('ppp'+  matchList.length.toString());
    for (cardsCounter = 0; cardsCounter < 3; cardsCounter++) {
      cards.add(new ProfileCardAlignment(cardsCounter,matchList[0].zodiaccard));
    }
  }

  @override
  Widget build(BuildContext context) {
    print('ddd');
    //print(matchList.length);
    List<Widget> yoFuck = [
      swipeWidgetText("assets/images/location_icon.png", "Swipe around the world!",
          "Passport to anywhere with Cielo plus"),
      swipeWidgetText("assets/images/key_icon.png", "Control your profile",
          "Limit what other can see with Cielo Plus! "),
      swipeWidgetText("assets/images/reload_icon.png", "I mean't to swipe right",
          "Get Unlimited rewrad with Cielo plus"),
      swipeWidgetText("assets/images/heart_icon.png", "Increase your Chances",
          "Get Unlimited likes with Cielo plus! "),
    ];
    return Scaffold(
      appBar: AppBar(backgroundColor: AppTheme.appColour,
        leading: InkWell(
            child: Icon(
            Icons.account_circle, size: 40,
          ),
          onTap: () {
            Navigator.pushNamed(context, PROFILE_SCREEN);
            //Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfilePage()));
          },
        ),
        centerTitle: true,
        title: Text('Cielo'),
      ),
      body: matchList == null ?
      Center(
          child: Text('Loading Your matches ...',
          style: TextStyle(fontSize: 18,color: AppTheme.appColour),),
        ) : 
      new Stack(
        children: <Widget>[
          // Text('aaa'),
          Container(
              child: Column(children: [
                CarouselSlider(
                  options: CarouselOptions(
                    height: 70,
                  
                  autoPlay: true,
                  enlargeCenterPage: true,
                  aspectRatio: 2.0,
                  
                  ),
                  
                  items: yoFuck,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: map<Widget>(
                    yoFuck,
                    (index, url) {
                      return Container(
                        width: 8.0,
                        height: 8.0,
                        margin: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 2.0),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _current == index
                                ? Colors.blue
                                : Color.fromRGBO(0, 0, 0, 0.2)),
                      );
                    },
                  ),
                ),
              ],),
            ),
          backCard(),
          middleCard(),
          frontCard(),

          // Prevent swiping if the cards are animating
          _controller.status != AnimationStatus.forward
              ? new SizedBox.expand(
                  child: new GestureDetector(
                  // While dragging the first card
                  onPanUpdate: (DragUpdateDetails details) {
                    // Add what the user swiped in the last frame to the alignment of the card
                    setState(() {
                      // 20 is the "speed" at which moves the card
                      frontCardAlign = new Alignment(
                          frontCardAlign.x +
                              20 *
                                  details.delta.dx /
                                  MediaQuery.of(context).size.width,
                          frontCardAlign.y +
                              40 *
                                  details.delta.dy /
                                  MediaQuery.of(context).size.height);

                      frontCardRot = frontCardAlign.x; // * rotation speed;
                    });
                  },
                  // When releasing the first card
                  onPanEnd: (_) {
                    // If the front card was swiped far enough to count as swiped
                    if (frontCardAlign.x > 3.0 || frontCardAlign.x < -3.0) {
                      animateCards();
                    } else {
                      // Return to the initial rotation and alignment
                      setState(() {
                        frontCardAlign = defaultFrontCardAlign;
                        frontCardRot = 0.0;
                      });
                    }
                  },
                ))
              : new Container(),
        ],
      ),
      
    );
  }

  Widget backCard() {
    return new Align(
      alignment: _controller.status == AnimationStatus.forward
          ? CardsAnimation.backCardAlignmentAnim(_controller).value
          : cardsAlign[0],
      child: new SizedBox.fromSize(
          size: _controller.status == AnimationStatus.forward
              ? CardsAnimation.backCardSizeAnim(_controller).value
              : cardsSize[2],
          child: cards[2]),
    );
  }

  Widget middleCard() {
    return new Align(
      alignment: _controller.status == AnimationStatus.forward
          ? CardsAnimation.middleCardAlignmentAnim(_controller).value
          : cardsAlign[1],
      child: new SizedBox.fromSize(
          size: _controller.status == AnimationStatus.forward
              ? CardsAnimation.middleCardSizeAnim(_controller).value
              : cardsSize[1],
          child: cards[1]),
    );
  }

  Widget frontCard() {
    return new Align(
        alignment: _controller.status == AnimationStatus.forward
            ? CardsAnimation.frontCardDisappearAlignmentAnim(
                    _controller, frontCardAlign)
                .value
            : frontCardAlign,
        child: new Transform.rotate(
          angle: (pi / 180.0) * frontCardRot,
          child: new SizedBox.fromSize(size: cardsSize[0], child: cards[0]),
        ));
  }

  void changeCardsOrder() {
    setState(() {
      // Swap cards (back card becomes the middle card; middle card becomes the front card, front card becomes a new bottom card)
      var temp = cards[0];
      cards[0] = cards[1];
      cards[1] = cards[2];
      cards[2] = temp;

      // cards[2] = new ProfileCardAlignment(cardsCounter);
      // cardsCounter++;

      frontCardAlign = defaultFrontCardAlign;
      frontCardRot = 0.0;
    });
  }

  void animateCards() {
    _controller.stop();
    _controller.value = 0.0;
    _controller.forward();
  }
}

class CardsAnimation {
  static Animation<Alignment> backCardAlignmentAnim(
      AnimationController parent) {
    return new AlignmentTween(begin: cardsAlign[0], end: cardsAlign[1]).animate(
        new CurvedAnimation(
            parent: parent,
            curve: new Interval(0.4, 0.7, curve: Curves.easeIn)));
  }

  static Animation<Size> backCardSizeAnim(AnimationController parent) {
    return new SizeTween(begin: cardsSize[2], end: cardsSize[1]).animate(
        new CurvedAnimation(
            parent: parent,
            curve: new Interval(0.4, 0.7, curve: Curves.easeIn)));
  }

  static Animation<Alignment> middleCardAlignmentAnim(
      AnimationController parent) {
    return new AlignmentTween(begin: cardsAlign[1], end: cardsAlign[2]).animate(
        new CurvedAnimation(
            parent: parent,
            curve: new Interval(0.2, 0.5, curve: Curves.easeIn)));
  }

  static Animation<Size> middleCardSizeAnim(AnimationController parent) {
    return new SizeTween(begin: cardsSize[1], end: cardsSize[0]).animate(
        new CurvedAnimation(
            parent: parent,
            curve: new Interval(0.2, 0.5, curve: Curves.easeIn)));
  }

  static Animation<Alignment> frontCardDisappearAlignmentAnim(
      AnimationController parent, Alignment beginAlign) {
    return new AlignmentTween(
            begin: beginAlign,
            end: new Alignment(
                beginAlign.x > 0 ? beginAlign.x + 30.0 : beginAlign.x - 30.0,
                0.0) // Has swiped to the left or right?
            )
        .animate(new CurvedAnimation(
            parent: parent,
            curve: new Interval(0.0, 0.5, curve: Curves.easeIn)));
  }
}
