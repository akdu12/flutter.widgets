// Copyright 2020 the Dart project authors.
//
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file or at
// https://developers.google.com/open-source/licenses/bsd

import 'package:flutter/material.dart';

import 'node_widget.dart';
import 'primitives/tree_controller.dart';
import 'primitives/tree_node.dart';

/// Builds set of [nodes] respecting [state], [indent] and [iconSize].
Widget buildNodes(
    Iterable<TreeNode> nodes, double? indent, TreeController state,{double? childHeight}) {
  return ListView.builder(
    physics: BouncingScrollPhysics(),
    shrinkWrap: true,
    cacheExtent: 0,
    itemExtent: childHeight,
    addSemanticIndexes: false,
    addAutomaticKeepAlives: false,
    addRepaintBoundaries: false,
    itemCount: nodes.length,
    itemBuilder: (context, index) => NodeWidget(
      treeNode: nodes.elementAt(index),
      indent: indent,
      state: state,
      childHeight: childHeight,
    ),
  );
}
