import 'package:uuid/uuid.dart';

String genId () {
  var uuid = Uuid();
  final generateId = uuid.v4();
  return generateId;
}