import 'dart:convert';
import 'dart:typed_data';
import 'package:hive/hive.dart';
part 'contact.g.dart';

@HiveType(typeId: 1)
class Contact {
  @HiveField(0)
  String id;

  @HiveField(1)
  String displayName;

  @HiveField(2)
  Uint8List photo;

  Contact({
    this.id,
    this.displayName,
    this.photo,
  });

  Map<String, dynamic> toMap() {
    List<int> ints = new List();
    if (photo != null) {
      photo.forEach((element) {
        ints.add(element);
      });
    }
    return {
      'id': id,
      'displayName': displayName,
      'photo': ints.length > 0 ? Base64Encoder().convert(ints) : null,
    };
  }

  factory Contact.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Contact(
      id: map['id'],
      displayName: map['displayName'],
      photo: map["photo"] != null
          ? Base64Decoder().convert(map["photo"].toString())
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Contact.fromJson(String source) =>
      Contact.fromMap(json.decode(source));
}
