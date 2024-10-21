import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:super_lista/models/lista_de_compra.dart';

class ListaDeCompraForm extends StatefulWidget {
  final Function(ListaDeCompra listaDeCompra, String? titulo, DateTime? data) onSubmit;
  final ListaDeCompra? listaDeCompra;

  const ListaDeCompraForm({super.key, required this.onSubmit, this.listaDeCompra});

  @override
  State<ListaDeCompraForm> createState() => _ListaDeCompraFormState();
}

class _ListaDeCompraFormState extends State<ListaDeCompraForm> {
  final _tituloController = TextEditingController();
  DateTime? _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();

    setState(() {
      if (widget.listaDeCompra != null) {
        _tituloController.text = widget.listaDeCompra?.titulo ?? '';
        _selectedDate = widget.listaDeCompra?.data!;
      }
    });
  }

  _showDatePicker() {
    showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 360)),
      initialDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate != null) {
        setState(() {
          _selectedDate = pickedDate;
        });
      }
    });
  }

  _submitForm() {
    final titulo = _tituloController.text;
    final listaDeCompra = widget.listaDeCompra ?? ListaDeCompra(userId: 'user1');
    widget.onSubmit(listaDeCompra, titulo, _selectedDate);

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _tituloController,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            if (_selectedDate == null) const Text('Nenhuma data selecionada'),
            if (_selectedDate != null) Text('Data selecionada: ${DateFormat('dd/MM/y').format(_selectedDate!)}'),
            TextButton(onPressed: _showDatePicker, child: const Text('Selecionar Data')),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(onPressed: _submitForm, child: const Text('salvar')),
          ],
        )
      ],
    );
  }
}
