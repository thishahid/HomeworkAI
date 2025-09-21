import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:homeworkai/screens/solution_screen.dart';
import 'package:homeworkai/services/gemini_service.dart';
import 'package:homeworkai/widgets/api_key_input.dart';
import 'package:homeworkai/widgets/image_uploader.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _apiKeyController = TextEditingController();
  final _storage = const FlutterSecureStorage();
  String? _imagePath;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadApiKey();
  }

  Future<void> _loadApiKey() async {
    final apiKey = await _storage.read(key: 'gemini_api_key');
    if (apiKey != null) {
      setState(() {
        _apiKeyController.text = apiKey;
      });
    }
  }

  Future<void> _saveApiKey() async {
    await _storage.write(key: 'gemini_api_key', value: _apiKeyController.text);
  }

  Future<void> _solveHomework() async {
    if (!_formKey.currentState!.validate()) return;
    if (_imagePath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an image'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    await _saveApiKey();

    setState(() {
      _isLoading = true;
    });

    try {
      final geminiService = GeminiService(apiKey: _apiKeyController.text);
      final solution = await geminiService.solveHomework(_imagePath!);

      if (!mounted) return;

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => SolutionScreen(solution: solution),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('By Shahid'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
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
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFdbeafe),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.school,
                        size: 48,
                        color: Color(0xFF3b82f6),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'AI Homework Solver',
                      style: Theme.of(
                        context,
                      ).textTheme.titleLarge?.copyWith(fontSize: 28),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Get step-by-step solutions for your homework. Just snap a photo and let our AI do the rest!',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Steps
              Row(
                children: [
                  Expanded(
                    child: _StepCard(
                      icon: Icons.camera_alt,
                      title: 'Snap a Photo',
                      description: 'Take a picture of your homework',
                      stepNumber: '1',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _StepCard(
                      icon: Icons.psychology,
                      title: 'AI Analysis',
                      description: 'Our AI analyzes all of your problem',
                      stepNumber: '2',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _StepCard(
                      icon: Icons.menu_book,
                      title: 'Learn & Understand',
                      description: 'Get detailed explanations',
                      stepNumber: '3',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // API Key Input
              ApiKeyInput(controller: _apiKeyController),

              const SizedBox(height: 24),

              // Image Uploader
              ImageUploader(
                onImageSelected: (String path) {
                  setState(() {
                    _imagePath = path;
                  });
                },
              ),

              const SizedBox(height: 32),

              // Solve Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _solveHomework,
                  child: _isLoading
                      ? const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            ),
                            SizedBox(width: 16),
                            Text('Analyzing...'),
                          ],
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.bolt),
                            SizedBox(width: 8),
                            Text('Solve My Homework'),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String stepNumber;

  const _StepCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.stepNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF3b82f6), Color(0xFF1d4ed8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 32),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
