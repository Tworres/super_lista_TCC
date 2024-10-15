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
      item.valor = valor;
      item.save();
    });
  }

  double valorPorcentagem = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(onBackButton: () => Navigator.of(context).pop()),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _titulo(),
            _itens(),
          ],
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

    return StreamBuilder<QuerySnapshot<ListaDeCompraItem>>(
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

        itens.sort((itemA, itemB) => itemA.isConcluido ? 1 : -1);

        double montanteConcluido = itens.where((ListaDeCompraItem item) => item.isConcluido).toList().fold(0.0, (sum, item) => sum + (item.valor ?? 0.0));
        double montanteTotal = itens.fold(0.0, (sum, item) => sum + (item.valor ?? 0.0));

        valorPorcentagem = montanteTotal != 0 ? montanteConcluido / montanteTotal : 0.0;

        return _itensListView(itens);
      },
    );
  }

  Widget _itensListView(List<ListaDeCompraItem> itens) {
    return Column(
      children: [
        LinearProgressIndicator(
          backgroundColor: Colors.red,
          value: valorPorcentagem,
          valueColor: AlwaysStoppedAnimation(const Color.fromARGB(255, 70, 211, 82)),
        ),
        SizedBox(
          height: 700,
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: itens.length,
            itemBuilder: (context, index) {
              ListaDeCompraItem item = itens[index];
              return Card(
                child: GestureDetector(
                  onTap: () => _showModalFormItem(item),
                  child: ClipRRect(
                    clipBehavior: Clip.hardEdge,
                    borderRadius: BorderRadius.circular(14.0),
                    child: Dismissible(
                      key: Key(ModelBase.uid), // Key aleatória, como é um stream não tem necessidade
                      background: Container(color: Colors.green),
                      secondaryBackground: Container(color: Colors.red),
                      onDismissed: (direction) {
                        // Deletar
                        if (DismissDirection.endToStart == direction) {
                          item.delete();
                        }
                        // Checar
                        if (DismissDirection.startToEnd == direction) {
                          item.concluidoEm = DateTime.now();
                          item.isConcluido = true;
                          item.save();
                        }
                      },
                      child: ListTile(
                        title: Text('${item.titulo ?? 'item'} ${item.isConcluido ? '(concluído)' : ''} ${item.quantidade > 1 ? "x${item.quantidade}" : ''}'),
                        leading: CircleAvatar(
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: FittedBox(child: Text("${item.valor ?? "0"}")),
                          ),
                        ),
                        subtitle: Text(DateFormat('MMMM, y').format(item.concluidoEm != null ? item.concluidoEm! : item.criadoEm)),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
