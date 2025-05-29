// Copyright 2020 the Dart project authors.
//
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file or at
// https://developers.google.com/open-source/licenses/bsd

import 'package:aviation_rnd/core/custom_lib/lib/simple_tree_view/src/builder.dart';
import 'package:aviation_rnd/core/custom_lib/lib/simple_tree_view/src/primitives/tree_controller.dart';
import 'package:aviation_rnd/core/custom_lib/lib/simple_tree_view/src/primitives/tree_node.dart';
import 'package:aviation_rnd/shared/shared.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Widget that displays one [TreeNode] and its children.
class NodeWidget extends StatefulWidget {
  const NodeWidget({required this.treeNode, required this.state, super.key, this.indent, this.contentBuilder, this.iconSize});

  final TreeNode treeNode;
  final double? indent;
  final double? iconSize;
  final TreeController state;

  final ContentBuilder? contentBuilder;

  @override
  NodeWidgetState createState() => NodeWidgetState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<TreeNode>('treeNode', treeNode))
      ..add(DoubleProperty('indent', indent))
      ..add(DoubleProperty('iconSize', iconSize))
      ..add(DiagnosticsProperty<TreeController>('state', state))
      ..add(ObjectFlagProperty<ContentBuilder?>.has('contentBuilder', contentBuilder));
  }
}

class NodeWidgetState extends State<NodeWidget> {
  bool get _isLeaf => widget.treeNode.children == null || widget.treeNode.children!.isEmpty;

  bool get _isExpanded => widget.state.isNodeExpanded(widget.treeNode.key!);

  @override
  Widget build(BuildContext context) {
    final IconData? icon = _isLeaf
        ? null
        : _isExpanded
        ? Icons.expand_more
        : Icons.chevron_right;

    final void Function()? onIconPressed = _isLeaf ? null : () => setState(() => widget.state.toggleNodeExpanded(widget.treeNode.key!));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            IconButton(iconSize: widget.iconSize ?? 24.0, icon: Icon(icon), color: ThemeColorMode.isLight ? Colors.black : Colors.white, onPressed: onIconPressed),
            widget.contentBuilder!.call(context, onIconPressed),
          ],
        ),
        if (_isExpanded && !_isLeaf)
          Padding(
            padding: EdgeInsets.only(left: widget.indent!),
            child: buildNodes(widget.treeNode.children!, widget.indent, widget.state, widget.iconSize),
          ),
      ],
    );
  }
}

typedef ContentBuilder = Widget Function(BuildContext context, void Function()? onTap);
