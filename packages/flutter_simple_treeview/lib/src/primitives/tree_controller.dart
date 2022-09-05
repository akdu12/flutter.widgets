// Copyright 2020 the Dart project authors.
//
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file or at
// https://developers.google.com/open-source/licenses/bsd

import 'package:flutter/foundation.dart';

/// A controller for a tree state.
///
/// Allows to modify the state of the tree.
class TreeController {
  bool _allNodesExpanded;
  final Map<Key, bool> _expanded = <Key, bool>{};
  final Map<Key, VoidCallback> _listeners = <Key, VoidCallback>{};
  final Map<Key, ValueNotifier<bool>> _stateNotifier = <Key, ValueNotifier<bool>>{};

  TreeController({allNodesExpanded = true})
      : _allNodesExpanded = allNodesExpanded;

  bool get allNodesExpanded => _allNodesExpanded;

  bool isNodeExpanded(Key key) {
    return _expanded[key] ?? _allNodesExpanded;
  }

  void toggleNodeExpanded(Key key) {
    _expanded[key] = !isNodeExpanded(key);
    notifyListener(key);
  }

  void expandAll() {
    _allNodesExpanded = true;
    _expanded.clear();
  }

  void collapseAll() {
    _allNodesExpanded = false;
    _expanded.clear();
  }

  void expandNode(Key key) {
    _expanded[key] = true;
    notifyListener(key);
  }

  void collapseNode(Key key) {
    _expanded[key] = false;
    notifyListener(key);
  }

  void addListener(Key key, VoidCallback fn) {
    _listeners[key] = fn;
    _stateNotifier[key] = ValueNotifier<bool>(isNodeExpanded(key));
  }

  void removeListener(Key key) {
    _listeners.remove(key);
    _stateNotifier.remove(key);
  }

  ValueNotifier<bool>?  stateNotifier(Key key) => _stateNotifier[key];

  void notifyListener(Key key) {
    final callback = _listeners[key];
    _stateNotifier[key]!.value = isNodeExpanded(key);
    if (callback != null) {
      callback();
    }
  }
}
