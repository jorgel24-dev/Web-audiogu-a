// lib/widgets/editor_toolbar.dart
//
// Toolbar estilo Word:
//   • Click en botón sin selección → activa el modo de escritura con ese estilo
//     (el botón queda resaltado), todo lo que escribas saldrá con ese formato.
//   • Click otra vez → desactiva el modo.
//   • Seleccionar texto + click → aplica/quita el formato solo a la selección.
//   • Al mover el cursor, los botones se actualizan según el estilo del carácter
//     donde está el cursor.

import 'package:flutter/material.dart';

// ── Tipos de formato ─────────────────────────────────────────────────────────
enum _Fmt { bold, italic, underline }

// ── Rango de texto con formato ───────────────────────────────────────────────
class _Span {
  int start;
  int end;
  final Set<_Fmt> fmts;

  _Span(this.start, this.end, Set<_Fmt> fmts) : fmts = Set.from(fmts);

  bool get isEmpty => start >= end;
}

// ════════════════════════════════════════════════════════════════════════════
// RichEditorController
// ════════════════════════════════════════════════════════════════════════════
class RichEditorController extends TextEditingController {
  final List<_Span> _spans = [];
  final Set<_Fmt> _activeFmts = {}; // estilos activos para lo que se escriba

  // Listeners adicionales para que el toolbar se reconstruya
  final List<VoidCallback> _fmtListeners = [];
  void addFmtListener(VoidCallback cb) => _fmtListeners.add(cb);
  void removeFmtListener(VoidCallback cb) => _fmtListeners.remove(cb);
  void _notifyFmt() {
    for (final cb in _fmtListeners) cb();
  }

  Set<_Fmt> get activeFmts => Set.unmodifiable(_activeFmts);

  // ── Toggle de un formato ─────────────────────────────────────────────────
  void toggleFmt(_Fmt fmt) {
    final sel = selection;
    final hasSelection = sel.isValid && !sel.isCollapsed;

    if (hasSelection) {
      _applyToRange(sel.start, sel.end, fmt);
    } else {
      if (_activeFmts.contains(fmt)) {
        _activeFmts.remove(fmt);
      } else {
        _activeFmts.add(fmt);
      }
      _notifyFmt();
    }
    notifyListeners();
  }

  // ── Interceptar escritura para inyectar formatos activos ─────────────────
  @override
  set value(TextEditingValue newValue) {
    final oldLen = value.text.length;
    final newLen = newValue.text.length;

    if (newLen > oldLen && _activeFmts.isNotEmpty) {
      final cursor = newValue.selection.baseOffset;
      final insertedLen = newLen - oldLen;
      final insertStart = cursor - insertedLen;

      _shiftSpans(insertStart, insertedLen);
      _spans.add(_Span(insertStart, cursor, _activeFmts));
      _mergeSpans();
    } else if (newLen < oldLen) {
      final cursor = newValue.selection.baseOffset;
      final deletedLen = oldLen - newLen;
      _deleteFromSpans(cursor, deletedLen);
    }

    super.value = newValue;
  }

  // ── Sincronizar botones al mover el cursor ───────────────────────────────
  void syncActiveFmtsFromCursor() {
    final pos = selection.baseOffset - 1;
    if (pos < 0) {
      _activeFmts.clear();
      _notifyFmt();
      return;
    }
    final newFmts = <_Fmt>{};
    for (final sp in _spans) {
      if (sp.start <= pos && sp.end > pos) newFmts.addAll(sp.fmts);
    }
    if (!_setEqual(_activeFmts, newFmts)) {
      _activeFmts..clear()..addAll(newFmts);
      _notifyFmt();
    }
  }

