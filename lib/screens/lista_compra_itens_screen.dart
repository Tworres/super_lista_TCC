import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:super_lista/blocs/my_app_bar.dart';
import 'package:super_lista/modals/lista_de_compra.dart';
import 'package:super_lista/modals/lista_de_compra_item.dart';

class ListaDeCompraItensScreen extends StatefulWidget {
  final ListaDeCompra listaDeCompra;
  const ListaDeCompraItensScreen({super.key, required this.listaDeCompra});

  @override
  State<ListaDeCompraItensScreen> createState() => _ListaDeCompraItensScreenState();
}

class _ListaDeCompraItensScreenState extends State<ListaDeCompraItensScreen> {
  _showModalFormItem() {
    showModalBottomSheet(
        context: context,
        builder: (ctx) {
          return Text('data');
        });
  }

  @override
  Widget build(BuildContext context) {
    final List<ListaDeCompraItem> _listaDeCompraItens = widget.listaDeCompra.listaDeCompraItens();

    final String dataTitulo = widget.listaDeCompra.data?.day == DateTime.now().day ? 'Hoje' : DateFormat('dd MMMM', 'pt_br').format(widget.listaDeCompra.data!);

    return Scaffold(
      appBar: myAppBar(onBackButton: () {
        Navigator.of(context).pop();
      }),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${dataTitulo} - ${widget.listaDeCompra.titulo ?? 'Sem Titulo'}'),
            Column(
              children: [
                for (ListaDeCompraItem item in _listaDeCompraItens) ...[Text(item.titulo ?? '')]
              ],
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showModalFormItem,
        child: const Icon(Icons.add),
      ),
    );
  }
}
