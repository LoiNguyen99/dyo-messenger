import 'package:dyo_messenger/models/conservation.dart';
import 'package:dyo_messenger/models/sms.dart';
import 'package:dyo_messenger/models/sms_type.dart';
import 'package:dyo_messenger/services/sms_service.dart';
import 'package:dyo_messenger/services/time_converter.dart';
import 'package:dyo_messenger/uis/appbar_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;

// ignore: must_be_immutable
class ConservationScreen extends StatefulWidget {
  Conservation conservation;
  int cKey;
  ConservationScreen(
      {Key key, @required this.conservation, @required this.cKey})
      : super(key: key);

  @override
  _ConservationScreenState createState() => _ConservationScreenState();
}

class _ConservationScreenState extends State<ConservationScreen> {
  Box box;

  @override
  void initState() {
    super.initState();
    widget.conservation.messages.sort((a, b) => a.date.compareTo(b.date));
    readAllSms();
  }

  Future readAllSms() async {
    await SmsServcie.readAllSms(widget.conservation.address).then((value) {
      setState(() {
        box = Hive.box('conservations');
        var conservation = box.get(widget.cKey) as Conservation;
        setState(() {
          conservation.messages.forEach((element) {
            if (element.read == false) {
              element.read = true;
            }
          });
        });
        box.put(widget.cKey, conservation);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (box != null) {
      return Scaffold(
        resizeToAvoidBottomInset: true,
        resizeToAvoidBottomPadding: true,
        backgroundColor: Colors.white,
        appBar: appBar(),
        body: body(),
      );
    } else {
      return Scaffold();
    }
  }

  Widget appBar() {
    return AppBar(
      actions: [
        AppbarButton(icon: Icons.call, onPressed: () {}),
        MyPopupMenuButton(
          menuItems: [
            PopupMenuItem(
              child: Text("Ẩn cuộc trò chuyện"),
            ),
            PopupMenuItem(
              child: Text("Đánh dấu spam"),
            ),
            PopupMenuItem(
              child: Text("Xóa cuộc trò chuyện"),
            ),
          ],
        ),
        SizedBox(
          width: 12,
        ),
      ],
      iconTheme: IconThemeData(color: Colors.black),
      backgroundColor: Colors.white,
      title: Container(
        child: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundImage: widget.conservation.contact != null
                  ? widget.conservation.contact.photo != null &&
                          widget.conservation.contact.photo.length > 0
                      ? MemoryImage(widget.conservation.contact.photo)
                      : AssetImage('assets/icons/person64.png')
                  : AssetImage('assets/icons/person64.png'),
            ),
            SizedBox(
              width: 12,
            ),
            Text(
              widget.conservation.contact != null
                  ? widget.conservation.contact.displayName != null
                      ? widget.conservation.contact.displayName
                      : widget.conservation.address
                  : widget.conservation.address,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ],
        ),
      ),
    );
  }

  Widget body() {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 64),
          padding: EdgeInsets.only(bottom: 16.0, left: 16.0, right: 16.0),
          alignment: Alignment.bottomCenter,
          child: ValueListenableBuilder(
              valueListenable: box.listenable(),
              builder: (context, Box value, child) {
                return ListView(
                  reverse: true,
                  shrinkWrap: true,
                  children: (value.get(widget.cKey) as Conservation)
                      .messages
                      .reversed
                      .map((e) => e.type == SmsType.INBOX
                          ? recivedMessage(e)
                          : sentMessage(e))
                      .toList(),
                );
              }),
        ),
        Positioned(
          bottom: 0.0,
          left: 0.0,
          right: 0.0,
          child: Container(
            padding: EdgeInsets.all(16),
            child: TextFormField(
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                suffixIcon: Padding(
                  padding: EdgeInsets.all(0),
                  child: ButtonTheme(
                    minWidth: 0,
                    child: FlatButton(
                      onPressed: () {},
                      child: Icon(Icons.send),
                      shape: CircleBorder(),
                    ),
                  ),
                ),
                hintText: 'What do people call you?',
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50.0),
                  borderSide: BorderSide(color: Colors.grey[300], width: 1.5),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50.0),
                  borderSide: BorderSide(color: Colors.grey[300], width: 1.5),
                ),
              ),
              onSaved: (String value) {
                // This optional block of code can be used to run
                // code when the user saves the form.
              },
              validator: (String value) {
                return value.contains('@') ? 'Do not use the @ char.' : null;
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget recivedMessage(Sms mySmsMessage) {
    return Container(
        margin: EdgeInsets.only(top: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.8,
                  ),
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(25.0),
                      bottomLeft: Radius.circular(25.0),
                      bottomRight: Radius.circular(25.0),
                    ),
                    color: Colors.grey[200],
                  ),
                  child: Text(
                    mySmsMessage.body,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            Text(
              TimeConverter.convert(mySmsMessage.date),
              style: TextStyle(
                color: Colors.black54,
                fontSize: 12,
              ),
            ),
          ],
        ));
  }

  Widget sentMessage(Sms mySmsMessage) {
    return Container(
      margin: EdgeInsets.only(top: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            width: 12,
          ),
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.8,
            ),
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25.0),
                topRight: Radius.circular(25.0),
                bottomLeft: Radius.circular(25.0),
                bottomRight: Radius.circular(0.0),
              ),
              color: Colors.green,
            ),
            child: Text(
              mySmsMessage.body,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
