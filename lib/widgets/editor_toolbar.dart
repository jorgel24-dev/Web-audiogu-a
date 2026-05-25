import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

class EditorToolbar extends StatelessWidget {
  final quill.QuillController controller;
  final bool isDarkMode;

  const EditorToolbar({
    super.key,
    required this.controller,
    this.isDarkMode = false,
  });

  @override
  Widget build(BuildContext context) {
    final bg = isDarkMode ? const Color(0xFF1A2332) : Colors.grey[50]!;
    final border = isDarkMode ? Colors.white12 : const Color(0xFFE0E0E0);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        border: Border(bottom: BorderSide(color: border)),
      ),
      child: quill.QuillSimpleToolbar(
        controller: controller,
        config: quill.QuillSimpleToolbarConfig(
          showBoldButton: true,
          showItalicButton: true,
          showUnderLineButton: true,
          showStrikeThrough: false,
          showListBullets: true,
          showListNumbers: true,
          showAlignmentButtons: true,
          showHeaderStyle: true,
          showColorButton: false,
          showBackgroundColorButton: false,
          showClearFormat: true,
          showDividers: true,
          showFontFamily: false,
          showFontSize: false,
          showCodeBlock: false,
          showInlineCode: false,
          showLink: false,
          showSearchButton: false,
          showSubscript: false,
          showSuperscript: false,
          showClipboardCopy: false,
          showClipboardCut: false,
          showClipboardPaste: false,
          showUndo: true,
          showRedo: true,
          buttonOptions: quill.QuillSimpleToolbarButtonOptions(
            base: quill.QuillToolbarBaseButtonOptions(
              iconTheme: quill.QuillIconTheme(
                iconButtonSelectedData: quill.IconButtonData(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                      const Color(0xFF2D6A4F).withValues(alpha: 0.15),
                    ),
                  ),
                ),
                iconButtonUnselectedData: quill.IconButtonData(
                  style: ButtonStyle(
                    foregroundColor: WidgetStatePropertyAll(
                      isDarkMode ? Colors.grey[400] : Colors.grey[700],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
