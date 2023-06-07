
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/pontosTuristicos.dart';

class ConteudoFormDialog extends StatefulWidget{
  final PontoTuristico? tarefaAtual;

  ConteudoFormDialog({Key? key, this.tarefaAtual}) : super (key: key);

  @override
  ConteudoFormDialogState createState() => ConteudoFormDialogState();

}
class ConteudoFormDialogState extends State<ConteudoFormDialog> {

  final formKey = GlobalKey<FormState>();
  final descricaoController = TextEditingController();
  final inclusaoController = TextEditingController();
  final nomeController = TextEditingController();
  final diferencialController = TextEditingController();
  final _dateFormat = DateFormat('dd/MM/yyyy');

  @override
  void initState(){
    super.initState();
    if (widget.tarefaAtual != null){
      descricaoController.text = widget.tarefaAtual!.descricao;
      inclusaoController.text = widget.tarefaAtual!.dataInclusaoFormatado;
    }
    inclusaoController.text = _dateFormat.format(DateTime.now());
  }

  Widget build(BuildContext context){
    return Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: descricaoController,
              decoration: InputDecoration(labelText: 'Descrição'),
              validator: (String? valor){
                if (valor == null || valor.isEmpty){
                  return 'Preencha com a descrição';
                }
                return null;
              },
            ),
            TextFormField(
              controller: inclusaoController,
              decoration: InputDecoration(labelText: 'Prazo',
                prefixIcon: IconButton(
                  onPressed: _mostrarCalendario,
                  icon: Icon(Icons.calendar_today),
                ),
                suffixIcon: IconButton(
                  onPressed: () => inclusaoController.clear(),
                  icon: Icon(Icons.close),
                ),
              ),
              readOnly: true,
            ),
          ],
        )
    );
  }
  void _mostrarCalendario(){
    final dataFormatada = inclusaoController.text;
    var data = DateTime.now();
    if(dataFormatada.isNotEmpty){
      data = _dateFormat.parse(dataFormatada);
    }
    showDatePicker(
      context: context,
      initialDate: data,
      firstDate: data.subtract(Duration(days:365 * 5 )),
      lastDate: data.add(Duration(days:365 * 5 )),
    ).then((DateTime? dataSelecionada){
      if(dataSelecionada != null){
        setState(() {
          inclusaoController.text = _dateFormat.format(dataSelecionada);
        });
      }
    });
  }

  bool dadosValidados() => formKey.currentState?.validate() == true;

  PontoTuristico get novaTarefa => PontoTuristico(
    id: widget.tarefaAtual?.id ?? 0,
    descricao: descricaoController.text,
    nome: nomeController.text,
    diferencial: diferencialController.text,
    inclusao: DateTime.now(),
  );
}