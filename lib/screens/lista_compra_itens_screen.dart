import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:super_lista/blocs/lista_de_compra_item_form.dart';
import 'package:super_lista/blocs/my_app_bar.dart';
import 'package:super_lista/blocs/valor_estimado.dart';
import 'package:super_lista/utils/avaliable_screen.dart';
import 'package:super_lista/utils/colors.dart';
import 'package:super_lista/utils/currency_input_formatter.dart';
import 'package:super_lista/utils/date_format.dart';
import 'package:super_lista/models/lista_de_compra.dart';
import 'package:super_lista/models/lista_de_compra_item.dart';
import 'package:super_lista/models/model_base.dart';

class ListaDeCompraItensScreen extends StatefulWidget {
  final ListaDeCompra listaDeCompra;
  const ListaDeCompraItensScreen({super.key, required this.listaDeCompra});

  @override
  State<ListaDeCompraItensScreen> createState() => _ListaDeCompraItensScreenState();
}

class _ListaDeCompraItensScreenState extends State<ListaDeCompraItensScreen> {
  void _showModalFormItem(ListaDeCompraItem item) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (ctx) {
          return Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 80,
              ),
              child: ListaDeCompraItemForm(
                listaDeCompraItem: item,
                onSubmit: _onItemSubmit,
              ));
        });
  }

  void _addItem() {
    _showModalFormItem(ListaDeCompraItem(listaDeCompraId: widget.listaDeCompra.id!, criadoEm: DateTime.now(), titulo: ""));
  }

  _onItemSubmit(String titulo, int quantidade, double valorUnidade, ListaDeCompraItem item) {
    setState(() {
      item.titulo = titulo;
      item.quantidade = quantidade;
      item.valorUnidade = valorUnidade;
      item.valorTotal = valorUnidade * quantidade;
      item.save();
    });
  }

  double valorPorcentagem = 0.0;
  double montanteConcluido = 0.0;
  double montanteTotal = 0.0;
  late AvaliableScreen screen;
  @override
  Widget build(BuildContext context) {
    screen = AvaliableScreen(context);

    return Scaffold(
      appBar: myAppBar(onBackButton: () => Navigator.of(context).pop()),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: _itens(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addItem,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _titulo() {
    int? diasDeDiferenca = widget.listaDeCompra.data?.difference(DateTime.now()).inDays;

    String dataTitulo;
    if (diasDeDiferenca == null) {
      dataTitulo = 'Data não informada';
    } else if (diasDeDiferenca == 0) {
      dataTitulo = 'Hoje';
    } else {
      dataTitulo = DateFormatSl('dd MMMM').format(widget.listaDeCompra.data!);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: FittedBox(
        child: Text(
          '$dataTitulo - ${widget.listaDeCompra.titulo ?? 'Sem Titulo'}',
          style: Theme.of(context).textTheme.displayMedium,
        ),
      ),
    );
  }

  Widget _itens() {
    final Stream<QuerySnapshot<ListaDeCompraItem>> itens = ListaDeCompraItem.all(widget.listaDeCompra.id!);

    return StreamBuilder<QuerySnapshot<ListaDeCompraItem>>(
      stream: itens,
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator()); // Enquanto aguarda
        }

        if (snapshot.hasError) {
          return Center(child: Text('Erro: ${snapshot.error}')); // Se ocorrer um erro
        }

        List<ListaDeCompraItem> itens = snapshot.data!.docs.map((doc) => doc.data()).toList(); // Obtendo a lista de compras

        itens.sort((itemA, itemB) => itemA.isConcluido ? 1 : -1);

        montanteConcluido = itens.where((ListaDeCompraItem item) => item.isConcluido).toList().fold(0.0, (acc, item) => acc + item.valorTotal!);
        montanteTotal = itens.fold(0.0, (acc, item) => acc + item.valorTotal!);

        valorPorcentagem = montanteTotal != 0 ? montanteConcluido / montanteTotal : 0.0;

        return _itensListView(itens);
      },
    );
  }

  Widget _itensListView(List<ListaDeCompraItem> itens) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: screen.vh(2)),
        SizedBox(
          height: screen.vh(3),
          child: _titulo(),
        ),
        SizedBox(height: screen.vh(1)),
        SizedBox(
          height: screen.vh(4),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: ValorEstimado(itens: itens),
          ),
        ),
        SizedBox(
          height: screen.vh(1),
        ),
        SizedBox(
          height: screen.vh(89),
          child: Builder(builder: (context) {
            if (itens.isEmpty) {
              return Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Nenhum item cadastrado", style: Theme.of(context).textTheme.labelMedium),
                  ],
                ),
              );
            }

            return ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: itens.length,
              itemBuilder: (context, index) {
                ListaDeCompraItem item = itens[index];

                final valorTotal = item.valorTotal ?? 0;
                Widget valorW;
                if (valorTotal > 0) {
                  valorW = FittedBox(
                    child: Text(
                      CurrencyInputFormatter.format(valorTotal),
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                  );
                } else {
                  valorW = const Icon(Icons.attach_money_rounded);
                }

                Color cardColor;

                if (item.isConcluido) {
                  cardColor = ColorsSl.primary;
                } else {
                  cardColor = ColorsSl.defaultC;
                }

                TextStyle subtitleStyle = GoogleFonts.poppins(fontSize: 12);
                Widget subtitle = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('Valor unitário', style: subtitleStyle),
                        Text(' ', style: subtitleStyle),
                        Text(CurrencyInputFormatter.format(item.valorUnidade), style: subtitleStyle),
                      ],
                    ),
                  ],
                );

                return Card(
                  color: cardColor,
                  child: GestureDetector(
                    onTap: () => _showModalFormItem(item),
                    child: ClipRRect(
                      clipBehavior: Clip.hardEdge,
                      borderRadius: BorderRadius.circular(10.0),
                      child: Dismissible(
                        key: Key(ModelBase.uid), // Key aleatória, como é um stream não tem necessidade
                        background: primaryBackgroundDismissible(item.isConcluido),
                        secondaryBackground: secondaryBackgroundDismissible(),

                        onDismissed: (direction) {
                          // Deletar
                          if (DismissDirection.endToStart == direction) {
                            item.delete();
                          }
                          // Checar
                          if (DismissDirection.startToEnd == direction) {
                            if (item.isConcluido) {
                              item.setConcluido(false);
                            } else {
                              item.setConcluido(true);
                            }
                            item.save();
                          }
                        },
                        child: ListTile(
                          title: Text.rich(TextSpan(children: [
                            TextSpan(text: item.titulo ?? 'item'),
                            const TextSpan(text: " "),
                            TextSpan(
                              style: TextStyle(fontWeight: FontWeight.w700, color: ColorsSl.textBodySecondary),
                              text: item.quantidade > 1 ? "x${item.quantidade}" : '',
                            ),
                          ])),
                          leading: SizedBox(
                            width: screen.vw(12),
                            child: valorW,
                          ),
                          subtitle: subtitle,
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }),
        ),
      ],
    );
  }

  Container secondaryBackgroundDismissible() {
    return Container(
      alignment: Alignment.center,
      color: Colors.redAccent,
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
            Text(
              'Deletar',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container primaryBackgroundDismissible(bool isConcluido) {
    List<Widget> actionText;
    if (isConcluido) {
      actionText = [
        Icon(
          Icons.restart_alt_outlined,
          color: ColorsSl.textBody,
        ),
        Text(
          'Não concluído',
          style: TextStyle(
            color: ColorsSl.textBody,
          ),
        )
      ];
    } else {
      actionText = [
        Icon(
          Icons.check,
          color: ColorsSl.textBody,
        ),
        Text(
          'Concluído',
          style: TextStyle(
            color: ColorsSl.textBody,
          ),
        )
      ];
    }

    return Container(
      alignment: Alignment.center,
      color: ColorsSl.primary,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: actionText,
        ),
      ),
    );
  }
}
