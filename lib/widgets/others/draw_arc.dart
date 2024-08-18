import 'package:flutter/material.dart';

/// Un [CustomPainter] que dibuja un arco en el lienzo.
///
/// El arco se dibuja usando el color, el ancho del trazo, y los ángulos de inicio y barrido proporcionados.
class Arc extends CustomPainter {
  final Color _color;
  final double _strokeWidth;
  final double _sweepAngle;
  final double _startAngle;

  /// Crea una instancia privada de [Arc] con los parámetros especificados.
  Arc._(
    this._color,
    this._strokeWidth,
    this._startAngle,
    this._sweepAngle,
  );

  /// Crea un widget [SizedBox] con un [CustomPaint] que utiliza [Arc] para dibujar un arco.
  ///
  /// El arco se dibuja con el color, el tamaño, el ancho del trazo, el ángulo de inicio y el ángulo de barrido proporcionados.
  static Widget draw({
    required Color color,
    required double size,
    required double strokeWidth,
    required double startAngle,
    required double endAngle,
  }) =>
      SizedBox(
        width: size,
        height: size,
        child: CustomPaint(
          painter: Arc._(
            color,
            strokeWidth,
            startAngle,
            endAngle,
          ),
        ),
      );

  @override
  void paint(Canvas canvas, Size size) {
    // Define un rectángulo que representa el área en la que se dibuja el arco.
    final Rect rect = Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: size.height / 2,
    );

    // Configura el estilo de pintura para el arco.
    const bool useCenter = false;
    final Paint paint = Paint()
      ..color = _color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = _strokeWidth;

    // Dibuja el arco en el lienzo.
    canvas.drawArc(rect, _startAngle, _sweepAngle, useCenter, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
