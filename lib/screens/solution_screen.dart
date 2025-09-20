import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:homeworkai/utils/markdown_helper.dart';
import 'package:google_fonts/google_fonts.dart';

class SolutionScreen extends StatelessWidget {
  final String solution;

  const SolutionScreen({super.key, required this.solution});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Solution'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // Implement share functionality
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFfef3c7),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.lightbulb, color: Color(0xFFf59e0b)),
                ),
                const SizedBox(width: 12),
                Text(
                  'Solution',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontSize: 24),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: MarkdownBody(
                data: solution,
                selectable: true,
                styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context))
                    .copyWith(
                      p: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 16,
                        height: 1.5,
                      ),
                      h1: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1e3a8a),
                      ),
                      h2: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1e3a8a),
                      ),
                      h3: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1e3a8a),
                      ),
                      code: GoogleFonts.robotoMono(
                        backgroundColor: const Color(0xFFdbeafe),
                        color: const Color(0xFF1e40af),
                        fontSize: 14,
                      ),
                      codeblockDecoration: BoxDecoration(
                        color: const Color(0xFF1e3a8a),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      blockquoteDecoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(
                            color: const Color(0xFF3b82f6),
                            width: 4,
                          ),
                        ),
                        color: const Color(0xFFf0f9ff),
                      ),
                      listBullet: Theme.of(context).textTheme.bodyMedium
                          ?.copyWith(color: const Color(0xFF3b82f6)),
                    ),
                builders: {'code': CodeElementBuilder()},
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Solve Another Problem'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