  // ── Aplicar/quitar formato en un rango ───────────────────────────────────
  void _applyToRange(int start, int end, _Fmt fmt) {
    final allHave = _rangeHasFmt(start, end, fmt);

    _splitAt(start);
    _splitAt(end);

    // Actualizar spans en el rango
    bool touched = false;
    for (final sp in _spans) {
      if (sp.start >= start && sp.end <= end) {
        if (allHave) sp.fmts.remove(fmt); else sp.fmts.add(fmt);
        touched = true;
      }
    }

    // Si no había spans en el rango, crear uno
    if (!touched && !allHave) {
      _spans.add(_Span(start, end, {fmt}));
    }

    _spans.removeWhere((s) => s.isEmpty || s.fmts.isEmpty);
    _mergeSpans();
    _notifyFmt();
  }

  bool _rangeHasFmt(int start, int end, _Fmt fmt) {
    for (var i = start; i < end; i++) {
      if (!_spans.any((s) => s.start <= i && s.end > i && s.fmts.contains(fmt))) {
        return false;
      }
    }
    return start < end;
  }

  void _splitAt(int pos) {
    final toAdd = <_Span>[];
    for (final sp in _spans) {
      if (sp.start < pos && sp.end > pos) {
        toAdd.add(_Span(pos, sp.end, sp.fmts));
        sp.end = pos;
      }
    }
    _spans.addAll(toAdd);
  }

  void _shiftSpans(int from, int amount) {
    for (final sp in _spans) {
      if (sp.start >= from) sp.start += amount;
      if (sp.end >= from) sp.end += amount;
    }
  }

  void _deleteFromSpans(int from, int amount) {
    final deleted = from + amount;
    _spans.removeWhere((s) => s.start >= from && s.end <= deleted);
    for (final sp in _spans) {
      if (sp.start >= deleted) {
        sp.start -= amount;
        sp.end -= amount;
      } else if (sp.end > from && sp.end <= deleted) {
        sp.end = from;
      } else if (sp.start >= from && sp.start < deleted) {
        sp.start = from;
      }
    }
    _spans.removeWhere((s) => s.isEmpty);
  }

  void _mergeSpans() {
    _spans.sort((a, b) => a.start.compareTo(b.start));
    for (var i = _spans.length - 1; i > 0; i--) {
      final a = _spans[i - 1];
      final b = _spans[i];
      if (a.end == b.start && _setEqual(a.fmts, b.fmts)) {
        a.end = b.end;
        _spans.removeAt(i);
      }
    }
  }

  static bool _setEqual(Set<_Fmt> a, Set<_Fmt> b) =>
      a.length == b.length && a.containsAll(b);

  // ── Construir el TextSpan visual ─────────────────────────────────────────
  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    final fullText = text;
    if (_spans.isEmpty) return TextSpan(text: fullText, style: style);

    _spans.sort((a, b) => a.start.compareTo(b.start));

    final children = <InlineSpan>[];
    var cursor = 0;

    for (final sp in _spans) {
      if (sp.start > cursor) {
        children.add(TextSpan(
          text: fullText.substring(cursor, sp.start),
          style: style,
        ));
      }
      if (sp.start < fullText.length) {
        final end = sp.end.clamp(0, fullText.length);
        children.add(TextSpan(
          text: fullText.substring(sp.start, end),
          style: _buildStyle(style, sp.fmts),
        ));
        cursor = end;
      }
    }

    if (cursor < fullText.length) {
      children.add(TextSpan(text: fullText.substring(cursor), style: style));
    }

    return TextSpan(children: children, style: style);
  }

  TextStyle _buildStyle(TextStyle? base, Set<_Fmt> fmts) {
    var s = base ?? const TextStyle();
    if (fmts.contains(_Fmt.bold)) s = s.copyWith(fontWeight: FontWeight.bold);
    if (fmts.contains(_Fmt.italic)) s = s.copyWith(fontStyle: FontStyle.italic);
    if (fmts.contains(_Fmt.underline)) {
      s = s.copyWith(decoration: TextDecoration.underline);
    }
    return s;
  }
}

// ════════════════════════════════════════════════════════════════════════════
// EditorToolbar — el widget que montas en noticias_screen
// ════════════════════════════════════════════════════════════════════════════
class EditorToolbar extends StatefulWidget {
  final RichEditorController controller;
  final TextAlign alineacionActual;
  final ValueChanged<TextAlign> onAlineacionChanged;

