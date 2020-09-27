import 'dart:convert';

import 'package:dyo_messenger/models/contact.dart';
import 'package:dyo_messenger/models/sms.dart';
import 'package:dyo_messenger/services/sms_service.dart';
import 'package:hive/hive.dart';

part 'conservation.g.dart';

@HiveType(typeId: 0)
class Conservation {
  @HiveField(0)
  String address;

  @HiveField(1)
  int threadId;

  @HiveField(2)
  Contact contact;

  @HiveField(3)
  List<Sms> messages;

  Conservation({
    this.address,
    this.threadId,
    this.contact,
    this.messages,
  });

  Conservation.fromMessages(List<Sms> messages) {
    if (messages == null || messages.length == 0) {
      return;
    }
    this.threadId = messages[0].threadId;

    for (var msg in messages) {
      if (msg.threadId == threadId && msg.address != null) {
        this.address = msg.address;
        break;
      }
    }

    this.messages = new List();
    for (var msg in messages) {
      if (msg.threadId == threadId) {
        this.messages.add(msg);
      }
    }
  }

  Future findContact() async {
    contact = await SmsServcie.getContactByPhoneNo(address);
  }

  Map<String, dynamic> toMap() {
    return {
      'address': address,
      'threadId': threadId,
      'contact': contact?.toMap(),
      'messages': messages?.map((x) => x?.toMap())?.toList(),
    };
  }

  factory Conservation.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Conservation(
      address: map['address'],
      threadId: map['threadId'],
      contact: Contact.fromMap(map['contact']),
      messages: List<Sms>.from(map['messages']?.map((x) => Sms.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory Conservation.fromJson(String source) =>
      Conservation.fromMap(json.decode(source));
}
