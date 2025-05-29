// Copyright 2020 the Dart project authors.
//
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file or at
// https://developers.google.com/open-source/licenses/bsd

import 'package:aviation_rnd/core/custom_lib/lib/simple_tree_view/src/node_widget.dart';
import 'package:flutter/material.dart';

/// One node of a tree.
class TreeNode {
  TreeNode({this.key, this.children, this.contentBuilder});

  /// List of child nodes.
  final List<TreeNode>? children;

  /// Final Widget content.
  final ContentBuilder? contentBuilder;

  /// Unique key.
  final Key? key;
}
