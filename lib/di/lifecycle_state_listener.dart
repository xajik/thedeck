/*
 *
 *  *
 *  * Created on 19 5 2023
 *
 */

import 'package:flutter/material.dart';

class LifecycleState {
  final Set<Function(AppLifecycleState)> listeners = {};
  AppLifecycleState? _state;

  get state => _state;

  LifecycleState();

  void addListener(Function(AppLifecycleState) listener) {
    listeners.add(listener);
  }

  void removeListener(Function(AppLifecycleState) listener) {
    listeners.remove(listener);
  }

  void setLifecycleState(AppLifecycleState state) {
    _state = state;
    for (var element in listeners) {
      element.call(state);
    }
  }
}
