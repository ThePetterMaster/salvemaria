import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class Camera extends StatefulWidget {
  const Camera({Key? key}) : super(key: key);

  @override
  State<Camera> createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  List<CameraDescription> cameras = [];
  CameraController? controller;
  XFile? imagem;
  Size? size;

  @override
  void initState() {
    super.initState();
    _loadCameras();
  }

  _loadCameras() async {
    try {
      cameras = await availableCameras();
      _startCamera();
    } on CameraException catch (e) {}
  }

  _startCamera() {
    if (cameras.isEmpty) {
      debugPrint('Câmera não foi encontrada');
    } else {
      _previewCamera(cameras[1]);
    }
  }

  _previewCamera(CameraDescription camera) async {
    final CameraController cameraController = CameraController(
      camera,
      ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );
    controller = cameraController;

    try {
      await cameraController.initialize();
    } on CameraException catch (e) {
      debugPrint(e.description);
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: const Text('Tirar foto'),
        backgroundColor: Colors.pink[400]!,
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.zero,
        margin: EdgeInsets.zero,
        color: Colors.grey[900],
        child: arquivoWidget(),
      ),
      floatingActionButton: (imagem != null)
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey[200],
                  child: Center(
                    child: IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: Colors.pink[400]!,
                          size: 30,
                        ),
                        onPressed: () {
                          setState(() {
                            imagem = null;
                          });
                          arquivoWidget();
                        }),
                  ),
                ),
                SizedBox(width: 15),
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.pink[400]!,
                  child: Center(
                    child: IconButton(
                      icon: const Icon(Icons.check,
                          color: Colors.white, size: 30),
                      onPressed: () async => Navigator.pop(
                          context, [await imagem?.readAsBytes(), imagem?.path]),
                    ),
                  ),
                ),
              ],
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  arquivoWidget() {
    return SizedBox(
      // width: size!.width,
      // height: size!.height * .8,
      child: imagem == null
          ? _cameraPreviewWidget()
          : Image.file(
              File(imagem!.path),
              fit: BoxFit.cover,
            ),
    );
  }

  _cameraPreviewWidget() {
    final CameraController? cameraController = controller;

    if (cameraController == null || !cameraController.value.isInitialized) {
      return const Text('Widget para Câmera que não está disponível');
    } else {
      return Column(
        children: [
          Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: [
              CameraPreview(controller!),
            ],
          ),
          Spacer(),
          _botaoCapturaWidget(),
        ],
      );
    }
  }

  _botaoCapturaWidget() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: CircleAvatar(
        radius: 32,
        backgroundColor: Colors.grey[200],
        child: IconButton(
            icon: Icon(Icons.camera_alt, color: Colors.pink[400]!, size: 30),
            onPressed: tirarFoto),
      ),
    );
  }

  tirarFoto() async {
    final CameraController? cameraController = controller;

    if (cameraController != null && cameraController.value.isInitialized) {
      try {
        XFile file = await cameraController.takePicture();
        if (mounted) setState(() => imagem = file);
      } on CameraException catch (e) {
        debugPrint(e.description);
      }
    }
  }
}
