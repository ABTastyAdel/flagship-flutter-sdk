import 'dart:math';

import 'package:intl/intl.dart';
import '../flagship.dart';
import 'logger/log_manager.dart';

// length for the envId
const int LengthId = 20;
// pattern for envId
const String xidPattren = "[0-9a-v]{20}";

class FlagshipTools {
  static bool chekcXidEnvironment(String xid) {
    // create RegExp with pattern
    RegExp xidReg = RegExp(xidPattren);
    if (xid.length == LengthId && xidReg.hasMatch(xid)) {
      return true;
    } else {
      Flagship.logger(Level.INFO, "The environmentId : \(xid) is not valide ");
      return false;
    }
  }

  static generateFlagshipId() {
    int min = 10000;
    int max = 99999;
    // Set format
    final format = new DateFormat('yyyyMMddhhmss');
    // Return the uuid
    return format.format(DateTime.now()) + (min + Random().nextInt(max - min)).toString();
  }
}
