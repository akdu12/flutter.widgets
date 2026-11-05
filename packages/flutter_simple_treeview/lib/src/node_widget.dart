// Copyright 2020 the Dart project authors.
//
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file or at
// https://developers.google.com/open-source/licenses/bsd

import 'package:flutter/material.dart';

import 'builder.dart';
import 'primitives/tree_controller.dart';
import 'primitives/tree_node.dart';

/// Widget that displays one [TreeNode] and its children.
class NodeWidget extends StatefulWidget {
  final TreeNode treeNode;
  final double? indent;
  final TreeController state;

  const NodeWidget(
      {Key? key, required this.treeNode, this.indent, required this.state})
      : super(key: key);

  @override
  _NodeWidgetState createState() => _NodeWidgetState();
}

class _NodeWidgetState extends State<NodeWidget> {
  bool get _isLeaf {
    return widget.treeNode.children == null ||
        widget.treeNode.children!.isEmpty;
  }

  bool get _isExpanded {
    return widget.state.isNodeExpanded(widget.treeNode.key!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.treeNode.content,
        if (_isExpanded && !_isLeaf)
          Padding(
            padding: EdgeInsets.only(left: widget.indent!),
            child: buildNodes(
                widget.treeNode.children!, widget.indent, widget.state),
          )
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    widget.state.addListener(widget.treeNode.key!, _rebuild);
  }

  // If this State is reused for another node, move the listener to that node.
  // Otherwise the controller keeps calling this State under the old node's
  // key, also after it is disposed.
  @override
  void didUpdateWidget(NodeWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldKey = oldWidget.treeNode.key!;
    final newKey = widget.treeNode.key!;
    if (oldWidget.state != widget.state || oldKey != newKey) {
      oldWidget.state.removeListener(oldKey, _rebuild);
      widget.state.addListener(newKey, _rebuild);
    }
  }

  @override
  void dispose() {
    widget.state.removeListener(widget.treeNode.key!, _rebuild);
    super.dispose();
  }

  void _rebuild() {
    if (mounted) setState(() {});
  }
}
