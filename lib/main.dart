import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kamera/bloc/camera_bloc.dart';
import 'package:kamera/bloc/camera_event.dart';
import 'package:kamera/pages/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext content) {
    return BlocProvider(
      create: (context) => CameraBloc()..add(InitializerCamera()),
      child: MaterialApp(
        theme: ThemeData(useMaterial3: true),
        home: const HomePage(),
      ),
    );
  }
}
