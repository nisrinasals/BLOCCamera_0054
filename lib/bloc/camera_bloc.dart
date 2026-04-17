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

  Future<void> _onSwitchCamera(
    SwitchCamera event,
    Emitter<CameraState> emit,
  ) async {
    if (state is! CameraReady) return;
    final s = state as CameraReady;
    final next = (s.selectedIndex + 1) % _cameras.length;
    await _setupController(emit, next, previous: s);
  }

  Future<void> _onToggleFlash(
    ToggleFlash event,
    Emitter<CameraState> emit,
  ) async {
    if (state is! CameraReady) return;
    final s = state as CameraReady;
    final next = s.flashMode == FlashMode.off
        ? FlashMode.auto
        : s.flashMode == FlashMode.auto
        ? FlashMode.always
        : FlashMode.off;

    await s.controller.setFlashMode(next);
    emit(s.copyWith(flashMode: next));
  }

  Future<void> _onTakePicture(
    TakePicture event,
    Emitter<CameraState> emit,
  ) async {
    if (state is! CameraReady) return;
    final s = state as CameraReady;
    final file = await s.controller.takePicture();
    event.onPictureTaken(File(file.path));
  }

}
