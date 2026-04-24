import 'package:audioguia_web/providers/noticias_provider.dart';
import 'package:audioguia_web/widgets/editor_noticias_widget.dart';
import 'package:audioguia_web/widgets/sidebar_noticias_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PantallaPrincipal extends StatefulWidget {
  const PantallaPrincipal({Key? key}) : super(key: key);

  @override
  State<PantallaPrincipal> createState() => _PantallaPrincipalState();
}

class _PantallaPrincipalState extends State<PantallaPrincipal> {
  @override
  void initState() {
    super.initState();
    // Cargar noticias al iniciar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NoticiasProvider>().cargarNoticias();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const SidebarNoticias(),
          Expanded(
            child: Container(
              color: Colors.grey.shade50,
              child: const EditorNoticias(),
            ),
          ),
        ],
      ),
    );
  }
}
