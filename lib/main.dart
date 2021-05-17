import 'package:flutter/material.dart';
import 'provider.dart';
import 'package:riverpod/riverpod.dart'

void main() {
  VampireCharacter character = VampireCharacter();
  runApp(
    // enable riverpod
    ProviderScope(child: character.mainInfoWidget,),);
}
