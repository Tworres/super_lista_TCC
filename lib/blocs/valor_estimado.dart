import 'package:flutter/material.dart';
import 'package:super_lista/models/lista_de_compra_item.dart';
import 'package:super_lista/utils/colors.dart';
import 'package:super_lista/utils/currency_input_formatter.dart';

class ValorEstimado extends StatelessWidget {
  final List<ListaDeCompraItem>? itens;
  final TextStyle? textStyle;
  final Color? progressBgColor;
  final Color? progressBarColor;
  final double? fontSize;
  const ValorEstimado({super.key, required this.itens, this.textStyle, this.progressBarColor, this.progressBgColor, this.fontSize});

  @override
  Widget build(BuildContext context) {
    double? montanteConcluido = itens?.where((ListaDeCompraItem item) => item.isConcluido).toList().fold(0.0, (acc, item) => acc! + item.valorTotal!);
    double? montanteTotal = itens?.fold(0.0, (acc, item) => acc! + (item.valorTotal ?? 0));
    double valorPorcentagem = 0;

    if (montanteTotal != null && montanteTotal != 0) {
      valorPorcentagem = (montanteConcluido ?? 0) / montanteTotal;
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [ 
            Text('Valor', style: textStyle ?? Theme.of(context).textTheme.labelMedium),
            Text(
              '${CurrencyInputFormatter.format(montanteConcluido)} / ${CurrencyInputFormatter.format(montanteTotal)}',
              style: textStyle ?? Theme.of(context).textTheme.labelMedium?.copyWith(fontSize: fontSize ?? 14),
            ),
          ],
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: LinearProgressIndicator(
            backgroundColor: progressBgColor ?? ColorsSl.defaultC,
            value: valorPorcentagem,
            valueColor: AlwaysStoppedAnimation(progressBarColor ?? ColorsSl.primary),
          ),
        ),
      ],
    );
  }
}
