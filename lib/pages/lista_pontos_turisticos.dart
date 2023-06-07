import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pontos_turisticos/dao/pontoTuristico_dao.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/pontosTuristicos.dart';
import 'detalhe_ponto.dart';
import 'filtro_page.dart';
import 'form_new_point.dart';

class ListaPontosTuristicos extends StatefulWidget {
  @override
  _ListaPontosTuristicos createState() => _ListaPontosTuristicos();
}

class _ListaPontosTuristicos extends State<ListaPontosTuristicos> {

  static const ACAO_EDITAR = 'editar';
  static const ACAO_EXCLUIR = 'excluir';
  static const ACAO_VISUALIZAR = 'visualizar';

  final _pontosTuristicos = <PontoTuristico>[];

  final _dao = PontoTuristicoDao();
  var _carregando = false;
  var _ultimoId = 1;

  @override
  void initState(){
    super.initState();
    _popularDados();
  }

  void _popularDados() async{
    setState(() {
      _carregando = true;
    });

    final prefs = await SharedPreferences.getInstance();
    final campoOrdenacao = prefs.getString(FiltroPage.chaveCampoOrdenacao) ?? PontoTuristico.CAMPO_ID;
    final usarOrdemDecrescente = prefs.getBool(FiltroPage.chaveUsarOrdemDesc) == true;
    final filtroDescricao = prefs.getString(FiltroPage.chaveCampoDescricao) ?? '';
    final filtroDiferencial = prefs.getString(FiltroPage.chaveCampoDiferenciais) ?? '';

    final ponto = await _dao.listar(
        filtroDescricao: filtroDescricao,
        campoOrdenacao: campoOrdenacao,
        usarOrdemDecrescente: usarOrdemDecrescente,
        filtroDiferenciais: filtroDiferencial
    );
    setState(() {
      _pontosTuristicos.clear();
      if (ponto.isNotEmpty){
        _pontosTuristicos.addAll(ponto);
      }
      _carregando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _criarAppBar(),
      body: _criarBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: _abrirForm,
        tooltip: 'Novo Ponto Turístico',
        child: Icon(Icons.add),
      ),
    );
  }

  void _abrirForm({PontoTuristico? pontoTuristico, bool? readOnly}) {
    final key = GlobalKey<FormNewPointState>();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(pontoTuristico == null ? 'Novo Ponto Turístico' : 'Alterar o Ponto Turístico: ${pontoTuristico.id}'),
            content: FormNewPoint(key: key, pontoTuristico: pontoTuristico),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: readOnly == true ? Text('Voltar') : Text('Cancelar')
              ),
              if (readOnly == null || readOnly == false)
                TextButton(
                    onPressed: () {
                      if (key.currentState != null && key.currentState!.dadosValidados()) {
                        Navigator.of(context).pop();

                        final novoPonto = key.currentState!.newPoint;
                        _dao.salvar(novoPonto).then((sucess){
                          if (sucess){
                            _popularDados();
                          }
                        });
                      }
                    },
                    child: Text('Salvar')
                )
            ],
          );
        }
    );
  }


  void _excluirTarefa(PontoTuristico ponto) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Row(
              children: [
                Icon(Icons.warning, color: Colors.red[900]),
                Padding(
                    padding: EdgeInsets.only(left: 10),
                child: Text('Atenção!!!'),
                )
              ],
            ),
            content: Text('Esse registro será deletado permanentemente!'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(), child: Text('Cancelar')
              ),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    if (ponto.id == null){
                      return;
                    }else{
                      _dao.deletar(ponto).then((result){
                        if(result){
                          _popularDados();
                        }
                      });
                    }
                  }, child: Text('Confirmar')
              ),
            ],
          );
        });
  }

  AppBar _criarAppBar() {
    return AppBar(
      title: const Text('Cadastramento de Pontos Turisticos'),
      actions: [
        IconButton(
            onPressed: _abrirPaginaFiltro,
            icon: const Icon(Icons.filter_list)),
      ],
    );
  }

  Widget _criarBody() {
    if (_carregando){
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(
            alignment: AlignmentDirectional.center,
            child: CircularProgressIndicator(),
          ),
          Align(
            alignment: AlignmentDirectional.center,
            child: Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text(
                'Carregando os pontos turísticos',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          )
        ],
      );
    }

    if (_pontosTuristicos.isEmpty) {
      return const Center(
        child: Text('Não existem pontos turísticos cadastrados!',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      );
    }
    return ListView.separated(
      itemCount: _pontosTuristicos.length,
      separatorBuilder: (BuildContext context, int index) => Divider(),
      itemBuilder: (BuildContext context, int index) {
        final pontoAtual = _pontosTuristicos[index];

        return PopupMenuButton<String>(
          child: ListTile(
              leading: Checkbox(
                value: pontoAtual.finalizado,
                onChanged: (bool? checked){
                  setState(() {
                    pontoAtual.finalizado = checked == true;
                  });
                  _dao.salvar(pontoAtual);
                },
              ),
            title: Text('${pontoAtual.id} - ${pontoAtual.nome}',
            style: TextStyle(
              decoration:
                pontoAtual.finalizado ? TextDecoration.lineThrough : null,
              color: pontoAtual.finalizado ? Colors.grey : null,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Data da Inclusão - ${pontoAtual.dataInclusaoFormatado}'),
                Text('Diferenciais - ${pontoAtual.diferencial}'),
              ],
            )
          ),
          itemBuilder: (BuildContext context) => _criarItensMenu(),
          onSelected: (String valorSelecionado) {
            if (valorSelecionado == ACAO_EDITAR) {
              _abrirForm(pontoTuristico: pontoAtual, readOnly: false);
            } else if (valorSelecionado == ACAO_EXCLUIR) {
              _excluirTarefa(pontoAtual);
            } else if (valorSelecionado == ACAO_VISUALIZAR) {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => DetalhePonto(pontoTuristico: pontoAtual)
              ));
            }
          },
        );
      },
    );
  }

  List<PopupMenuEntry<String>> _criarItensMenu() {
    return [
      PopupMenuItem(
          value: ACAO_VISUALIZAR,
          child: Row(
            children: [
              Icon(Icons.visibility, color: Colors.teal,),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text('Visualizar'),
              )
            ],
          )
      ),
      PopupMenuItem(
        value: ACAO_EDITAR,
          child: Row(
            children: [
              Icon(Icons.edit, color: Colors.black,),
              Padding(
                  padding: EdgeInsets.only(left: 10),
                child: Text('Editar'),
              )
            ],
          )
      ),
      PopupMenuItem(
          value: ACAO_EXCLUIR,
          child: Row(
            children: [
              Icon(Icons.delete, color: Colors.red,),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text('Excluir'),
              )
            ],
          )
      )
    ];
  }

  void _abrirPaginaFiltro() {
    final navigator = Navigator.of(context);
    navigator.pushNamed(FiltroPage.routeName).then((alterouValores) {
      if (alterouValores == true) {
       _popularDados();
      }
    });
  }
}