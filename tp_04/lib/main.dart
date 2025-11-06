import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

void main() => runApp(const ShaderApp());

class ShaderApp extends StatelessWidget {
  const ShaderApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Shader Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const ShaderPage(),
    );
  }
}

class ShaderPage extends StatefulWidget {
  const ShaderPage({super.key});
  @override
  State<ShaderPage> createState() => _ShaderPageState();
}

class _ShaderPageState extends State<ShaderPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  ui.FragmentProgram? _program;
  ui.FragmentShader? _shader;

  // uniforms
  Size _size = Size.zero;
  double _time = 0.0;
  Offset _touch = const Offset(-1, -1); // -1 = pas de touch

  @override
  void initState() {
    super.initState();
    // _ctrl = AnimationController.unbounded(vsync: this);
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );
    _ctrl.addListener(() {
      setState(() {
        _time = _ctrl.lastElapsedDuration!.inMilliseconds.toDouble() / 1000.0;
        _updateShader();
      });
    });
    _loadShader();
  }

  Future<void> _loadShader() async {
    final program = await ui.FragmentProgram.fromAsset(
      'assets/shaders/waves.frag',
    );
    setState(() {
      _program = program;
    });
    _ctrl.repeat(); // lance l’animation
  }

  void _updateShader() {
    if (_program == null || _size == Size.zero) return;

    // Ordre des uniforms = locations (0,1,2) dans le .frag
    _shader = _program!.fragmentShader();
    _shader!
      ..setFloat(0, _size.width) // u_resolution.x
      ..setFloat(1, _size.height) // u_resolution.y
      ..setFloat(2, _time) // u_time
      ..setFloat(3, _touch.dx) // u_touch.x
      ..setFloat(4, _touch.dy); // u_touch.y
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanDown: (d) => setState(() {
        _touch = d.localPosition;
        _updateShader();
      }),
      onPanUpdate: (d) => setState(() {
        _touch = d.localPosition;
        _updateShader();
      }),
      onPanEnd: (_) => setState(() {
        _touch = const Offset(-1, -1);
        _updateShader();
      }),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final newSize = Size(constraints.maxWidth, constraints.maxHeight);
          if (newSize != _size) {
            _size = newSize;
            _updateShader();
          }
          return Scaffold(
            appBar: AppBar(
              title: const Text('TP — Introduction aux Shaders'),
              actions: [
                IconButton(
                  onPressed: () => setState(() {
                    // “reset” visuel : petit pic d’onde
                    _time = 0.0;
                    _updateShader();
                  }),
                  icon: const Icon(Icons.restart_alt),
                  tooltip: 'Reset',
                ),
              ],
            ),
            body: _shader == null
                ? const Center(child: CircularProgressIndicator())
                : CustomPaint(
                    painter: _ShaderPainter(_shader!),
                    size: Size.infinite,
                  ),
          );
        },
      ),
    );
  }
}

class _ShaderPainter extends CustomPainter {
  final ui.FragmentShader shader;
  _ShaderPainter(this.shader);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..shader = shader;
    canvas.drawRect(Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(_ShaderPainter oldDelegate) => true;
}
