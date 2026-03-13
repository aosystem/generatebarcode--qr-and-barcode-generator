import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:share_plus/share_plus.dart';

import 'package:generatebarcode/barcode_option.dart';
import 'package:generatebarcode/theme_color.dart';
import 'package:generatebarcode/l10n/app_localizations.dart';

class PreviewCard extends StatefulWidget {
  const PreviewCard({super.key, required this.data, required this.option});

  final String data;
  final BarcodeOption option;

  @override
  State<PreviewCard> createState() => _PreviewCardState();
}

class _PreviewCardState extends State<PreviewCard> {
  final GlobalKey _barcodeBoundaryKey = GlobalKey();
  bool _isSharing = false;
  late ThemeColor _themeColor;
  late AppLocalizations _l;

  Future<void> _shareBarcodeImage() async {
    if (widget.data.isEmpty || _isSharing) {
      return;
    }
    final boundary =
    _barcodeBoundaryKey.currentContext?.findRenderObject()
    as RenderRepaintBoundary?;
    if (boundary == null) {
      _showSnackBar(_l.barcodePreviewIsNotReadyYet);
      return;
    }
    try {
      setState(() => _isSharing = true);
      final double pixelRatio = MediaQuery.of(
        context,
      ).devicePixelRatio.clamp(2.0, 4.0).toDouble();
      final ui.Image image = await boundary.toImage(pixelRatio: pixelRatio);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) {
        throw StateError('Failed to encode barcode image');
      }
      final Uint8List pngBytes = byteData.buffer.asUint8List();
      final xFile = XFile.fromData(
        pngBytes,
        mimeType: 'image/png',
        name: 'barcode.png',
      );
      await SharePlus.instance.share(
        ShareParams(files: [xFile], text: widget.data),
      );
    } catch (error, stackTrace) {
      _showSnackBar(_l.failedToShareTheBarcodeImage);
    } finally {
      if (mounted) {
        setState(() => _isSharing = false);
      }
    }
  }

  void _showSnackBar(String message) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    _themeColor = ThemeColor(context: context);
    _l = AppLocalizations.of(context)!;
    late Widget content;
    if (widget.data.isEmpty) {
      content = Center(
        child: Text(
          _l.previewMessage(widget.option.label.toLowerCase()),
          textAlign: TextAlign.center,
          style: t.titleMedium?.copyWith(color: _themeColor.mainButtonBackColor),
        ),
      );
    } else {
      content = Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            widget.option.label,
            style: t.titleLarge?.copyWith(color: _themeColor.mainButtonBackColor),
          ),
          const SizedBox(height: 32),
          Expanded(
            child: RepaintBoundary(
              key: _barcodeBoundaryKey,
              child: BarcodeWidget(
                data: widget.data,
                barcode: widget.option.barcode,
                drawText: widget.option.showText,
                width: double.infinity,
                color: Colors.black,
                style: TextStyle(color: Colors.black),
                errorBuilder: (context, error) {
                  return Center(
                    child: Text(
                      _l.invalidDataMessage(widget.option.label,error),
                      textAlign: TextAlign.center,
                      style: t.bodyLarge?.copyWith(color: Colors.red[900]),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            widget.data,
            textAlign: TextAlign.center,
            style: t.bodyMedium?.copyWith(color: _themeColor.mainButtonBackColor),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton.icon(
              onPressed: _isSharing ? null : _shareBarcodeImage,
              icon: _isSharing
                ? const SizedBox(height: 18, width: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
                : const Icon(Icons.ios_share_rounded),
              label: Text(MaterialLocalizations.of(context).shareButtonLabel),
              style: FilledButton.styleFrom(
                backgroundColor: _themeColor.mainButtonBackColor,
                foregroundColor: _themeColor.mainButtonForeColor,
              ),
            ),
          ),
        ],
      );
    }

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Card(
        color: Colors.white,
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
          child: content,
        ),
      ),
    );
  }
}
