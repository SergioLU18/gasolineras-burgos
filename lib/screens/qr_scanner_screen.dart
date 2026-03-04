import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/gas_station.dart';
import '../providers/user_provider.dart';
import '../services/points_service.dart';
import '../theme/app_colors.dart';

/// Simulated QR scanner screen.
/// No camera dependency — pressing "Simular Escaneo" awards random points (50–200).
class QRScannerScreen extends StatefulWidget {
  /// Optional station context (when launched from [StationDetailScreen]).
  final GasStation? station;

  const QRScannerScreen({super.key, this.station});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _scanController;
  late final Animation<double> _scanAnimation;
  bool _isScanning = false;

  @override
  void initState() {
    super.initState();
    // Scanning line bounces up and down continuously
    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _scanAnimation = CurvedAnimation(
      parent: _scanController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _scanController.dispose();
    super.dispose();
  }

  // ── Core scan logic ────────────────────────────────────────────────────────

  Future<void> _simulateScan() async {
    if (_isScanning) return;
    setState(() => _isScanning = true);

    // Brief fake "processing" delay for realism
    await Future.delayed(const Duration(milliseconds: 900));

    if (!mounted) return;

    final points = PointsService.simulateQRScan();
    final multiplier = PointsService.currentMultiplier();
    final earned = (points * multiplier).round();

    context.read<UserProvider>().addPoints(earned);
    setState(() => _isScanning = false);

    _showSuccessDialog(earned, multiplier > 1.0);
  }

  void _showSuccessDialog(int points, bool doublePoints) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                color: AppColors.primaryGreen,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check,
                  color: Colors.white, size: 40),
            ),
            const SizedBox(height: 20),
            const Text(
              '¡Escaneo Exitoso!',
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '+$points puntos',
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryGreen,
              ),
            ),
            if (doublePoints) ...[
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.accentOrange
                      .withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  '🎉 ¡Puntos x2 de fin de semana!',
                  style: TextStyle(
                    color: AppColors.accentOrange,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 8),
            if (widget.station != null)
              Text(
                widget.station!.name,
                style: TextStyle(
                    color: Colors.grey[600], fontSize: 13),
              ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);     // close dialog
              Navigator.pop(context); // return to previous screen
            },
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
              minimumSize: const Size(140, 44),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('¡Genial!'),
          ),
        ],
      ),
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(
          widget.station != null
              ? widget.station!.name
              : 'Escanear QR',
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // ── Viewfinder area ──────────────────────────────────────────────
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Dark background
                Container(color: Colors.black),

                // Viewfinder with animated scan line
                AnimatedBuilder(
                  animation: _scanAnimation,
                  builder: (_, __) => CustomPaint(
                    size: Size.infinite,
                    painter: _ScannerPainter(
                      scanPosition: _scanAnimation.value,
                      isScanning: _isScanning,
                    ),
                  ),
                ),

                // Processing overlay
                if (_isScanning)
                  Container(
                    color: Colors.black.withValues(alpha: 0.5),
                    child: const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(
                              color: AppColors.primaryGreen),
                          SizedBox(height: 16),
                          Text(
                            'Procesando...',
                            style: TextStyle(
                                color: Colors.white, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // ── Bottom panel ─────────────────────────────────────────────────
          Container(
            color: Colors.black,
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 36),
            child: Column(
              children: [
                Text(
                  widget.station != null
                      ? 'Apunta al código QR de ${widget.station!.brand}'
                      : 'Apunta al código QR de la gasolinera',
                  style: const TextStyle(
                      color: Colors.white70, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: _isScanning ? null : _simulateScan,
                    icon: const Icon(Icons.qr_code_scanner),
                    label: const Text(
                      'Simular Escaneo',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primaryGreen,
                      disabledBackgroundColor:
                          AppColors.primaryGreen.withValues(alpha: 0.4),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Custom painter for the scanner overlay ───────────────────────────────────

class _ScannerPainter extends CustomPainter {
  final double scanPosition; // 0.0 → 1.0
  final bool isScanning;

  const _ScannerPainter({
    required this.scanPosition,
    required this.isScanning,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Viewfinder square: 70% of the narrower dimension, centered
    final side   = size.shortestSide * 0.70;
    final left   = (size.width  - side) / 2;
    final top    = (size.height - side) / 2;
    final scanRect = Rect.fromLTWH(left, top, side, side);

    // ── Dark overlay (4 rectangles around the viewfinder) ──────────────────
    final overlayPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.65);

    canvas
      ..drawRect(Rect.fromLTWH(0, 0, size.width, scanRect.top), overlayPaint)
      ..drawRect(
          Rect.fromLTWH(0, scanRect.top, scanRect.left, side), overlayPaint)
      ..drawRect(
          Rect.fromLTWH(scanRect.right, scanRect.top,
              size.width - scanRect.right, side),
          overlayPaint)
      ..drawRect(
          Rect.fromLTWH(0, scanRect.bottom, size.width,
              size.height - scanRect.bottom),
          overlayPaint);

    // ── Corner brackets ─────────────────────────────────────────────────────
    final bracketColor =
        isScanning ? Colors.white : AppColors.primaryGreen;
    final bracket = Paint()
      ..color = bracketColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round;

    const arm = 28.0;

    void corner(Offset a, Offset b, Offset c) {
      canvas
        ..drawLine(a, b, bracket)
        ..drawLine(a, c, bracket);
    }

    corner(
      scanRect.topLeft,
      scanRect.topLeft + const Offset(arm, 0),
      scanRect.topLeft + const Offset(0, arm),
    );
    corner(
      scanRect.topRight,
      scanRect.topRight + const Offset(-arm, 0),
      scanRect.topRight + const Offset(0, arm),
    );
    corner(
      scanRect.bottomLeft,
      scanRect.bottomLeft + const Offset(arm, 0),
      scanRect.bottomLeft + const Offset(0, -arm),
    );
    corner(
      scanRect.bottomRight,
      scanRect.bottomRight + const Offset(-arm, 0),
      scanRect.bottomRight + const Offset(0, -arm),
    );

    // ── Animated scan line ──────────────────────────────────────────────────
    if (!isScanning) {
      final lineY =
          scanRect.top + scanRect.height * scanPosition;

      // Glow gradient behind the line
      final glowPaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            AppColors.primaryGreen.withValues(alpha: 0.25),
            AppColors.primaryGreen.withValues(alpha: 0.25),
            Colors.transparent,
          ],
          stops: const [0, 0.3, 0.7, 1],
        ).createShader(
            Rect.fromLTWH(scanRect.left, lineY - 16, side, 32));

      canvas.drawRect(
        Rect.fromLTWH(scanRect.left, lineY - 16, side, 32),
        glowPaint,
      );

      final linePaint = Paint()
        ..color = AppColors.primaryGreen
        ..strokeWidth = 2;
      canvas.drawLine(
          Offset(scanRect.left, lineY),
          Offset(scanRect.right, lineY),
          linePaint);
    }
  }

  @override
  bool shouldRepaint(_ScannerPainter old) =>
      old.scanPosition != scanPosition || old.isScanning != isScanning;
}
