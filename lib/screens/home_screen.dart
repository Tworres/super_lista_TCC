import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:super_lista/blocs/lista_de_compra_form.dart';
import 'package:super_lista/blocs/my_app_bar.dart';
import 'package:super_lista/config/colors.dart';
import 'package:super_lista/models/lista_de_compra.dart';
import 'package:super_lista/models/lista_de_compra_item.dart';
import 'package:super_lista/screens/lista_compra_itens_screen.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  _onListaDeCompraFormSubmit(String? titulo, DateTime? data) {
    setState(() {
      ListaDeCompra(data: data, titulo: titulo, userId: 'user1').save();
    });
  }

  _showModalFormLista() {
    showModalBottomSheet(
        context: context,
        builder: (ctx) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ListaDeCompraForm(onSubmit: _onListaDeCompraFormSubmit),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              'Listas',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          streamDeListas()
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showModalFormLista();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  /// Trata o stream de listas de compras
  StreamBuilder<QuerySnapshot<ListaDeCompra>> streamDeListas() {
    return StreamBuilder<QuerySnapshot<ListaDeCompra>>(
      stream: ListaDeCompra.all(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator()); // Enquanto aguarda
        }

        if (snapshot.hasError) {
          return Center(child: Text('Erro: ${snapshot.error}')); // Se ocorrer um erro
        }

        if (snapshot.data != null && snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('Nenhuma lista encontrada.')); // Se não houver dados
        }

        List<ListaDeCompra> listas = snapshot.data!.docs.map((doc) => doc.data()).toList(); // Obtendo a lista de compras

        return _listasBuilder(context, listas);
      },
    );
  }

  /// cria uma unica lista
  Widget _listasBuilder(BuildContext context, List<ListaDeCompra> listas) {
    int hoje = int.tryParse("${DateTime.now().year}${DateTime.now().month}${DateTime.now().day}")!;

    listas.sort((a, b) {
      int dataListaA = int.tryParse("${a.data!.year}${a.data!.month}${a.data!.day}")!;

      if (dataListaA == hoje) return -1;
      if (dataListaA > hoje) return 0;
      if (dataListaA < hoje) return 1;
      return 1;
    });

    return SizedBox(
      height: 100,
      child: ListView.builder(
        padding: const EdgeInsets.only(left: 20),
        scrollDirection: Axis.horizontal,
        itemCount: listas.length,
        itemBuilder: (context, index) {
          ListaDeCompra lista = listas[index];

          Color cardColor;

          int dataLista = int.tryParse("${lista.data!.year}${lista.data!.month}${lista.data!.day}")!;

          if (dataLista > hoje) {
            cardColor = SLcolors.defaultC;
          } else if (dataLista == hoje) {
            cardColor = SLcolors.primary;
          } else {
            cardColor = SLcolors.secondary;
          }

          String tituloLista = dataLista == hoje ? 'Hoje' : DateFormat('dd MMM', 'pt_br').format(lista.data!);

          var streamItens = lista.itens();

          return StreamBuilder(
              stream: streamItens,
              builder: (context, snapshot) {
                List<ListaDeCompraItem>? itens = snapshot.data?.docs.map((doc) => doc.data()).toList(); // Obtendo a lista de compras
                int? quantidadeItens = itens?.length;
                double? valorTotal = itens?.fold(0.0, (sum, item) => (sum ?? 0) + (item.valor ?? 0.0));

                Widget quantidadeItensW;
                if (quantidadeItens == null) {
                  quantidadeItensW = const CircularProgressIndicator();
                } else {
                  quantidadeItensW = FittedBox(child: Text("$quantidadeItens itens",style: const TextStyle(fontSize: 11),));
                }

                Widget valorTotalW;
                if (valorTotal == null) {
                  valorTotalW = const CircularProgressIndicator();
                } else {
                  valorTotalW = FittedBox(child: Text("R\$$valorTotal",style: const TextStyle(fontSize: 11),));
                }

                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ListaDeCompraItensScreen(listaDeCompra: lista),
                      ),
                    );
                  },
                  onLongPress: () {
                    showMenu(
                      context: context,
                      position: RelativeRect.fromLTRB(0, 100, 10, 0),
                      items: [
                        PopupMenuItem(
                          child: Text('Deletar'),
                          onTap: lista.delete,
                        ),
                      ],
                    );
                  },
                  child: SizedBox(
                    width: 90,
                    child: Card(
                      color: cardColor,
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(tituloLista, style: const TextStyle(fontWeight: FontWeight.w700)),
                            quantidadeItensW,
                            valorTotalW,
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              });
        },
      ),
    );
  }
}
