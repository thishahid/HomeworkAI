import 'package:flutter/material.dart';

class ApiKeyInput extends StatelessWidget {
  final TextEditingController controller;

  const ApiKeyInput({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: const Color(0xFFdbeafe),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text(
                  '1',
                  style: TextStyle(
                    color: Color(0xFF3b82f6),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Enter Your Google AI API Key',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: controller,
          obscureText: true,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your API key';
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: '••••••••••••••••••••••••••••••••••',
            hintStyle: TextStyle(
              color: Colors.grey.shade400,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Your key is stored securely on your device.',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey.shade600,
              ),
        ),
        const SizedBox(height: 4),
        Text.rich(
          TextSpan(
            text: "Don't have a key? ",
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade600,
                ),
            children: [
              WidgetSpan(
                child: GestureDetector(
                  onTap: () {
                    // it would launch the URL "https://aistudio.google.com/apikey"
                    // but since we cannot use url_launcher package, we leave it empty
                  },
                  child: Text(
                    'Get one from Google AI Studio',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: const Color(0xFF3b82f6),
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
