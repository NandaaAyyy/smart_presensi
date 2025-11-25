import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../services/camera_service.dart';

class StudentAttendanceScreen extends StatefulWidget {
  const StudentAttendanceScreen({super.key});

  @override
  State<StudentAttendanceScreen> createState() => _StudentAttendanceScreenState();
}

class _StudentAttendanceScreenState extends State<StudentAttendanceScreen> with TickerProviderStateMixin {
  final CameraService _cameraService = CameraService();
  bool _isScanning = false;
  bool _isInitialized = false;
  String _status = 'Initializing camera...';
  late AnimationController _scanController;
  late Animation<double> _scanAnimation;
  late AnimationController _successController;
  late Animation<double> _successAnimation;

  @override
  void initState() {
    super.initState();
    _initializeCamera();

    _scanController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _scanAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _scanController,
      curve: Curves.easeInOut,
    ));

    _successController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _successAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _successController,
      curve: Curves.elasticOut,
    ));
  }

  Future<void> _initializeCamera() async {
    try {
      await _cameraService.initializeCamera();
      if (mounted) {
        setState(() {
          _isInitialized = true;
          _status = 'Ready to scan';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _status = 'Camera initialization failed';
        });
      }
    }
  }

  @override
  void dispose() {
    _scanController.dispose();
    _successController.dispose();
    _cameraService.dispose();
    super.dispose();
  }

  void _startScan() async {
    if (!_isInitialized) return;

    setState(() {
      _isScanning = true;
      _status = 'Scanning face...';
    });

    _scanController.forward();

    try {
      // Take picture
      final image = await _cameraService.takePicture();

      if (image != null) {
        // TODO: Send image to AI service for face recognition
        // For now, simulate processing
        await Future.delayed(const Duration(seconds: 2));

        _scanController.stop();
        if (mounted) {
          setState(() {
            _isScanning = false;
            _status = 'Attendance marked successfully!';
          });
          _successController.forward();
        }
      } else {
        _scanController.stop();
        if (mounted) {
          setState(() {
            _isScanning = false;
            _status = 'Failed to capture image';
          });
        }
      }
    } catch (e) {
      _scanController.stop();
      if (mounted) {
        setState(() {
          _isScanning = false;
          _status = 'Scanning failed: ${e.toString()}';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Take Attendance'),
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1976D2),
              Color(0xFF42A5F5),
            ],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Camera preview
                      if (_isInitialized && _cameraService.controller != null)
                        CameraPreview(_cameraService.controller!)
                      else
                        Container(
                          decoration: BoxDecoration(
                            gradient: RadialGradient(
                              colors: [
                                Colors.grey[900]!,
                                Colors.black,
                              ],
                            ),
                          ),
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                        ),

                      // Enhanced face detection overlay
                      if (_isScanning)
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            // Outer glow ring
                            AnimatedBuilder(
                              animation: _scanAnimation,
                              builder: (context, child) {
                                return Container(
                                  width: 220 * _scanAnimation.value,
                                  height: 220 * _scanAnimation.value,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.green.withOpacity(0.3),
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                );
                              },
                            ),
                            // Main detection frame
                            AnimatedBuilder(
                              animation: _scanAnimation,
                              builder: (context, child) {
                                return Container(
                                  width: 200 * _scanAnimation.value,
                                  height: 200 * _scanAnimation.value,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.green.withOpacity(0.9),
                                      width: 4,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.green.withOpacity(0.3),
                                        blurRadius: 20,
                                        spreadRadius: 5,
                                      ),
                                    ],
                                  ),
                                  child: Container(
                                    margin: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.8),
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                );
                              },
                            ),
                            // Corner indicators
                            ..._buildCornerIndicators(),
                            // Scanning line
                            Positioned(
                              top: 20,
                              left: 20,
                              right: 20,
                              child: AnimatedBuilder(
                                animation: _scanAnimation,
                                builder: (context, child) {
                                  return Container(
                                    height: 3,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.transparent,
                                          Colors.green.withOpacity(0.8),
                                          Colors.transparent,
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),

                      // Status overlay
                      Positioned(
                        top: 20,
                        left: 20,
                        right: 20,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _status,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),

                      // Instructions
                      if (!_isScanning && _isInitialized)
                        Positioned(
                          bottom: 20,
                          left: 20,
                          right: 20,
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'Position your face in the center and ensure good lighting',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),

                      // Success animation
                      if (!_isScanning && _status.contains('successfully'))
                        ScaleTransition(
                          scale: _successAnimation,
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.9),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check,
                              size: 60,
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: (_isScanning || !_isInitialized) ? null : _startScan,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: (_isScanning || !_isInitialized) ? Colors.grey : const Color(0xFF1976D2),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isScanning
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white.withOpacity(0.8),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Text('Scanning...'),
                              ],
                            )
                          : Text(
                              _isInitialized ? 'Scan Face for Attendance' : 'Initializing Camera...',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.grey[600],
                    ),
                    child: const Text('Back to Home'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildCornerIndicators() {
    return [
      // Top-left corner
      Positioned(
        top: 10,
        left: 10,
        child: Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(color: Colors.green.withOpacity(0.9), width: 4),
              top: BorderSide(color: Colors.green.withOpacity(0.9), width: 4),
            ),
          ),
        ),
      ),
      // Top-right corner
      Positioned(
        top: 10,
        right: 10,
        child: Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(color: Colors.green.withOpacity(0.9), width: 4),
              top: BorderSide(color: Colors.green.withOpacity(0.9), width: 4),
            ),
          ),
        ),
      ),
      // Bottom-left corner
      Positioned(
        bottom: 10,
        left: 10,
        child: Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(color: Colors.green.withOpacity(0.9), width: 4),
              bottom: BorderSide(color: Colors.green.withOpacity(0.9), width: 4),
            ),
          ),
        ),
      ),
      // Bottom-right corner
      Positioned(
        bottom: 10,
        right: 10,
        child: Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(color: Colors.green.withOpacity(0.9), width: 4),
              bottom: BorderSide(color: Colors.green.withOpacity(0.9), width: 4),
            ),
          ),
        ),
      ),
    ];
  }
}