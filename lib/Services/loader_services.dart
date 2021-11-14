import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Loader {
  static Widget circular = const Center(
    child: CircularProgressIndicator(),
  );

  static Widget linear = const Center(
    child: LinearProgressIndicator(),
  );
}
