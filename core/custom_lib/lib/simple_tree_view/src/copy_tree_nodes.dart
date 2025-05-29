// Copyright 2020 the Dart project authors.
//
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file or at
// https://developers.google.com/open-source/licenses/bsd

import 'package:aviation_rnd/core/custom_lib/lib/simple_tree_view/src/primitives/key_provider.dart';
import 'package:aviation_rnd/core/custom_lib/lib/simple_tree_view/src/primitives/tree_node.dart';

/// Copies nodes to unmodifiable list, assigning missing keys and checking for duplicates.
List<TreeNode> copyTreeNodes(List<TreeNode>? nodes) => _copyNodesRecursively(nodes, KeyProvider())!;

List<TreeNode>? _copyNodesRecursively(List<TreeNode>? nodes, KeyProvider keyProvider) {
  if (nodes == null) {
    return null;
  }
  return List<TreeNode>.unmodifiable(
    nodes.map((TreeNode n) => TreeNode(contentBuilder: n.contentBuilder, key: keyProvider.key(n.key), children: _copyNodesRecursively(n.children, keyProvider))),
  );
}
