import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:super_lista/blocs/lista_de_compra_item_form.dart';
import 'package:super_lista/blocs/my_app_bar.dart';
import 'package:super_lista/models/lista_de_compra.dart';
import 'package:super_lista/models/lista_de_compra_item.dart';
import 'package:super_lista/models/model_base.dart';

class ListaDeCompraItensScreen extends StatefulWidget {
  final ListaDeCompra listaDeCompra;
  const ListaDeCompraItensScreen({super.key, required this.listaDeCompra});

  @override
  State<ListaDeCompraItensScreen> createState() => _ListaDeCompraItensScreenState();
}

class _ListaDeCompraItensScreenState extends State<ListaDeCompraItensScreen> {

  void _showModalFormItem(ListaDeCompraItem item) {
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

  void _addItem() {
    setState(() {
      ListaDeCompraItem(listaDeCompraId: widget.listaDeCompra.id!, criadoEm: DateTime.now(), titulo: "#item").save();
    });
  }
  
  _onItemSubmit(String titulo, int quantidade, double valor, ListaDeCompraItem item) {
    setState(() {
      item.titulo = titulo;
      item.quantidade = quantidade;
      item.save();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(onBackButton: () => Navigator.of(context).pop()),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [_titulo(), _itens()],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addItem,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _titulo() {
    final String dataTitulo = widget.listaDeCompra.data?.day == DateTime.now().day ? 'Hoje' : DateFormat('dd MMMM', 'pt_br').format(widget.listaDeCompra.data!);

    return Text('$dataTitulo - ${widget.listaDeCompra.titulo ?? 'Sem Titulo'}');
  }

  Widget _itens() {
    final Stream<QuerySnapshot<ListaDeCompraItem>> itens = ListaDeCompraItem.all(widget.listaDeCompra.id!);

    return SizedBox(
      height: 700,
      width: double.infinity,
      child: StreamBuilder<QuerySnapshot<ListaDeCompraItem>>(
        stream: itens,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator()); // Enquanto aguarda
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}')); // Se ocorrer um erro
          }

          if (snapshot.data != null && snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Nenhum item cadastrado.')); // Se não houver dados
          }

          List<ListaDeCompraItem> itens = snapshot.data!.docs.map((doc) => doc.data()).toList(); // Obtendo a lista de compras

          return _itensListView(itens);
        },
      ),
    );
  }

  ListView _itensListView(List<ListaDeCompraItem> itens) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: itens.length,
      itemBuilder: (context, index) {
        ListaDeCompraItem item = itens[index];
        return Card(
          child: GestureDetector(
            onTap: () => _showModalFormItem(item),
            child: ListTile(
              title: Text(item.titulo ?? 'Item'),
              leading: FlutterLogo(size: 56.0),
              subtitle: Text(DateFormat('MMMM, y').format(item.concluidoEm != null ? item.concluidoEm! : item.criadoEm)),
              trailing: Icon(Icons.more_vert),
            ),
          ),
        );
      },
    );
  }
}
