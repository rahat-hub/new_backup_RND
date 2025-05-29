import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TextWidget extends StatelessWidget {
  final String? text;
  final double? size;
  final Color? color;
  final FontWeight? weight;
  final TextAlign? textAlign;
  final bool? textWrap;
  final int? maxLines;
  final double? letterSpacing;

  const TextWidget({super.key, this.text, this.size, this.color, this.weight, this.textAlign, this.textWrap, this.maxLines, this.letterSpacing});

  @override
  Widget build(BuildContext context) {
    return Text(text ?? "",
        textAlign: textAlign,
        style: Theme.of(Get.context!).textTheme.bodyMedium?.copyWith(color: color, fontSize: size, fontWeight: weight, letterSpacing: letterSpacing),
        maxLines: maxLines,
        softWrap: textWrap);
  }
}
