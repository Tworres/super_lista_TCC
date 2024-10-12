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
      concluidoEm: dados?['concluidoEm'],
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

    stream.listen(
      (DocumentSnapshot<ListaDeCompraItem> event) {
        print("current data: ${event.data()}"); // Acessando os dados do documento
      },
      onError: (error) => print("Listen failed: $error"),
    );

    return stream;
  }

  static Stream<QuerySnapshot<ListaDeCompraItem>> all(String listaDeCompraId) {
    // Obtendo o stream de snapshots da coleção filtrando pelo "userId"
    Stream<QuerySnapshot<ListaDeCompraItem>> stream = _collectionRef.where("listaDeCompraId", isEqualTo: listaDeCompraId).snapshots();

    // Ouvindo os eventos emitidos pelo stream
    stream.listen(
      (QuerySnapshot<ListaDeCompraItem> event) {
        for (var doc in event.docs) {
          print("current data: ${doc.data()}"); // Acessando os dados do documento
        }
      },
      onError: (error) => print("Listen failed: $error"),
    );

    //Retornando o stream para atualização em tempo real dos dados.
    return stream;
  }

  /// Insere ou atualiza um dado no firebase
  ListaDeCompraItem save() {
    id ??= _collectionRef.doc().id;
    _collectionRef.doc(id).set(this);
    return this;
  }
}
