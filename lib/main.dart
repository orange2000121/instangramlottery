import 'package:instangramlotteryios/contentpage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dio/dio.dart';
import 'package:instangramlotteryios/switch.dart';

final ValueNotifier<bool> showtimeselect = ValueNotifier<bool>(false);
void main() async {
  // SharedPreferences preferences = await SharedPreferences.getInstance();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final urlformkey = GlobalKey<FormState>();
  final _drawerKey = GlobalKey<ScaffoldState>();
  final peopleCountController = TextEditingController();
  final markPeopleCountController = TextEditingController();
  final limitCommentController = TextEditingController();
  late SharedPreferences preferences;
  final ValueNotifier<bool> onsearch = ValueNotifier<bool>(false);
  bool isexcludeMe = true, iscanRepeatComment = true;
  // ignore: avoid_init_to_null
  var response = null;
  Map setting = {'url': '', 'markPeopleCount': 0, 'peopleCount': 0, 'canRepeatComment': true, 'excludeMe': true, 'limitComment': '', 'limitTime': 0};
  @override
  void initState() {
    super.initState();
    getpreferencesetting();
  }

  void getpreferencesetting() async {
    preferences = await SharedPreferences.getInstance();
    markPeopleCountController.text = preferences.getInt('markPeopleCount') == null ? '0' : preferences.getInt('markPeopleCount').toString();
    peopleCountController.text = preferences.getInt('peopleCount') == null ? '0' : preferences.getInt('peopleCount').toString();
    setting['excludeMe'] = preferences.getBool('excludeMe') == null ? true : preferences.getBool('excludeMe');
    setting['canRepeatComment'] = preferences.getBool('canRepeatComment') == null ? true : preferences.getBool('canRepeatComment');
    limitCommentController.text = (preferences.getString('limitComment') == null ? '' : preferences.getString('limitComment'))!;
    setting['limitTime'] = preferences.getInt('limitTime') == null ? 0 : preferences.getInt('limitTime');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var _w = MediaQuery.of(context).size.width;
    var _h = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _drawerKey,
      drawer: Drawer(
        child: ListView(
          children: [
            Container(
              margin: EdgeInsets.all(10),
              height: 50,
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Text(
                    '標記人數',
                    style: TextStyle(fontSize: 30),
                  ),
                  SizedBox(width: 10),
                  SizedBox(
                    width: 75,
                    height: 35,
                    child: Form(
                      // key: markPeopleCountkey,
                      child: TextFormField(
                        controller: markPeopleCountController,
                        // initialValue: String.fromCharCode(setting['markPeopleCount']),
                        // onChanged: (num) {},
                        onSaved: (num) {
                          print(num);
                          setting['markPeopleCount'] = double.parse(num!);
                          print(setting['markPeopleCount'].toString());
                          preferences.setInt('markPeopleCount', int.parse(num));
                        },
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              height: 50,
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Text(
                    '抽獎人數',
                    style: TextStyle(fontSize: 30),
                  ),
                  SizedBox(width: 10),
                  SizedBox(
                    width: 75,
                    height: 35,
                    child: TextFormField(
                      controller: peopleCountController,
                      // key: peopleCountkey,
                      // initialValue: String.fromCharCode(setting['peopleCount']),
                      onChanged: (num) {
                        print(num);
                        setting['peopleCount'] = int.parse(num);
                      },
                      onSaved: (num) {
                        preferences.setInt('peopleCount', int.parse(num!));
                        print(num);
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () {
                  setState(
                    () {
                      iscanRepeatComment = !iscanRepeatComment;
                      setting['canRepeatComment'] = iscanRepeatComment;
                      preferences.setBool('canRepeatComment', iscanRepeatComment);
                      HapticFeedback.lightImpact();
                    },
                  );
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.fastLinearToSlowEaseIn,
                  height: 67,
                  width: 200,
                  decoration: BoxDecoration(
                    color: iscanRepeatComment ? Color(0xFF25AD25) : Color(0xFFE73535),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(iscanRepeatComment ? 0 : 0.3),
                        blurRadius: iscanRepeatComment ? 0 : 10,
                        offset: Offset(0, 7),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      iscanRepeatComment ? '可重複留言' : '不可重複留言',
                      style: TextStyle(
                        color: iscanRepeatComment ? Colors.white.withOpacity(0.5) : Colors.white.withOpacity(0.9),
                        fontWeight: FontWeight.w600,
                        fontSize: 19,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () {
                  setState(
                    () {
                      isexcludeMe = !isexcludeMe;
                      setting['excludeMe'] = isexcludeMe;
                      preferences.setBool('excludeMe', isexcludeMe);
                      HapticFeedback.lightImpact();
                    },
                  );
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.fastLinearToSlowEaseIn,
                  height: 67,
                  width: 200,
                  decoration: BoxDecoration(
                    color: isexcludeMe ? Color(0xFF25AD25) : Color(0xFFE73535),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(isexcludeMe ? 0 : 0.3),
                        blurRadius: isexcludeMe ? 0 : 10,
                        offset: Offset(0, 7),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      isexcludeMe ? '排除自己' : '不排除自己',
                      style: TextStyle(
                        color: isexcludeMe ? Colors.white.withOpacity(0.5) : Colors.white.withOpacity(0.9),
                        fontWeight: FontWeight.w600,
                        fontSize: 19,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '留言格式',
                    style: TextStyle(fontSize: 30),
                  ),
                  SizedBox(width: 10),
                  SizedBox(
                    height: 35,
                    child: TextFormField(
                      // key: limitCommentkey,
                      controller: limitCommentController,
                      // initialValue: setting['limitComment'],
                      onChanged: (text) {
                        setting['limitComment'] = text;
                        print('text : $text');
                      },
                      onSaved: (text) {
                        preferences.setString('limitComment', text!);
                        print('text : $text');
                      },
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
                margin: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('限定時間', style: TextStyle(fontSize: 30)),
                        Switchbutton(),
                      ],
                    ),
                    ValueListenableBuilder(
                      valueListenable: showtimeselect,
                      builder: (BuildContext context, bool value, Widget? child) {
                        print(value);
                        return value
                            ? Row(
                                children: [
                                  TextButton(
                                    child: Text(
                                      setting['limitTime'] == false || setting['limitTime'] == null ? '${DateTime.now()}' : '${DateTime.fromMillisecondsSinceEpoch(setting['limitTime'])}',
                                      // style: TextStyle(fontSize: 30),
                                    ),
                                    onPressed: () async {
                                      var date = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(DateTime.now().year - 3), lastDate: DateTime.now());
                                      var time = await showTimePicker(context: context, initialTime: TimeOfDay.now());
                                      var reasult = DateTime(date!.year, date.month, date.day, time!.hour, time.minute);
                                      print(reasult.toUtc().millisecondsSinceEpoch);
                                      setting['limitTime'] = reasult.toUtc().millisecondsSinceEpoch;
                                      setState(() {});
                                    },
                                  )
                                ],
                              )
                            : SizedBox();
                      },
                    ),
                  ],
                )),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            height: _h * 0.25,
            alignment: Alignment.bottomCenter,
            decoration: BoxDecoration(
              color: Colors.green[400],
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    SizedBox(height: MediaQuery.of(context).padding.top),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                            onPressed: () => _drawerKey.currentState!.openDrawer(),
                            icon: Icon(
                              Icons.list,
                              size: 45,
                            ))
                      ],
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 20),
                  child: TextFormField(
                    key: urlformkey,
                    keyboardType: TextInputType.visiblePassword,
                    onSaved: (text) {},
                    validator: (text) {
                      if (text == null) {
                        return '輸入網址';
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.go,
                    onFieldSubmitted: (url) async {
                      onsearch.value = true;
                      print('peopleCountController:${peopleCountController.text}');
                      if (peopleCountController.text == '') {
                        peopleCountController.text = '0';
                      }
                      if (markPeopleCountController.text == '') {
                        markPeopleCountController.text = '0';
                      }
                      setting['peopleCount'] = int.parse(peopleCountController.text);
                      setting['markPeopleCount'] = int.parse(markPeopleCountController.text);
                      setting['limitComment'] = limitCommentController.text;
                      preferences.setInt('peopleCount', int.parse(peopleCountController.text));
                      preferences.setInt('markPeopleCount', int.parse(markPeopleCountController.text));
                      preferences.setString('limitComment', limitCommentController.text);
                      var dio = Dio();
                      String url = 'https://iglottery.r-dap.com/api/lottery';

                      Map data = {};
                      //data = setting
                      for (var datakey in setting.keys) {
                        data[datakey] = setting[datakey];
                      }
                      //檢查留言限制
                      if (setting['limitComment'].isEmpty) {
                        data['limitComment'] = false;
                      }
                      //檢查時間
                      if (showtimeselect.value == false) {
                        data['limitTime'] = false;
                      }

                      print(setting);
                      for (var i in data.keys) {
                        print('$i:${data[i]}/${data[i].runtimeType}');
                      }
                      response = await dio.post(url, data: data);
                      print(response.data.toString());
                      onsearch.value = false;
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      labelText: '網址',
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                      filled: true,
                      fillColor: Colors.white,
                      // suffixIcon: IconButton(
                      //     onPressed: () async {
                      //       onsearch.value = true;
                      //       print('peopleCountController:${peopleCountController.text}');
                      //       if (peopleCountController.text == '') {
                      //         peopleCountController.text = '0';
                      //       }
                      //       if (markPeopleCountController.text == '') {
                      //         markPeopleCountController.text = '0';
                      //       }
                      //       setting['peopleCount'] = int.parse(peopleCountController.text);
                      //       setting['markPeopleCount'] = int.parse(markPeopleCountController.text);
                      //       setting['limitComment'] = limitCommentController.text;
                      //       preferences.setInt('peopleCount', int.parse(peopleCountController.text));
                      //       preferences.setInt('markPeopleCount', int.parse(markPeopleCountController.text));
                      //       preferences.setString('limitComment', limitCommentController.text);
                      //       var dio = Dio();
                      //       String url = 'https://iglottery.r-dap.com/api/lottery';

                      //       Map data = {};
                      //       //data = setting
                      //       for (var datakey in setting.keys) {
                      //         data[datakey] = setting[datakey];
                      //       }
                      //       //檢查留言限制
                      //       if (setting['limitComment'].isEmpty) {
                      //         data['limitComment'] = false;
                      //       }
                      //       //檢查時間
                      //       if (showtimeselect.value == false) {
                      //         data['limitTime'] = false;
                      //       }

                      //       print(setting);
                      //       for (var i in data.keys) {
                      //         print('$i:${data[i]}/${data[i].runtimeType}');
                      //       }
                      //       response = await dio.post(url, data: data);
                      //       print(response.data.toString());
                      //       onsearch.value = false;
                      //       setState(() {});
                      //     },
                      //     icon: Icon(
                      //       Icons.arrow_right_alt_rounded,
                      //       size: 30,
                      //     )),
                    ),
                    onChanged: (url) {
                      setting['url'] = url;
                    },
                  ),
                ),
              ],
            ),
          ),
          ValueListenableBuilder(
            valueListenable: onsearch,
            builder: (BuildContext context, bool value, Widget? child) {
              return value
                  ? CircularProgressIndicator()
                  : Container(
                      height: _h * 0.75,
                      child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                        ),
                        itemCount: response == null ? 0 : response.data['lottery_result'].length,
                        itemBuilder: (BuildContext context, int index) {
                          String url = response.data['lottery_result'][index]['header'];
                          String name = response.data['lottery_result'][index]['userName'];
                          String content = response.data['lottery_result'][index]['content'];
                          return InkWell(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => ContentPage(url, content, name)));
                            },
                            child: Container(
                              margin: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: Color(0xFFE2E2F1),
                                borderRadius: BorderRadius.all(Radius.circular(15)),
                                boxShadow: [BoxShadow(color: Colors.black)],
                              ),
                              width: _w * 0.3,
                              height: _w * 0.3,
                              alignment: Alignment.topLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.all(5),
                                    width: _w * 0.1,
                                    height: _w * 0.1,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: NetworkImage(url),
                                        fit: BoxFit.fill,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  Text('name:'),
                                  Container(
                                    // alignment: Alignment.topLeft,
                                    width: _w * 0.45,
                                    height: _w * 0.09,
                                    child: Text(
                                      name,
                                      softWrap: true,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Text('content:'),
                                  Container(
                                    width: _w * 0.45,
                                    height: _w * 0.09,
                                    child: Text(
                                      content,
                                      softWrap: true,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
            },
          ),
        ],
      ),
    );
  }
}
