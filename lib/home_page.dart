import 'package:flutter/material.dart';

import 'package:generatebarcode/preview_card.dart';
import 'package:generatebarcode/barcode_option.dart';
import 'package:generatebarcode/parse_locale_tag.dart';
import 'package:generatebarcode/setting_page.dart';
import 'package:generatebarcode/theme_color.dart';
import 'package:generatebarcode/ad_manager.dart';
import 'package:generatebarcode/theme_mode_number.dart';
import 'package:generatebarcode/ad_banner_widget.dart';
import 'package:generatebarcode/l10n/app_localizations.dart';
import 'package:generatebarcode/loading_screen.dart';
import 'package:generatebarcode/main.dart';
import 'package:generatebarcode/model.dart';

class MainHomePage extends StatefulWidget {
  const MainHomePage({super.key});
  @override
  State<MainHomePage> createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage> {
  late AdManager _adManager;
  late ThemeColor _themeColor;
  bool _isReady = false;
  bool _isFirst = true;
  //
  final TextEditingController _textController = TextEditingController();
  late BarcodeOption _selectedOption;

  void _dismissKeyboard() {
    FocusScope.of(context).unfocus();
  }

  @override
  void initState() {
    super.initState();
    _initState();
  }

  void _initState() async {
    _selectedOption = _loadDefaultOption();
    _adManager = AdManager();
    if (mounted) {
      setState(() {
        _isReady = true;
      });
    }
  }

  BarcodeOption _loadDefaultOption() {
    if (barcodeOptions.isEmpty) {
      throw StateError('No barcode options available.');
    }
    final int index = Model.barcodeOptionIndex.clamp(0, barcodeOptions.length - 1).toInt();
    return barcodeOptions[index];
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _onOpenSetting() async {
    final updated = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const SettingPage()),
    );
    if (!mounted) {
      return;
    }
    if (updated == true) {
      final mainState = context.findAncestorStateOfType<MainAppState>();
      if (mainState != null) {
        mainState
          ..themeMode = ThemeModeNumber.numberToThemeMode(Model.themeNumber)
          ..locale = parseLocaleTag(Model.languageCode)
          ..setState(() {});
      }
      _isFirst = true;
      _selectedOption = _loadDefaultOption();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_isReady == false) {
      return const LoadingScreen();
    }
    if (_isFirst) {
      _isFirst = false;
      _themeColor = ThemeColor(context: context);
    }
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: _themeColor.mainBackColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            color: _themeColor.mainForeColor,
            tooltip: l.setting,
            onPressed: _onOpenSetting,
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _dismissKeyboard,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _textController,
                  decoration: InputDecoration(
                    labelText: l.inputText,
                    border: const OutlineInputBorder(),
                  ),
                  textInputAction: TextInputAction.done,
                  maxLines: 2,
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<BarcodeOption>(
                  initialValue: _selectedOption,
                  decoration: InputDecoration(
                    labelText: l.barcodeType,
                    border: OutlineInputBorder(),
                  ),
                  isExpanded: true,
                  items: barcodeOptions
                      .map(
                        (option) => DropdownMenuItem(
                          value: option,
                          child: Text(option.label),
                        ),
                      )
                      .toList(),
                  onChanged: (option) {
                    if (option == null) return;
                    setState(() => _selectedOption = option);
                  },
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: PreviewCard(
                    data: _textController.text.trim(),
                    option: _selectedOption,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: AdBannerWidget(adManager: _adManager),
    );
  }
}

