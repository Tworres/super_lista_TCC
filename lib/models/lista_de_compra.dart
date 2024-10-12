import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:super_lista/models/model_base.dart';

class ListaDeCompra extends ModelBase {
  String? id; // ID deve ser fornecido apenas pelo firebase;
  final String userId;
  final DateTime? data;
  final String? titulo;

  ListaDeCompra({
    required this.userId,
    this.data,
    this.titulo,
    this.id,
  });

  static CollectionReference<ListaDeCompra> get _collectionRef {
    return ModelBase.db.collection("listas").withConverter(
          fromFirestore: ListaDeCompra.fromFirestore,
          toFirestore: (ListaDeCompra listaDeCompra, _) => listaDeCompra.toFirestore(),
        );
  }

  factory ListaDeCompra.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final dados = snapshot.data();

    return ListaDeCompra(
      id: dados?['id'],
      userId: dados?['userId'],
      data: dados?['data']?.toDate(),
      titulo: dados?['titulo'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "id": id,
      "userId": userId,
      if (titulo != null) "titulo": titulo,
      if (data != null) "data": data,
    };
  }

  Stream<DocumentSnapshot<ListaDeCompra>> find(String id) {
    Stream<DocumentSnapshot<ListaDeCompra>> stream = _collectionRef.doc(id).snapshots();

    stream.listen(
      (DocumentSnapshot<ListaDeCompra> event) {
        print("current data: ${event.data()}"); // Acessando os dados do documento
      },
      onError: (error) => print("Listen failed: $error"),
    );

    return stream;
  }

  static Stream<QuerySnapshot<ListaDeCompra>> all() {
    // Obtendo o stream de snapshots da coleção filtrando pelo "userId"
    Stream<QuerySnapshot<ListaDeCompra>> stream = _collectionRef.where("userId", isEqualTo: 'user1').snapshots();

    // Ouvindo os eventos emitidos pelo stream
    stream.listen(
      (QuerySnapshot<ListaDeCompra> event) {
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
  ListaDeCompra save() {
    id ??= _collectionRef.doc().id;
    _collectionRef.doc(id).set(this);
    return this;
  }
}
