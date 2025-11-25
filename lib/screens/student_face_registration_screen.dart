import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../services/camera_service.dart';

class StudentFaceRegistrationScreen extends StatefulWidget {
  const StudentFaceRegistrationScreen({super.key});

  @override
  State<StudentFaceRegistrationScreen> createState() => _StudentFaceRegistrationScreenState();
}

class _StudentFaceRegistrationScreenState extends State<StudentFaceRegistrationScreen> {
  final CameraService _cameraService = CameraService();
  int _currentStep = 0;
  final int _totalSteps = 5;
  bool _isCapturing = false;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      await _cameraService.initializeCamera();
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Camera initialization failed: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _cameraService.dispose();
    super.dispose();
  }

  void _captureFace() async {
    if (_currentStep >= _totalSteps || !_isInitialized) return;

    setState(() {
      _isCapturing = true;
    });

    try {
      final image = await _cameraService.takePicture();

      if (image != null) {
        // TODO: Send image to AI service for face encoding
        // For now, simulate processing
        await Future.delayed(const Duration(seconds: 1));

        if (mounted) {
          setState(() {
            _isCapturing = false;
            _currentStep++;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _isCapturing = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to capture image')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isCapturing = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Capture failed: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Face Registration'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Face Registration Process',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'Please follow these steps to register your face for attendance recognition:',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(16),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: _isInitialized && _cameraService.controller != null
                    ? CameraPreview(_cameraService.controller!)
                    : const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 20),
            LinearProgressIndicator(
              value: _currentStep / _totalSteps,
            ),
            const SizedBox(height: 10),
            Text('Step ${_currentStep + 1} of $_totalSteps'),
            const SizedBox(height: 20),
            const Text(
              'Position your face in the center of the camera and ensure good lighting.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: (_isCapturing || _currentStep >= _totalSteps || !_isInitialized) ? null : _captureFace,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: (_isCapturing || _currentStep >= _totalSteps || !_isInitialized)
                      ? Colors.grey
                      : const Color(0xFF1976D2),
                ),
                child: _isCapturing
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        _currentStep >= _totalSteps
                            ? 'Registration Complete'
                            : _isInitialized
                                ? 'Capture Face Sample'
                                : 'Initializing Camera...',
                      ),
              ),
            ),
            if (_currentStep >= _totalSteps)
              const Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text(
                  'Face registration completed successfully!',
                  style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}