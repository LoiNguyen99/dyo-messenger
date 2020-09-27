import 'package:dyo_messenger/models/conservation.dart';
import 'package:dyo_messenger/models/contact.dart';
import 'package:dyo_messenger/models/sms_type.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

// ignore: must_be_immutable
class MessageTile extends StatefulWidget {
  Conservation conservation;

  MessageTile({Key key, this.conservation}) : super(key: key);

  @override
  _MessageTileState createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  Contact contact;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: tile(),
    );
  }

  Widget tile() {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CircleAvatar(
              backgroundColor: Colors.blue,
              radius: 24,
              backgroundImage: widget.conservation.contact != null &&
                      widget.conservation.contact.photo != null
                  ? MemoryImage(widget.conservation.contact.photo)
                  : AssetImage('assets/icons/person128.png')),
          SizedBox(
            width: 12,
          ),
          Flexible(
            child: Container(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.conservation.contact != null &&
                            widget.conservation.contact.displayName != null
                        ? widget.conservation.contact.displayName + ""
                        : widget.conservation.address + "",
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: widget.conservation.messages[0].read == false
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                  SizedBox(
                    height: 4.0,
                  ),
                  Text(
                    widget.conservation.messages[0].body,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: widget.conservation.messages[0].type ==
                                  SmsType.INBOX &&
                              widget.conservation.messages[0].read == false
                          ? Colors.black87
                          : Colors.black54,
                      fontWeight: widget.conservation.messages[0].type ==
                                  SmsType.INBOX &&
                              widget.conservation.messages[0].read == false
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  )
                ],
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                timeago.format(widget.conservation.messages[0].date,
                    locale: 'en_short'),
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 14.0,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
