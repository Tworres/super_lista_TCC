import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:super_lista/models/lista_de_compra_item.dart';
import 'package:super_lista/models/model_base.dart';

class ListaDeCompra extends ModelBase {
  final String id;
  final DateTime? data;
  final String? titulo;
  final List<ListaDeCompraItem>? itens;

  ListaDeCompra({
    required this.id,
    this.data,
    this.titulo,
    this.itens,
  });

  static final List<ListaDeCompra> _listaDeCompra = [
    ListaDeCompra(id: "1", titulo: 'lista 1', data: DateTime.now()),
    ListaDeCompra(id: "2", titulo: 'lista 2', data: DateTime.now()),
    ListaDeCompra(id: "3", titulo: 'lista 3', data: DateTime.now()),
  ];

  Map<String, Object?> toJson() {
    return {
      "id": ModelBase.uid,
      "titulo": this.titulo,
      "data": data != null ? Timestamp.fromDate(data!) : null,
      "itens": listaDeCompraItens().map((e) => e.toJson()),
    };
  }

  String get doc => 'lista';

  static Future<List<ListaDeCompra>> todos() async {
    var snapshot = await ModelBase.db.collection('user1').doc('lista').get();

    if (snapshot.exists) {
      var data = snapshot.data();
      if (data != null && data['listas'] != null) {
        var listasData = List.from(data['listas']);
        return listasData.map((item) {
          List<ListaDeCompraItem> itens = (item['itens'] as List<dynamic>)
              .map((child) => ListaDeCompraItem(
                  id: child['id'],
                  listaDeCompraId: item['id'],
                  criadoEm: child['criadoEm'].toDate(),
                  titulo: child['titulo'],
                  valor: child['valor']))
              .toList();

          ListaDeCompra lc = ListaDeCompra(
            id: item['id'],
            titulo: item['titulo'],
            data: (item['data'] as Timestamp)
                .toDate(), // Aqui você pode carregar os itens se necessário
            itens: itens,
          );

          return lc;
        }).toList();
      }
    }
    return []; // Retorna uma lista vazia se não encontrar dados
  }

  static inserir(ListaDeCompra lista) {
    ListaDeCompra._listaDeCompra.add(lista);

    updateDb();
  }

  static updateDb() {
    try {
      ModelBase.db.collection('user1').doc('lista').set({
        'listas': _listaDeCompra.map(
          (e) => e.toJson(),
        )
      });
    } on FirebaseException catch (e) {
      print("Failed with error '${e.code}': ${e.message}");
    }
  }

  List<ListaDeCompraItem> listaDeCompraItens() {
    return ListaDeCompraItem.todos().where((item) {
      return item.listaDeCompraId == id;
    }).toList();
  }
}
