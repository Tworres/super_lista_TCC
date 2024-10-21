import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:super_lista/models/model_base.dart';

class ListaDeCompraItem extends ModelBase {
  String? titulo;
  String? id;
  String listaDeCompraId;
  bool isConcluido;
  DateTime? concluidoEm;
  DateTime criadoEm;
  int quantidade;
  double? valor;

  ListaDeCompraItem({
    this.id,
    required this.listaDeCompraId,
    required this.criadoEm,
    this.titulo,
    this.isConcluido = false,
    this.concluidoEm,
    this.quantidade = 1,
    this.valor,
  });

    static CollectionReference<ListaDeCompraItem> get _collectionRef {
    return ModelBase.db.collection("itens").withConverter(
          fromFirestore: ListaDeCompraItem.fromFirestore,
          toFirestore: (ListaDeCompraItem listaDeCompra, _) => listaDeCompra.toFirestore(),
        );
  }

  factory ListaDeCompraItem.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final dados = snapshot.data();

    return ListaDeCompraItem(
      id: dados?['id'],
      listaDeCompraId: dados?['listaDeCompraId'],
      criadoEm: dados?['criadoEm'].toDate(),
      titulo: dados?['titulo'],
      isConcluido: dados?['isConcluido'],
      concluidoEm: dados?['concluidoEm']?.toDate(),
      quantidade: dados?['quantidade'],
      valor: dados?['valor'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "id": id,
      "listaDeCompraId": listaDeCompraId,
      "criadoEm": criadoEm,
      "titulo": titulo,
      "isConcluido": isConcluido,
      "concluidoEm": concluidoEm,
      "quantidade": quantidade,
      "valor": valor,
    };
  }

  Stream<DocumentSnapshot<ListaDeCompraItem>> find(String id) {
    Stream<DocumentSnapshot<ListaDeCompraItem>> stream = _collectionRef.doc(id).snapshots();

    return stream;
  }

  static Stream<QuerySnapshot<ListaDeCompraItem>> all(String listaDeCompraId) {
    // Obtendo o stream de snapshots da coleção filtrando pelo "userId"
    Stream<QuerySnapshot<ListaDeCompraItem>> stream = _collectionRef.where("listaDeCompraId", isEqualTo: listaDeCompraId).snapshots();
    
    //Retornando o stream para atualização em tempo real dos dados.
    return stream;
  }

  ListaDeCompraItem setConcluido(bool concluido){
    isConcluido = concluido;
    if(concluido){
      concluidoEm = DateTime.now();
    } else {
      concluidoEm = null;
    }

    return this;
  }

  /// Insere ou atualiza um dado no firebase
  ListaDeCompraItem save() {
    id ??= _collectionRef.doc().id;
    _collectionRef.doc(id).set(this);
    return this;
  }

  void delete() {
    _collectionRef.doc(id).delete();
  }
}
