import 'dart:convert';

import 'package:dyo_messenger/models/contact.dart';
import 'package:dyo_messenger/models/sms.dart';
import 'package:flutter/services.dart';

class SmsServcie {
  static const platform = const MethodChannel('com.loinv.flutter/sms');

  static Future getAllSms() async {
    List<Sms> listSms;

    var jsonList = await platform.invokeMethod("getAllSms");

    var temp = json.decode(jsonList) as List;

    print(jsonList);

    if (temp.length > 0) {
      listSms = temp.map((e) => Sms.fromMap(e)).toList();
    }

    return listSms;
  }

  static Future getContactByPhoneNo(String phoneNo) async {
    String jsonContact = await platform.invokeMethod(
        "getContactByPhone", <String, dynamic>{'phoneNo': phoneNo});
    Contact contact = Contact.fromJson(jsonContact.toString());
    return contact;
  }

  static Future readAllSms(String phoneNo) async {
    await platform
        .invokeMethod("readAllSms", <String, dynamic>{'phoneNo': phoneNo});
    return null;
  }
}
