// Copyright 2020 the Dart project authors.
//
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file or at
// https://developers.google.com/open-source/licenses/bsd

import 'package:aviation_rnd/core/custom_lib/lib/simple_tree_view/src/builder.dart';
import 'package:aviation_rnd/core/custom_lib/lib/simple_tree_view/src/copy_tree_nodes.dart';
import 'package:aviation_rnd/core/custom_lib/lib/simple_tree_view/src/primitives/tree_controller.dart';
import 'package:aviation_rnd/core/custom_lib/lib/simple_tree_view/src/primitives/tree_node.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Tree view with collapsible and expandable nodes.
class TreeView extends StatefulWidget {
  TreeView({required List<TreeNode> nodes, super.key, this.indent = 40, this.iconSize, this.treeController}) : nodes = copyTreeNodes(nodes);

  /// List of root level tree nodes.
  final List<TreeNode> nodes;

  /// Horizontal indent between levels.
  final double? indent;

  /// Size of the expand/collapse icon.
  final double? iconSize;

  /// Tree controller to manage the tree state.
  final TreeController? treeController;

  @override
  TreeViewState createState() => TreeViewState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IterableProperty<TreeNode>('nodes', nodes))
      ..add(DoubleProperty('indent', indent))
      ..add(DoubleProperty('iconSize', iconSize))
      ..add(DiagnosticsProperty<TreeController?>('treeController', treeController));
  }
}

class TreeViewState extends State<TreeView> {
  late TreeController? _controller;

  @override
  void initState() {
    _controller = widget.treeController ?? TreeController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => buildNodes(widget.nodes, widget.indent, _controller!, widget.iconSize);
}
