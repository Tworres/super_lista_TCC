import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:super_lista/models/lista_de_compra_item.dart';
import 'package:super_lista/models/model_base.dart';
import 'package:super_lista/providers/auth.dart';

class ListaDeCompra {
  String? id; // ID deve ser fornecido apenas pelo firebase;
  String userId;
  DateTime? data;
  String? titulo;

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

  // Captura um stream de uma lista no firestore
  static Stream<DocumentSnapshot<ListaDeCompra>> find(String id) {
    Stream<DocumentSnapshot<ListaDeCompra>> stream = _collectionRef.doc(id).snapshots();

    return stream;
  }

  // Captura um stream de todas as listas no firestore
  static Stream<QuerySnapshot<ListaDeCompra>> all() {
    final userId = Auth.id();
    // Obtendo o stream de snapshots da coleção filtrando pelo "userId"
    Stream<QuerySnapshot<ListaDeCompra>> stream = _collectionRef.where("userId", isEqualTo: userId).snapshots();

    //Retornando o stream para atualização em tempo real dos dados.
    return stream;
  }

  /// Insere ou atualiza um dado no firebase
  ListaDeCompra save() {
    id ??= _collectionRef.doc().id;
    _collectionRef.doc(id).set(this);
    return this;
  }
 
  // Captura os itens relacionados a esta lista
  Stream<QuerySnapshot<ListaDeCompraItem>>? itens() {
    if (id != null) return ListaDeCompraItem.all(id!);
    return null;
  }

  // Deleta esta lista
  void delete() {
    _collectionRef.doc(id).delete();

    // Remove todos os itens associados a esta lista
    ListaDeCompraItem.all(id!).listen(
      (QuerySnapshot<ListaDeCompraItem> event) {
        for (var doc in event.docs) {
          doc.data().delete();
        }
      },
    );
  }
}
