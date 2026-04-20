import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class EditorToolbar extends StatelessWidget {
  final QuillController controller;

  const EditorToolbar({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
      ),
      child: QuillSimpleToolbar(
        controller: controller,
        config: const QuillSimpleToolbarConfig(
          showBoldButton: true,
          showItalicButton: true,
          showUnderLineButton: true,
          showAlignmentButtons: true,
          showListBullets: true,
          showListNumbers: true,
          showDividers: true,
          showFontFamily: false,
          showFontSize: false,
          showSmallButton: false,
          showStrikeThrough: false,
          showInlineCode: false,
          showColorButton: false,
          showBackgroundColorButton: false,
          showClearFormat: false,
          showHeaderStyle: false,
          showListCheck: false,
          showCodeBlock: false,
          showQuote: false,
          showIndent: false,
          showLink: false,
          showUndo: false,
          showRedo: false,
          showDirection: false,
          showSearchButton: false,
          showSubscript: false,
          showSuperscript: false,
          showClipboardCut: false,
          showClipboardCopy: false,
          showClipboardPaste: false,
        ),
      ),
    );
  }
}
