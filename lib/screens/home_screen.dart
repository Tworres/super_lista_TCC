import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:super_lista/blocs/lista_de_compra_form.dart';
import 'package:super_lista/blocs/my_app_bar.dart';
import 'package:super_lista/models/lista_de_compra.dart';
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
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text('Listas'),
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
    return SizedBox(
      height: 100,
      child: ListView.builder(
        padding: const EdgeInsets.only(left: 20),
        scrollDirection: Axis.horizontal,
        itemCount: listas.length,
        itemBuilder: (context, index) {
          ListaDeCompra lista = listas[index];
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ListaDeCompraItensScreen(listaDeCompra: lista),
                ),
              );
            },
            child: SizedBox(
              width: 80,
              height: 80,
              child: Card(
                elevation: 4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (lista.data != null) Text(DateFormat('dd MMM', 'pt_br').format(lista.data!)),
                    if (lista.titulo != null) FittedBox(child: Text(lista.titulo!)),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
