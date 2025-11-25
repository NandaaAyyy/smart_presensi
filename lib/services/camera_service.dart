import 'package:camera/camera.dart';

class CameraService {
  static List<CameraDescription>? _cameras;
  CameraController? _controller;

  Future<void> initializeCamera() async {
    _cameras = await availableCameras();
    if (_cameras != null && _cameras!.isNotEmpty) {
      // Use front camera for face recognition
      final frontCamera = _cameras!.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => _cameras!.first,
      );

      _controller = CameraController(
        frontCamera,
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await _controller!.initialize();
    }
  }

  CameraController? get controller => _controller;

  Future<XFile?> takePicture() async {
    if (_controller != null && _controller!.value.isInitialized) {
      try {
        final image = await _controller!.takePicture();
        return image;
      } catch (e) {
        print('Error taking picture: $e');
        return null;
      }
    }
    return null;
  }

  void dispose() {
    _controller?.dispose();
  }
}