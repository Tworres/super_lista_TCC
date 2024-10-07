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
  final List<ListaDeCompra> _listaDeCompras = ListaDeCompra.todos();

  _onListaDeCompraFormSubmit(String? titulo, DateTime? data) {
    setState(() {
      final newLista = ListaDeCompra(id: 4, data: data, titulo: titulo);
      ListaDeCompra.inserir(newLista);
    });
  }

  _showModalFormLista() {
    showModalBottomSheet(
        context: context,
        builder: (ctx) {
          return Padding(padding: EdgeInsets.symmetric(horizontal: 20), child: ListaDeCompraForm(onSubmit: _onListaDeCompraFormSubmit));
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
          SizedBox(
            height: 100,
            child: ListView(
              padding: const EdgeInsets.only(left: 20),
              scrollDirection: Axis.horizontal,
              children: [
                for (var lista in _listaDeCompras) ...[
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (_) => ListaDeCompraItensScreen(listaDeCompra: lista)));
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
                  )
                ]
              ],
            ),
          )
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
}
