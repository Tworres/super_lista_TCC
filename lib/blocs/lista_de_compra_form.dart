import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ListaDeCompraForm extends StatefulWidget {
  final Function(String? titulo, DateTime? data) onSubmit;
  const ListaDeCompraForm({super.key, required this.onSubmit});

  @override
  State<ListaDeCompraForm> createState() => _ListaDeCompraFormState();
}

class _ListaDeCompraFormState extends State<ListaDeCompraForm> {
  final _tituloController = TextEditingController();
  DateTime? _selectedDate = DateTime.now();

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

    widget.onSubmit(titulo, _selectedDate);

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
            if (_selectedDate == null) Text('Nenhuma data selecionada'),
            if (_selectedDate != null) Text('Data selecionada: ' + DateFormat('dd/MM/y').format(_selectedDate!)),
            TextButton(onPressed: _showDatePicker, child: Text('Selecionar Data')),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(onPressed: _submitForm, child: const Text('add')),
          ],
        )
      ],
    );
  }
}
