import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:super_lista/blocs/lista_de_compra_form.dart';
import 'package:super_lista/blocs/my_app_bar.dart';
import 'package:super_lista/utils/colors.dart';
import 'package:super_lista/models/lista_de_compra.dart';
import 'package:super_lista/models/lista_de_compra_item.dart';
import 'package:super_lista/screens/lista_compra_itens_screen.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  _onListaDeCompraFormSubmit(ListaDeCompra lc, String? titulo, DateTime? data) {
    setState(() {
      lc.data = data;
      lc.titulo = titulo;

      lc.save();
    });
  }

  _showModalFormLista([ListaDeCompra? listaDeCompra]) {
    showModalBottomSheet(
        context: context,
        builder: (ctx) {
          return Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: ListaDeCompraForm(onSubmit: _onListaDeCompraFormSubmit, listaDeCompra: listaDeCompra),
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
    int hoje = int.tryParse(DateFormat("y-M-d").format(DateTime.now()).replaceAll('-', ''))!;

    listas.sort((a, b) {
      int dataListaA = int.tryParse(DateFormat("y-M-d").format(a.data!).replaceAll('-', ''))!;
      int dataListaB = int.tryParse(DateFormat("y-M-d").format(b.data!).replaceAll('-', ''))!;

      if (dataListaA == hoje && dataListaB != hoje) return -1; // a é de hoje, b não
      if (dataListaB == hoje && dataListaA != hoje) return 1; // b é de hoje, a não
      if (dataListaA > hoje && dataListaB <= hoje) return -1; // a é do futuro, b é do passado ou hoje
      if (dataListaB > hoje && dataListaA <= hoje) return 1; // b é do futuro, a é do passado ou hoje

      return dataListaA > dataListaB ? -1 : 1; // Ordena pela data normalmente
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
            cardColor = ColorsSl.defaultC;
          } else if (dataLista == hoje) {
            cardColor = ColorsSl.primary;
          } else {
            cardColor = ColorsSl.secondary;
          }

          String tituloLista = dataLista == hoje ? 'Hoje' : DateFormat('dd MMM', 'pt_br').format(lista.data!);

          var streamItens = lista.itens();

          return StreamBuilder(
              stream: streamItens,
              builder: (context, snapshot) {
                List<ListaDeCompraItem>? itens = snapshot.data?.docs.map((doc) => doc.data()).toList(); // Obtendo a lista de compras
                int? quantidadeItens = itens?.length;
                double? valorTotal = itens?.fold(0.0, (acc, item) => (acc ?? 0) + (item.valorTotal ?? 0.0));

                Widget quantidadeItensW;
                if (quantidadeItens == null) {
                  quantidadeItensW = const CircularProgressIndicator();
                } else {
                  quantidadeItensW = FittedBox(
                      child: Text(
                    "$quantidadeItens itens",
                    style: const TextStyle(fontSize: 11),
                  ));
                }

                Widget valorTotalW;
                if (valorTotal == null) {
                  valorTotalW = const CircularProgressIndicator();
                } else {
                  valorTotalW = FittedBox(
                      child: Text(
                    "R\$$valorTotal",
                    style: const TextStyle(fontSize: 11),
                  ));
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
                      position: const RelativeRect.fromLTRB(0, 100, 10, 0),
                      items: [
                        PopupMenuItem(
                          child: const Text('Editar'),
                          onTap: () =>   _showModalFormLista(lista),
                        ),
                        PopupMenuItem(
                          onTap: lista.delete,
                          child: const Text('Deletar'),
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