  const EditorToolbar({
    Key? key,
    required this.controller,
    required this.alineacionActual,
    required this.onAlineacionChanged,
  }) : super(key: key);

  @override
  State<EditorToolbar> createState() => _EditorToolbarState();
}

class _EditorToolbarState extends State<EditorToolbar> {
  @override
  void initState() {
    super.initState();
    widget.controller.addFmtListener(_rebuild);
  }

  @override
  void didUpdateWidget(EditorToolbar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeFmtListener(_rebuild);
      widget.controller.addFmtListener(_rebuild);
    }
  }

  @override
  void dispose() {
    widget.controller.removeFmtListener(_rebuild);
    super.dispose();
  }

  void _rebuild() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final fmts = widget.controller.activeFmts;
    final align = widget.alineacionActual;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Row(
        children: [
          _Btn(
            icon: Icons.format_bold,
            tooltip: 'Negrita',
            activo: fmts.contains(_Fmt.bold),
            onPressed: () => widget.controller.toggleFmt(_Fmt.bold),
          ),
          _Btn(
            icon: Icons.format_italic,
            tooltip: 'Cursiva',
            activo: fmts.contains(_Fmt.italic),
            onPressed: () => widget.controller.toggleFmt(_Fmt.italic),
          ),
          _Btn(
            icon: Icons.format_underline,
            tooltip: 'Subrayado',
            activo: fmts.contains(_Fmt.underline),
            onPressed: () => widget.controller.toggleFmt(_Fmt.underline),
          ),
          const _Sep(),
          _Btn(
            icon: Icons.format_align_left,
            tooltip: 'Izquierda',
            activo: align == TextAlign.left,
            onPressed: () => widget.onAlineacionChanged(TextAlign.left),
          ),
          _Btn(
            icon: Icons.format_align_center,
            tooltip: 'Centrar',
            activo: align == TextAlign.center,
            onPressed: () => widget.onAlineacionChanged(TextAlign.center),
          ),
          _Btn(
            icon: Icons.format_align_right,
            tooltip: 'Derecha',
            activo: align == TextAlign.right,
            onPressed: () => widget.onAlineacionChanged(TextAlign.right),
          ),
          _Btn(
            icon: Icons.format_align_justify,
            tooltip: 'Justificar',
            activo: align == TextAlign.justify,
            onPressed: () => widget.onAlineacionChanged(TextAlign.justify),
          ),
          const _Sep(),
          _Btn(
            icon: Icons.format_list_bulleted,
            tooltip: 'Lista con viñetas',
            onPressed: () => _insertPrefijo('• '),
          ),
          _Btn(
            icon: Icons.format_list_numbered,
            tooltip: 'Lista numerada',
            onPressed: () => _insertPrefijo('1. '),
          ),
        ],
      ),
    );
  }

  void _insertPrefijo(String prefijo) {
    final ctrl = widget.controller;
    final sel = ctrl.selection;
    if (!sel.isValid) return;
    final antes = ctrl.text.substring(0, sel.start);
    final despues = ctrl.text.substring(sel.end);
    final salto = (antes.isNotEmpty && !antes.endsWith('\n')) ? '\n' : '';
    final ins = '$salto$prefijo';
    ctrl.value = TextEditingValue(
      text: '$antes$ins$despues',
      selection: TextSelection.collapsed(offset: sel.start + ins.length),
    );
  }
}

// ── Botón del toolbar ────────────────────────────────────────────────────────
class _Btn extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;
  final bool activo;

  const _Btn({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.activo = false,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: activo
            ? const Color(0xFF2D6A4F).withValues(alpha: 0.12)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
        child: InkWell(
          borderRadius: BorderRadius.circular(6),
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Icon(
              icon,
              size: 18,
              color: activo ? const Color(0xFF2D6A4F) : Colors.grey[700],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Separador ────────────────────────────────────────────────────────────────
class _Sep extends StatelessWidget {
  const _Sep();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      width: 1,
      color: Colors.grey[300],
      margin: const EdgeInsets.symmetric(horizontal: 6),
    );
  }
}