import 'package:barcode_widget/barcode_widget.dart';

class BarcodeOption {
  const BarcodeOption({
    required this.label,
    required this.barcode,
    this.showText = true,
  });

  final String label;
  final Barcode barcode;
  final bool showText;
}

final List<BarcodeOption> barcodeOptions = [
  BarcodeOption(label: 'QR Code', barcode: Barcode.qrCode(), showText: false),
  BarcodeOption(label: 'Aztec', barcode: Barcode.aztec(), showText: false),
  BarcodeOption(label: 'Data Matrix', barcode: Barcode.dataMatrix(), showText: false),
  BarcodeOption(label: 'PDF417', barcode: Barcode.pdf417(), showText: false),
  BarcodeOption(label: 'Code 128', barcode: Barcode.code128()),
  BarcodeOption(label: 'GS1-128', barcode: Barcode.gs128()),
  BarcodeOption(label: 'Code 39', barcode: Barcode.code39()),
  BarcodeOption(label: 'Code 93', barcode: Barcode.code93()),
  BarcodeOption(label: 'Codabar', barcode: Barcode.codabar()),
  BarcodeOption(label: 'Telepen', barcode: Barcode.telepen()),
  BarcodeOption(label: 'ITF (Interleaved 2 of 5)', barcode: Barcode.itf()),
  BarcodeOption(label: 'ITF-14', barcode: Barcode.itf14()),
  BarcodeOption(label: 'ITF-16', barcode: Barcode.itf16()),
  BarcodeOption(label: 'EAN-13', barcode: Barcode.ean13()),
  BarcodeOption(label: 'EAN-8', barcode: Barcode.ean8()),
  BarcodeOption(label: 'EAN-5 (Supplemental)', barcode: Barcode.ean5()),
  BarcodeOption(label: 'EAN-2 (Supplemental)', barcode: Barcode.ean2()),
  BarcodeOption(label: 'ISBN', barcode: Barcode.isbn()),
  BarcodeOption(label: 'UPC-A', barcode: Barcode.upcA()),
  BarcodeOption(label: 'UPC-E', barcode: Barcode.upcE()),
  BarcodeOption(label: 'RM4SCC', barcode: Barcode.rm4scc()),
  BarcodeOption(label: 'POSTNET', barcode: Barcode.postnet()),
];
