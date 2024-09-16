import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:super_lista/components/my_app_bar.dart';
import 'package:super_lista/modals/lista_de_compra.dart';
import 'package:super_lista/pages/lista_mercado.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<ListaDeCompra> _listaDeCompras = [
    ListaDeCompra(id: 1, titulo: 'lista 1', data: DateTime.now()),
    ListaDeCompra(id: 2, titulo: 'lista 2', data: DateTime.now()),
    ListaDeCompra(id: 3, titulo: 'lista 3', data: DateTime.now()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Listas',
            ),
            Row(
              children: [
                for (var lista in _listaDeCompras) ...[
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (_) => ListaMercado(listaDeCompra: lista)));
                    },
                    child: SizedBox(
                      width: 100,
                      height: 100,
                      child: Card(
                        elevation: 4,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(DateFormat('MMM dd', 'pt_br').format(lista.data)),
                            Text(lista.titulo),
                          ],
                        ),
                      ),
                    ),
                  )
                ]
              ],
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
