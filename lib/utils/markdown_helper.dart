import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;

class CodeElementBuilder extends MarkdownElementBuilder {
  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    final language =
        element.attributes['class']?.replaceFirst('language-', '') ?? '';
    final code = element.textContent;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1e3a8a),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (language.isNotEmpty)
            Text(
              language.toUpperCase(),
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          const SizedBox(height: 8),
          Text(
            code,
            style: const TextStyle(
              color: Color(0xFFf0f9ff),
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }
}
