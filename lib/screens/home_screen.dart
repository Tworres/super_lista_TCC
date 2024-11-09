import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:super_lista/blocs/lista_de_compra_form.dart';
import 'package:super_lista/blocs/my_app_bar.dart';
import 'package:super_lista/blocs/valor_estimado.dart';
import 'package:super_lista/utils/avaliable_screen.dart';
import 'package:super_lista/utils/colors.dart';
import 'package:super_lista/models/lista_de_compra.dart';
import 'package:super_lista/models/lista_de_compra_item.dart';
import 'package:super_lista/screens/lista_compra_itens_screen.dart';
import 'package:super_lista/utils/date_format.dart';

enum SampleItem { itemOne, itemTwo, itemThree }

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  
  /// Evento ocorre quando o botão de "salvar" é clicado no formulário.
  _onListaDeCompraFormSubmit(ListaDeCompra lc, String? titulo, DateTime? data) {
    setState(() {
      lc.data = data;
      lc.titulo = titulo;

      // Salva as alterações no banco de dados.
      lc.save();
    });
  }

  /// Evento ocorre quando é clicado no botão flutuante, abre um formulário para salvar uma lista.
  _showModalFormLista([ListaDeCompra? listaDeCompra]) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: ListaDeCompraForm(onSubmit: _onListaDeCompraFormSubmit, listaDeCompra: listaDeCompra),
        );
      },
    );
  }

  late AvaliableScreen screen;

  @override
  Widget build(BuildContext context) {
    screen = AvaliableScreen(context);

    return Scaffold(
      appBar: myAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: screen.vh(3),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  'Listas',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                height: screen.vh(97),
                child: streamDeListas(),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showModalFormLista();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  SampleItem? selectedItem;
  int hoje = int.tryParse(DateFormat("y-M-d").format(DateTime.now()).replaceAll('-', ''))!;

  /// Trata o stream de listas de compras
  StreamBuilder<QuerySnapshot<ListaDeCompra>> streamDeListas() {
    return StreamBuilder<QuerySnapshot<ListaDeCompra>>(
      stream: ListaDeCompra.all(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator()); // Enquanto aguarda
        }

        if (snapshot.hasError) {
          return Center(child: Text('Erro: ${snapshot.error}')); // Se ocorrer um erro
        }

        if (snapshot.data != null && snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('Nenhuma lista encontrada.')); // Se não houver dados
        }

        List<ListaDeCompra> listas = snapshot.data!.docs.map((doc) => doc.data()).toList(); // Obtendo a lista de compras

        listas.sort((a, b) {
          int dataListaA = int.tryParse(DateFormat("y-M-d").format(a.data!).replaceAll('-', ''))!;
          int dataListaB = int.tryParse(DateFormat("y-M-d").format(b.data!).replaceAll('-', ''))!;

          if (dataListaA == hoje && dataListaB != hoje) return -1; // a é de hoje, b não
          if (dataListaB == hoje && dataListaA != hoje) return 1; // b é de hoje, a não
          if (dataListaA > hoje && dataListaB <= hoje) return -1; // a é do futuro, b é do passado ou hoje
          if (dataListaB > hoje && dataListaA <= hoje) return 1; // b é do futuro, a é do passado ou hoje

          return dataListaA > dataListaB ? -1 : 1; // Ordena pela data normalmente
        });

        return ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: listas.length,
          itemBuilder: (context, index) {
            ListaDeCompra lista = listas[index];

            int dataLista = int.tryParse("${lista.data!.year}${lista.data!.month}${lista.data!.day}")!;

            Color cardColor;
            if (dataLista > hoje) {
              cardColor = ColorsSl.defaultC;
            } else if (dataLista == hoje) {
              cardColor = ColorsSl.primary;
            } else {
              cardColor = ColorsSl.secondary;
            }

            var streamItens = lista.itens();

            return StreamBuilder(
                stream: streamItens,
                builder: (context, snapshot) {
                  List<ListaDeCompraItem>? itens = snapshot.data?.docs.map((doc) => doc.data()).toList(); // Obtendo a lista de compras

                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ListaDeCompraItensScreen(listaDeCompra: lista),
                        ),
                      );
                    },
                    child: Card(
                      color: cardColor,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: _listaTile(itens, lista),
                      ),
                    ),
                  );
                });
          },
        );
      },
    );
  }

  ListTile _listaTile(List<ListaDeCompraItem>? itens, ListaDeCompra lista) {
    int dataLista = int.tryParse("${lista.data!.year}${lista.data!.month}${lista.data!.day}")!;
    String data = dataLista == hoje ? 'Hoje' : DateFormatSl('dd MMM').format(lista.data!);
    Widget tituloLista = Text(
      "$data - ${lista.titulo == '' ? 'Titulo Indefinido' : lista.titulo}",
      overflow: TextOverflow.ellipsis,
      style: Theme.of(context).textTheme.displaySmall,
    );

    int? quantidadeItens = itens?.length;

    Widget quantidadeItensW;
    if (quantidadeItens == null) {
      quantidadeItensW = const CircularProgressIndicator();
    } else {
      quantidadeItensW = Text(
        "$quantidadeItens itens",
        style: Theme.of(context).textTheme.bodySmall,
      );
    }

    return ListTile(
      title: tituloLista,
      leading: SizedBox(
        width: screen.vw(10),
        child: Text(
          data,
          style: Theme.of(context).textTheme.displayMedium,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          quantidadeItensW,
          ValorEstimado(
            itens: itens,
            progressBgColor: const Color.fromRGBO(0, 0, 0, 0.3),
            progressBarColor: ColorsSl.textBodySecondary,
            fontSize: 11,
          )
        ],
      ),
      trailing: PopupMenuButton(
        itemBuilder: (BuildContext context) => <PopupMenuEntry<SampleItem>>[
          PopupMenuItem(
            child: const Text('Editar'),
            onTap: () => _showModalFormLista(lista),
          ),
          PopupMenuItem(
            onTap: lista.delete,
            child: const Text('Deletar'),
          ),
        ],
      ),
    );
  }
}
