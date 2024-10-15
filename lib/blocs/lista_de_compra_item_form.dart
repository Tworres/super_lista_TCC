import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:super_lista/models/lista_de_compra_item.dart';

class ListaDeCompraItemForm extends StatefulWidget {
  final ListaDeCompraItem listaDeCompraItem;
  final Function(String titulo, int quantidade, double valor, ListaDeCompraItem item) onSubmit;

  const ListaDeCompraItemForm({super.key, required this.listaDeCompraItem, required this.onSubmit});

  @override
  State<ListaDeCompraItemForm> createState() => _ListaDeCompraItemFormState();
}

class _ListaDeCompraItemFormState extends State<ListaDeCompraItemForm> {
  late TextEditingController _tituloController;
  late TextEditingController _quantidadeController;
  late TextEditingController _valorController;

  void initState() {
    super.initState();

    _tituloController = TextEditingController(text: widget.listaDeCompraItem.titulo ?? '');
    _quantidadeController = TextEditingController(text: "${widget.listaDeCompraItem.quantidade}");
    _valorController = TextEditingController(text: "${widget.listaDeCompraItem.valor ?? ''}");
  }

  _submitForm() {
    widget.onSubmit(_tituloController.text, int.tryParse(_quantidadeController.text) ?? 1, double.tryParse(_valorController.text) ?? 0.0, widget.listaDeCompraItem);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          decoration: const InputDecoration(label: Text('Nome Produto')),
          controller: _tituloController,
        ),
        TextField(
          decoration: const InputDecoration(label: Text('Quantidade')),
          keyboardType: TextInputType.number,
          controller: _quantidadeController,
        ),
        TextField(
          decoration: const InputDecoration(label: Text('Valor por unidade (opcional)')),
          keyboardType: TextInputType.number,
          controller: _valorController,
        ),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceAround,
        //   children: [
        //     if (_selectedDate == null) Text('Nenhuma data selecionada'),
        //     if (_selectedDate != null) Text('Data selecionada: ' + DateFormat('dd/MM/y').format(_selectedDate!)),
        //     TextButton(onPressed: _showDatePicker, child: Text('Selecionar Data')),
        //   ],
        // ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(onPressed: _submitForm, child: const Text('Editar')),
          ],
        )
      ],
    );
  }
}
