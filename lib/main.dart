import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dio/dio.dart';

void main() async {
  // SharedPreferences preferences = await SharedPreferences.getInstance();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // final preferences;
  // MyApp(this.preferences);
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
  // final SharedPreferences preferences;
  // HomePage(this.preferences);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final urlformkey = GlobalKey<FormState>();
  final _drawerKey = GlobalKey<ScaffoldState>();
  final settingkey = GlobalKey<FormState>();
  late SharedPreferences preferences;
  bool isexcludeMe = true, iscanRepeatComment = true;
  Map setting = {'url': '', 'markPeopleCount': 0, 'peopleCount': 0, 'canRepeatComment': true, 'excludeMe': true, 'limitComment': '', 'limitTime': 0};
  @override
  void initState() {
    super.initState();
    getpreferencesetting();
  }

  void getpreferencesetting() async {
    preferences = await SharedPreferences.getInstance();
    setting['markPeopleCount'] = preferences.getInt('markPeopleCount') == null ? 0 : preferences.getInt('markPeopleCount');
    setting['peopleCount'] = preferences.getInt('peopleCount') == null ? 0 : preferences.getInt('peopleCount');
    setting['excludeMe'] = preferences.getBool('excludeMe') == null ? true : preferences.getBool('excludeMe');
    setting['canRepeatComment'] = preferences.getBool('canRepeatComment') == null ? true : preferences.getBool('canRepeatComment');
    setting['limitComment'] = preferences.getString('limitComment') == null ? '' : preferences.getString('limitComment');
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
                    child: TextFormField(
                      initialValue: String.fromCharCode(setting['markPeopleCount']),
                      onChanged: (num) {
                        print(num);
                        setting['markPeopleCount'] = int.parse(num);
                        preferences.setInt('markPeopleCount', int.parse(num));
                        print(setting['markPeopleCount']);
                      },
                      key: settingkey,
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
                      initialValue: String.fromCharCode(setting['peopleCount']),
                      onChanged: (num) {
                        setting['peopleCount'] = int.parse(num);
                        preferences.setInt('peopleCount', int.parse(num));
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
                      initialValue: setting['limitComment'],
                      onChanged: (text) {
                        setting['limitComment'] = text;
                        preferences.setString('limitComment', text);
                        print(text);
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
                    Text('限定時間', style: TextStyle(fontSize: 30)),
                    Row(
                      children: [
                        TextButton(
                          child: Text(
                            setting['limitTime'] == false || setting['limitTime'] == null ? '${DateTime.now()}' : '${DateTime.fromMillisecondsSinceEpoch(setting['limitTime'])}',
                            // style: TextStyle(fontSize: 30),
                          ),
                          onPressed: () async {
                            var date = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime(DateTime.now().year + 10));
                            var time = await showTimePicker(context: context, initialTime: TimeOfDay.now());
                            var reasult = DateTime(date!.year, date.month, date.day, time!.hour, time.minute);
                            print(reasult.toUtc().millisecondsSinceEpoch);
                            setting['limitTime'] = reasult.toUtc().millisecondsSinceEpoch;
                            setState(() {});
                          },
                        )
                      ],
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
                    decoration: InputDecoration(
                      labelText: '網址',
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                      filled: true,
                      fillColor: Colors.white,
                      suffixIcon: IconButton(
                          onPressed: () async {
                            Response response;
                            var dio = Dio();
                            String url = 'https://iglottery.r-dap.com/api/lottery';
                            var data = setting;
                            print('setting:$setting');
                            if (setting['limitComment'].isEmpty) {
                              data['limitComment'] = false;
                            }

                            data['limitTime'] = false;
                            print(setting);
                            for (var i in data.keys) {
                              print('$i:${data[i]}/${data[i].runtimeType}');
                            }
                            response = await dio.post(url, data: data);
                            print(response.data.toString());
                          },
                          icon: Icon(
                            Icons.arrow_right_alt_rounded,
                            size: 30,
                          )),
                    ),
                    onChanged: (url) {
                      setting['url'] = url;
                    },
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: _h * 0.75,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: 20,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  margin: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Color(0xFFE2E2F1),
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    boxShadow: [BoxShadow(color: Colors.black)],
                  ),
                  width: _w * 0.3,
                  height: _w * 0.3,
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Text('name'),
                      Text('留言'),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
