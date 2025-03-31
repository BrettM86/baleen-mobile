import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/app_colors.dart';

class MarkdownText extends StatelessWidget {
  final String data;
  final TextStyle? style;
  final int? maxLines;
  final TextOverflow overflow;
  final bool selectable;

  const MarkdownText({
    super.key,
    required this.data,
    this.style,
    this.maxLines,
    this.overflow = TextOverflow.clip,
    this.selectable = false,
  });

  @override
  Widget build(BuildContext context) {
    final defaultStyle = style ?? const TextStyle(
      color: AppColors.textPrimary,
      fontSize: 16,
      height: 1.5,
    );

    final markdownStyleSheet = MarkdownStyleSheet(
      p: defaultStyle,
      a: defaultStyle.copyWith(color: AppColors.primary),
      blockquote: defaultStyle.copyWith(
        color: AppColors.textSecondary,
        fontStyle: FontStyle.italic,
      ),
      code: defaultStyle.copyWith(
        fontFamily: 'monospace',
        backgroundColor: AppColors.cardBackground,
      ),
      codeblockDecoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(4),
      ),
      h1: defaultStyle.copyWith(
        fontSize: defaultStyle.fontSize! * 1.5,
        fontWeight: FontWeight.bold,
      ),
      h2: defaultStyle.copyWith(
        fontSize: defaultStyle.fontSize! * 1.4,
        fontWeight: FontWeight.bold,
      ),
      h3: defaultStyle.copyWith(
        fontSize: defaultStyle.fontSize! * 1.3,
        fontWeight: FontWeight.bold,
      ),
      h4: defaultStyle.copyWith(
        fontSize: defaultStyle.fontSize! * 1.2,
        fontWeight: FontWeight.bold,
      ),
      h5: defaultStyle.copyWith(
        fontSize: defaultStyle.fontSize! * 1.1,
        fontWeight: FontWeight.bold,
      ),
      h6: defaultStyle.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );

    if (selectable) {
      return SelectableText.rich(
        TextSpan(
          text: data,
          style: defaultStyle,
        ),
        maxLines: maxLines,
        textAlign: TextAlign.left,
      );
    }

    return MarkdownBody(
      data: data,
      styleSheet: markdownStyleSheet,
      onTapLink: (text, href, title) {
        if (href != null) {
          launchUrl(Uri.parse(href));
        }
      },
      softLineBreak: true,
      fitContent: true,
      shrinkWrap: true,
      selectable: false,
    );
  }
}
