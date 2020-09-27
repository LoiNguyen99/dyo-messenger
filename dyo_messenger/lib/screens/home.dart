import 'package:dyo_messenger/models/conservation.dart';
import 'package:dyo_messenger/models/sms.dart';
import 'package:dyo_messenger/screens/conservation_screen.dart';
import 'package:dyo_messenger/services/sms_service.dart';
import 'package:dyo_messenger/uis/message_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  List<Conservation> conservations;
  Box box;

  double appbarElevation = 0;

  ScrollController listViewScrollController;

  @override
  void initState() {
    super.initState();
    getSms();
    listViewScrollController = new ScrollController();
    listViewScrollController.addListener(_listViewScrollListener);
  }

  @override
  void dispose() {
    super.dispose();
    listViewScrollController.dispose();
  }

  void getSms() async {
    await _askPermissions();
    setState(() {
      box = Hive.box('conservations');
    });
    if (box == null || box.values.length == 0) {
      var contactStatus = await Permission.contacts.status;
      var smsStatus = await Permission.sms.status;
      if (contactStatus.isGranted && smsStatus.isGranted) {
        List<Conservation> tempConservation = await getAllThreads();
        setState(() {
          conservations = tempConservation;
        });
        box.addAll(conservations);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          List<Conservation> tempConservation = await getAllThreads();
          setState(() {
            conservations = tempConservation;
          });

          //await SmsPrefs.saveConservation(conservations);
        },
        child: Image.asset("assets/icons/message128.png"),
      ),
      appBar: appBar(),
      body: box != null
          ? Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: ValueListenableBuilder(
                  valueListenable: box.listenable(),
                  builder: (context, Box value, child) {
                    return ListView(
                      physics: BouncingScrollPhysics(),
                      controller: listViewScrollController,
                      children: value.keys
                          .map((e) => conservationTile(box.get(e), e))
                          .toList(),
                      padding: EdgeInsets.only(bottom: 12.0),
                    );
                  }),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  Widget conservationTile(Conservation conservation, int cKey) {
    return Container(
      margin: EdgeInsets.only(top: 12),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ConservationScreen(cKey: cKey, conservation: conservation),
            ),
          ).then((value) async {
            // await SmsPrefs.getConservation().then((value) {
            //   setState(() {
            //     conservations = value;
            //   });
            // });
          });
        },
        child: MessageTile(
          conservation: conservation,
        ),
      ),
    );
  }

  void _listViewScrollListener() {
    if (listViewScrollController.offset <=
            listViewScrollController.position.minScrollExtent + 50 &&
        !listViewScrollController.position.outOfRange) {
      setState(() {
        appbarElevation = 0;
      });
    }

    if (listViewScrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      setState(() {
        if (appbarElevation == 0) {
          appbarElevation = 3;
        }
      });
    }
  }

  Future<List<Conservation>> getAllThreads() async {
    List<Sms> messages = await SmsServcie.getAllSms();

    Map<int, List<Sms>> filtered = {};
    messages.forEach((msg) {
      if (!filtered.containsKey(msg.threadId)) {
        filtered[msg.threadId] = [];
      }
      filtered[msg.threadId].add(msg);
    });

    List<Conservation> conservations = <Conservation>[];
    for (var k in filtered.keys) {
      final thread = new Conservation.fromMessages(filtered[k]);
      await thread.findContact();
      conservations.add(thread);
    }
    return conservations;
  }

  Widget appBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: appbarElevation,
      actions: <Widget>[
        ButtonTheme(
          minWidth: 5,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: CircleBorder(),
          padding: EdgeInsets.all(4),
          child: FlatButton(
              color: Colors.grey[200],
              onPressed: () {},
              child: Icon(Icons.search)),
        ),
        Theme(
          data: Theme.of(context).copyWith(
            splashColor: Colors.transparent,
          ),
          child: PopupMenuButton(
            elevation: 3,
            color: Colors.white,
            enabled: true,
            icon: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[200],
              ),
              padding: EdgeInsets.all(4),
              child: Icon(
                Icons.more_horiz,
                color: Colors.black,
                size: 24,
              ),
            ),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text("Tin nhắn ẩn danh"),
              ),
              PopupMenuItem(
                child: Text("Thùng rác"),
              ),
              PopupMenuItem(
                child: Text("Spam"),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 12,
        )
      ],
      title: Text(
        'Dyo messenger',
        style: TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  //PERMISSION

  Future<void> _askPermissions() async {
    await [
      Permission.sms,
      Permission.contacts,
    ].request();
  }
}
