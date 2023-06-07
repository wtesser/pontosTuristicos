import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import '../model/pontosTuristicos.dart';

class ConteudoFormDialog extends StatefulWidget{
  final PontosTuristicos? pontoAtual;
  ConteudoFormDialog({Key? key, this.pontoAtual}) : super (key: key);

  @override
  ConteudoFormDialogState createState() => ConteudoFormDialogState();
}
class ConteudoFormDialogState extends State<ConteudoFormDialog>{
  final formKey = GlobalKey<FormState>();
  final descricaoController = TextEditingController();
  final nomeController = TextEditingController();
  final inclusaoController = TextEditingController();
  final diferenciaisController = TextEditingController();
  final _dateFormat = DateFormat('dd/MM/yyyy');
  Position? localizacaoAtual;

  @override
  void initState(){
    super.initState();
    if(widget.pontoAtual != null){
      nomeController.text = widget.pontoAtual!.nome;
      descricaoController.text = widget.pontoAtual!.descricao;
      diferenciaisController.text = widget.pontoAtual!.diferenciais;
      inclusaoController.text = widget.pontoAtual!.prazoFormatado;
    }
  }
  Widget build(BuildContext context){
    // criar com a key - essa chave pode ser usada para interagir com o formulário
    return Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: nomeController,
              decoration: const InputDecoration(labelText: 'Nome'),
              validator: (String? valor) {
                if (valor == null || valor.isEmpty) {
                  return 'Nome';
                }
                return null;
              },
            ),
            TextFormField(
              controller: descricaoController,
              decoration: const InputDecoration(labelText: 'Descrição'),
              validator: (String? valor) {
                if (valor == null || valor.isEmpty) {
                  return 'Descrição';
                }
                return null;
              },
            ),
            TextFormField(
              controller: diferenciaisController,
              decoration: const InputDecoration(labelText: 'Diferênciais'),
              validator: (String? valor) {
                if (valor == null || valor.isEmpty) {
                  return 'Diferênciais';
                }
                return null;
              },
            ),
            Divider(color: Colors.white,),
            Row(
              children: [
                Icon(Icons.calendar_today),
                Text("Data: ${inclusaoController.text.isEmpty ? _dateFormat.format(DateTime.now()) : inclusaoController.text}")
              ],
            ),
          ],
        )
    );
  }
  bool dadosValidados() => formKey.currentState?.validate() == true;

  PontosTuristicos get novoPonto => PontosTuristicos(
      id: widget.pontoAtual?.id ?? 0,
      nome: nomeController.text,
      descricao: descricaoController.text,
      diferenciais: diferenciaisController.text,
      dataInclusao: DateTime.now(),
      latitude: '',
      longitude: ''
  );
}