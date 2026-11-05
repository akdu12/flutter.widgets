// Copyright 2020 the Dart project authors.
//
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file or at
// https://developers.google.com/open-source/licenses/bsd

import 'package:flutter/material.dart';
import 'package:flutter_simple_treeview/flutter_simple_treeview.dart';
import 'package:flutter_simple_treeview/src/node_widget.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _pumpTree(
  WidgetTester tester,
  TreeController controller,
  List<String> names,
) async {
  await tester.pumpWidget(MaterialApp(
    home: SingleChildScrollView(
      child: TreeView(
        treeController: controller,
        nodes: [
          for (final name in names)
            TreeNode(
              key: ValueKey(name),
              content: Text(name),
              children: [TreeNode(content: Text('$name child'))],
            ),
        ],
      ),
    ),
  ));
}

void main() {
  group('NodeWidget', () {
    testWidgets('does not rebuild after its node is removed from the tree.',
        (WidgetTester tester) async {
      final controller = TreeController(allNodesExpanded: false);
      await _pumpTree(tester, controller, ['a', 'b']);
      await _pumpTree(tester, controller, ['b']);
      await _pumpTree(tester, controller, []);

      controller.expandNode(ValueKey('a'));
      controller.expandNode(ValueKey('b'));
      await tester.pump();

      expect(tester.takeException(), isNull);
    });

    testWidgets('follows its node when the node list changes.',
        (WidgetTester tester) async {
      final controller = TreeController(allNodesExpanded: false);
      await _pumpTree(tester, controller, ['a', 'b']);
      await _pumpTree(tester, controller, ['b']);

      controller.expandNode(ValueKey('b'));
      await tester.pump();

      expect(find.text('b child'), findsOneWidget);
    });

    testWidgets('moves its listener when it is reused for another node.',
        (WidgetTester tester) async {
      final controller = TreeController(allNodesExpanded: false);
      final shown = ValueNotifier<String>('a');
      await tester.pumpWidget(MaterialApp(
        home: ValueListenableBuilder<String>(
          valueListenable: shown,
          builder: (context, name, _) => NodeWidget(
            treeNode: TreeNode(
              key: ValueKey(name),
              content: Text(name),
              children: [TreeNode(key: ValueKey('$name child'))],
            ),
            indent: 40,
            state: controller,
          ),
        ),
      ));

      shown.value = 'b';
      await tester.pump();
      await tester.pumpWidget(const SizedBox());

      controller.expandNode(ValueKey('a'));
      controller.expandNode(ValueKey('b'));
      await tester.pump();

      expect(tester.takeException(), isNull);
    });
  });
}
