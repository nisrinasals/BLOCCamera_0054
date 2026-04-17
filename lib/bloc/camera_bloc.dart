import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kamera/bloc/camera_event.dart';
import 'package:kamera/bloc/camera_state.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraBloc extends Bloc<CameraEvent, CameraState> {
  late List<CameraDescription> _cameras;

  CameraBloc() : super(CameraInitial()) {
    on<InitializerCamera>(_onInitialize);
    on<SwitchCamera>(_onSwitchCamera);
    on<ToggleFlash>(_onToggleFlash);
    on<TakePicture>(_onTakePicture);
    on<TapToFocus>(_onTapToFocus);
    on<PickImageFromGallery>(_onPickImage);
    on<OpenCameraAndCapture>(_onOpenCamera);
    on<DeleteImage>(_onDeleteImage);
    on<ClearSnackbar>(_onClearSnackbar);
    on<RequestPermission>(_onRequestPermission);
  }

  Future<void> _onInitialize(
    InitializerCamera event,
    Emitter<CameraState> emit,
  ) async {
    _cameras = await availableCameras();
    await _setupController(emit, 0);
  }

}
