import 'package:flutter/material.dart';
import 'package:super_lista/components/my_app_bar.dart';
import 'package:super_lista/modals/lista_de_compra.dart';

class ListaMercado extends StatefulWidget {
  final ListaDeCompra listaDeCompra;
  const ListaMercado({super.key, required this.listaDeCompra});

  @override
  State<ListaMercado> createState() => _ListaMercadoState();
}

class _ListaMercadoState extends State<ListaMercado> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(onBackButton: () {
        Navigator.of(context).pop();
      }),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Listas',
            ),
            Row(
              children: [],
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
