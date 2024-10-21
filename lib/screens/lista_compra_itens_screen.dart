import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:super_lista/blocs/lista_de_compra_item_form.dart';
import 'package:super_lista/blocs/my_app_bar.dart';
import 'package:super_lista/utils/avaliable_screen.dart';
import 'package:super_lista/utils/colors.dart';
import 'package:super_lista/utils/currency_input_formatter.dart';
import 'package:super_lista/utils/date_format.dart';
import 'package:super_lista/utils/number_format.dart';
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
              padding: const EdgeInsets.only(left: 20, right: 20, top: 80,),
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: _itens(),
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
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w800),
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
            height: screen.vh(3),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Builder(builder: (context) {
                TextStyle style = Theme.of(context).textTheme.labelMedium!;

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Valor estimado', style: style),
                    Text('${CurrencyInputFormatter.format(montanteConcluido)} / ${CurrencyInputFormatter.format(montanteTotal)}',
                        style: style),
                  ],
                );
              }),
            )),
        SizedBox(
          height: screen.vh(1),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: LinearProgressIndicator(
                backgroundColor: ColorsSl.defaultC,
                value: valorPorcentagem,
                valueColor: AlwaysStoppedAnimation(ColorsSl.primary),
              ),
            ),
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
                  valorW = Text(
                    "${NumberformatSl.format(valorTotal)}",
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  );
                } else {
                  valorW = const Icon(Icons.attach_money_rounded);
                }

                Color circleMoneyColor;

                if (item.isConcluido) {
                  circleMoneyColor = ColorsSl.primary;
                } else {
                  circleMoneyColor = ColorsSl.secondary;
                }

                return Card(
                  color: ColorsSl.defaultC,
                  child: GestureDetector(
                    onTap: () => _showModalFormItem(item),
                    child: ClipRRect(
                      clipBehavior: Clip.hardEdge,
                      borderRadius: BorderRadius.circular(14.0),
                      child: Dismissible(
                        key: Key(ModelBase.uid), // Key aleatória, como é um stream não tem necessidade
                        background: Container(color: item.isConcluido ? ColorsSl.secondary : ColorsSl.primary),
                        secondaryBackground: Container(color: Colors.red),

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
                            width: 55,
                            height: 55,
                            child: Card(
                              elevation: 0,
                              color: circleMoneyColor,
                              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(25))),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  FittedBox(
                                      child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 6),
                                    child: valorW,
                                  ))
                                ],
                              ),
                            ),
                          ),
                          subtitle: Text(DateFormatSl('MMMM, y').format(item.concluidoEm != null ? item.concluidoEm! : item.criadoEm)),
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
}
