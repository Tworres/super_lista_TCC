import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:super_lista/models/model_base.dart';

class ListaDeCompraItem extends ModelBase {
  String? titulo;
  String id;
  String listaDeCompraId;
  bool isConcluido;
  DateTime? concluidoEm;
  DateTime criadoEm;
  int quantidade;
  double? valor;

  ListaDeCompraItem({
    required this.id,
    required this.listaDeCompraId,
    required this.criadoEm,
    this.titulo,
    this.isConcluido = false,
    this.concluidoEm,
    this.quantidade = 1,
    this.valor,
  });

  static final List<ListaDeCompraItem> _listaDeCompraItens = [
    ListaDeCompraItem(
        id: ModelBase.uid,
        listaDeCompraId: "1",
        titulo: 'desodorante',
        valor: 17.9,
        criadoEm: DateTime.now()),
    ListaDeCompraItem(
        id: ModelBase.uid,
        listaDeCompraId: "1",
        titulo: 'desodorante',
        valor: 17.9,
        criadoEm: DateTime.now()),
    ListaDeCompraItem(
        id: ModelBase.uid,
        listaDeCompraId: "1",
        titulo: 'desodorante',
        valor: 17.9,
        criadoEm: DateTime.now()),
    ListaDeCompraItem(
        id: ModelBase.uid,
        listaDeCompraId: "1",
        titulo: 'desodorante',
        valor: 17.9,
        criadoEm: DateTime.now()),
  ];

  static List<ListaDeCompraItem> todos() {
    return ListaDeCompraItem._listaDeCompraItens;
  }

  static inserir(ListaDeCompraItem item) {
    // item.add();
    ListaDeCompraItem._listaDeCompraItens.add(item);
  }

  Map<String, Object?> toJson() {
    return {
      "id": this.id,
      "listaDeCompraId": this.listaDeCompraId,
      "criadoEm": this.criadoEm,
      "titulo": this.titulo,
      "data": Timestamp.fromDate(criadoEm),
      "valor": this.valor,
    };
  }
}
