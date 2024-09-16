import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_scanner_overlay/qr_scanner_overlay.dart';
import 'package:flutter_app/pages/result_screen.dart';

const bgColor = Color(0xfffafafa);
const blue = Color(0xff0000ff); // Màu xanh dương cho overlay

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerState();
}

class _ScannerState extends State<ScannerPage> {
  bool isScanCompleted = false;

  void closeScreen() {
    setState(() {
      isScanCompleted = false; // Reset lại trạng thái khi màn hình đóng
    });
  }

  final controller = MobileScannerController(
    formats: const [BarcodeFormat.qrCode],
    detectionSpeed: DetectionSpeed.noDuplicates,
  );

  @override
  void initState() {
    controller.start();
    super.initState();
  }

  @override
  Future<void> dispose() async {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "QR Scanner",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
                child: Container(
              child: const Column(
                children: [
                  Text(
                    "Place the QR code in the area",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Scanning will be started automatically",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            )),
            Expanded(
                flex: 2,
                child: Stack(
                  children: [
                    MobileScanner(
                      controller: controller,
                      onDetect: (capture) {
                        if (!isScanCompleted) {
                          Future.delayed(const Duration(milliseconds: 500))
                              .then(
                            (value) {
                              final List<Barcode> barcodes = capture.barcodes;
                              for (final barcode in barcodes) {
                                String code = barcode.rawValue ?? '---';
                                isScanCompleted = true;
                                Navigator.of(context)
                                    .push(
                                      MaterialPageRoute(
                                        builder: (context) => ResultScreen(
                                          code:
                                              code, // Truyền code vào ResultScreen
                                          closeScreen: closeScreen,
                                          resultText: '',
                                        ),
                                      ),
                                    )
                                    .then((_) => controller.start());
                                break; // Ngừng lặp sau khi tìm thấy mã QR đầu tiên
                              }
                              controller
                                  .stop(); // Dừng máy quét sau khi phát hiện mã
                            },
                          );
                        }
                      },
                    ),
                    QRScannerOverlay(
                      overlayColor: const Color.fromARGB(0, 250, 250, 250),
                    ),
                  ],
                )),
            Expanded(
                child: Container(
              alignment: Alignment.center,
              child: const Text(
                "Developed by .......",
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 18,
                  letterSpacing: 1,
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }
}
