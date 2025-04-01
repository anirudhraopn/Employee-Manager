import 'dart:developer';

import 'package:flutter/material.dart';

class AppErrorHandler {
  static onError(Object e, StackTrace s, String from) {
    final error = FlutterErrorDetails(exception: e, stack: s, library: from);
    log(error.toString());
  }
}
