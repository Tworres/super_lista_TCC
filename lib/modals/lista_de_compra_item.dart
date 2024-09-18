class ListaDeCompraItem {
  final int id;
  final int listaDeCompraId;
  final String? titulo;
  final bool isConcluido;
  final DateTime? concluidoEm;
  final DateTime? criadoEm;
  final int quantidade;
  final double? valor;

  ListaDeCompraItem({
    required this.id,
    required this.listaDeCompraId,
    this.titulo,
    this.isConcluido = false,
    this.concluidoEm,
    this.criadoEm,
    this.quantidade = 1,
    this.valor,
  });

  static final List<ListaDeCompraItem> _listaDeCompraItens = [
    ListaDeCompraItem(id: 1, listaDeCompraId: 1, titulo: 'desodorante', valor: 17.9, criadoEm: DateTime.now()),
    ListaDeCompraItem(id: 2, listaDeCompraId: 1, titulo: 'desodorante', valor: 17.9, criadoEm: DateTime.now()),
    ListaDeCompraItem(id: 3, listaDeCompraId: 1, titulo: 'desodorante', valor: 17.9, criadoEm: DateTime.now()),
    ListaDeCompraItem(id: 4, listaDeCompraId: 1, titulo: 'desodorante', valor: 17.9, criadoEm: DateTime.now()),
  ];

  static List<ListaDeCompraItem> todos() {
    return ListaDeCompraItem._listaDeCompraItens;
  }

  static inserir(ListaDeCompraItem item) {
    ListaDeCompraItem._listaDeCompraItens.add(item);
  }
}
