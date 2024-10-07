import 'package:super_lista/models/lista_de_compra_item.dart';

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
    return ListaDeCompra._listaDeCompra.add(lista);
  }

  List<ListaDeCompraItem> listaDeCompraItens() {
    return ListaDeCompraItem.todos().where((item) {
      return item.listaDeCompraId == id;
    }).toList();
  }
}
