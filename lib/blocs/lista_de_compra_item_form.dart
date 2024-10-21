import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:super_lista/models/lista_de_compra_item.dart';
import 'package:super_lista/utils/currency_input_formatter.dart';

class ListaDeCompraItemForm extends StatefulWidget {
  final ListaDeCompraItem listaDeCompraItem;
  final Function(String titulo, int quantidade, double valorUnidade, ListaDeCompraItem item) onSubmit;

  const ListaDeCompraItemForm({super.key, required this.listaDeCompraItem, required this.onSubmit});

  @override
  State<ListaDeCompraItemForm> createState() => _ListaDeCompraItemFormState();
}

class _ListaDeCompraItemFormState extends State<ListaDeCompraItemForm> {
  late TextEditingController _tituloController;
  late TextEditingController _quantidadeController;
  late TextEditingController _valorUnidadeController;
  late TextEditingController _valorTotalController;

  _sum(TextEditingController input, double sumVal, {double? maxValue, double? minValue, required bool isCurrency}) {
    double? currentVal;
    double newVal;
    String newValText;

    if (isCurrency) {
      currentVal = CurrencyInputFormatter.unformat(input.text);
      newVal = (currentVal ?? 0) + sumVal;
      newValText = CurrencyInputFormatter.format(newVal);
    } else {
      currentVal = double.tryParse(input.text);
      newVal = (currentVal ?? 0) + sumVal;
      newValText = (newVal == newVal.toInt()) ? "${newVal.toInt()}" : "$newVal";
    }

    if (maxValue != null && newVal > maxValue) return;
    if (minValue != null && newVal < minValue) return;

    setState(() {
      input.text = newValText;
    });
  }

  _sincronizarValorTotal() {
    double? valorUnidade = CurrencyInputFormatter.unformat(_valorUnidadeController.text);
    int? quantidade = int.tryParse(_quantidadeController.text);
    if (quantidade == null || valorUnidade == null) return;

    setState(() {
      _valorTotalController.text = CurrencyInputFormatter.format(quantidade * valorUnidade);
    });
  }

  _sincronizarValorUnidade() {
    double? valorTotal = CurrencyInputFormatter.unformat(_valorTotalController.text);
    int? quantidade = int.tryParse(_quantidadeController.text);
    if (quantidade == null || valorTotal == null) return;

    setState(() {
      _valorUnidadeController.text = CurrencyInputFormatter.format(valorTotal / quantidade);
    });
  }

  @override
  void initState() {
    super.initState();

    _tituloController = TextEditingController(text: widget.listaDeCompraItem.titulo ?? '');
    _quantidadeController = TextEditingController(text: "${widget.listaDeCompraItem.quantidade}");
    _valorUnidadeController = TextEditingController(text: CurrencyInputFormatter.format(widget.listaDeCompraItem.valorUnidade));
    _valorTotalController = TextEditingController(text: CurrencyInputFormatter.format(widget.listaDeCompraItem.valorTotal));
  }

  _submitForm() {
    final titulo = _tituloController.text;
    final quantidade = int.tryParse(_quantidadeController.text);
    final valorUnidade = CurrencyInputFormatter.unformat(_valorUnidadeController.text);

    if (quantidade == null || titulo == "") return;

    widget.onSubmit(_tituloController.text, quantidade, valorUnidade ?? 0.0, widget.listaDeCompraItem);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          autofocus: true,
          decoration: const InputDecoration(label: Text('Nome Produto')),
          controller: _tituloController,
        ),
        const SizedBox(height: 10),
        TextField(
          decoration: InputDecoration(
            label: const Text('Quantidade'),
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    _sum(_quantidadeController, -1, minValue: 1, isCurrency: false);
                    _sincronizarValorTotal();
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    _sum(_quantidadeController, 1, isCurrency: false);
                    _sincronizarValorTotal();
                  },
                ),
              ],
            ),
          ),
          keyboardType: TextInputType.number,
          controller: _quantidadeController,
        ),
        const SizedBox(height: 10),
        TextField(
          decoration: InputDecoration(
            label: const Text('Valor Unidade (opcional)'),
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    _sum(_valorUnidadeController, -0.5, minValue: 0, isCurrency: true);
                    _sincronizarValorTotal();
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    _sum(_valorUnidadeController, 0.5, isCurrency: true);
                    _sincronizarValorTotal();
                  },
                ),
              ],
            ),
          ),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            CurrencyInputFormatter(),
          ],
          keyboardType: TextInputType.number,
          controller: _valorUnidadeController,
          onChanged: (String value) => _sincronizarValorTotal(),
        ),
        const SizedBox(height: 10),
        TextField(
          decoration: InputDecoration(
            label: Text('Valor Total (opcional)'),
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    _sum(_valorTotalController, -0.5, minValue: 0, isCurrency: true);
                    _sincronizarValorUnidade();
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    _sum(_valorTotalController, 0.5, isCurrency: true);
                    _sincronizarValorUnidade();
                  },
                ),
              ],
            ),
          ),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            CurrencyInputFormatter(),
          ],
          keyboardType: TextInputType.number,
          controller: _valorTotalController,
          onChanged: (String value) => _sincronizarValorUnidade(),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(onPressed: _submitForm, child: const Text('Salvar')),
          ],
        )
      ],
    );
  }
}
