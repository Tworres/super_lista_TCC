import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:super_lista/blocs/lista_de_compra_item_form.dart';
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
  _addItem() {
    setState(() {
      ListaDeCompraItem novoItem = ListaDeCompraItem(id: 1, listaDeCompraId: widget.listaDeCompra.id, criadoEm: DateTime.now());
      ListaDeCompraItem.inserir(novoItem);
    });
  }

  _showModalFormItem(ListaDeCompraItem item) {
    showModalBottomSheet(
        context: context,
        builder: (ctx) {
          return Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: ListaDeCompraItemForm(
                listaDeCompraItem: item,
                onSubmit: _onItemSubmit,
              ));
        });
  }

  _onItemSubmit(String titulo, int quantidade, double valor, ListaDeCompraItem item) {
    setState(() {
      item.titulo = titulo;
      item.quantidade = quantidade;
      item.valor = valor;
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
            SizedBox(
              height: 700,
              child: ListView(
                scrollDirection: Axis.vertical,
                children: [
                  for (ListaDeCompraItem item in _listaDeCompraItens) ...[
                    Card(
                      child: GestureDetector(
                        onTap: () => _showModalFormItem(item),
                        child: ListTile(
                          title: Text(item.titulo ?? 'Item'),
                          leading: FlutterLogo(size: 56.0),
                          subtitle: Text(DateFormat('MMMM, y').format(item.concluidoEm != null ? item.concluidoEm! : item.criadoEm)),
                          trailing: Icon(Icons.more_vert),
                        ),
                      ),
                    ),
                  ]
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addItem,
        child: const Icon(Icons.add),
      ),
    );
  }
}
