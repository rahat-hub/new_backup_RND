// Copyright 2020 the Dart project authors.
//
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file or at
// https://developers.google.com/open-source/licenses/bsd

import 'package:aviation_rnd/core/custom_lib/lib/simple_tree_view/src/node_widget.dart';
import 'package:aviation_rnd/core/custom_lib/lib/simple_tree_view/src/primitives/tree_controller.dart';
import 'package:aviation_rnd/core/custom_lib/lib/simple_tree_view/src/primitives/tree_node.dart';
import 'package:flutter/material.dart';

/// Builds set of [nodes] respecting [state], [indent] and [iconSize].
Widget buildNodes(Iterable<TreeNode> nodes, double? indent, TreeController state, double? iconSize) => Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: <Widget>[for (final TreeNode node in nodes) NodeWidget(contentBuilder: node.contentBuilder, treeNode: node, indent: indent, state: state, iconSize: iconSize)],
);
