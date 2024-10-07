import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:super_lista/modals/lista_de_compra_item.dart';

class ListaDeCompra {
  final int id;
  final DateTime? data;
  final String? titulo;

  ListaDeCompra({
    required this.id,
    this.data,
    this.titulo,
  });

  static final List<ListaDeCompra> _listaDeCompra = [
    ListaDeCompra(id: 1, titulo: 'lista 1', data: DateTime.now()),
    ListaDeCompra(id: 2, titulo: 'lista 2', data: DateTime.now()),
    ListaDeCompra(id: 3, titulo: 'lista 3', data: DateTime.now()),
  ];

  static todos() {
    return _listaDeCompra;
  }

  static inserir(ListaDeCompra lista) {
    ListaDeCompra._listaDeCompra.add(lista);
    var db = FirebaseFirestore.instance;
    db.collection('lista').doc('user1').set({"listas": _listaDeCompra});
  }

  List<ListaDeCompraItem> listaDeCompraItens() {
    return ListaDeCompraItem.todos().where((item) {
      return item.listaDeCompraId == id;
    }).toList();
  }
}
