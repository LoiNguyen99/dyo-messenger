import 'package:hive/hive.dart';
part 'sms_type.g.dart';

@HiveType(typeId: 2)
enum SmsType {
  @HiveField(0)
  ALL,
  @HiveField(1)
  INBOX,
  @HiveField(2)
  SENT,
  @HiveField(3)
  DRAFT,
  @HiveField(4)
  OUTBOX,
  @HiveField(5)
  FAILED,
  @HiveField(6)
  QUEUE
}
