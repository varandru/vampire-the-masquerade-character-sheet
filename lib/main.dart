import 'package:flutter/material.dart';
import 'common.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(
    // enable riverpod
    ProviderScope(
      child: VampireWidget(),
    ),
  );
}
