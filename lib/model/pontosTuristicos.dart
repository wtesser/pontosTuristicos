import 'package:intl/intl.dart';

//declara a classe dos pontos turisticos
class PontosTuristicos{
  static const NOME_TABELA = 'pontosturisticos';
  static const CAMPO_ID = 'id';
  static const CAMPO_NOME = 'nome';
  static const CAMPO_DESCRICAO = 'descricao';
  static const CAMPO_DIFERENCIAIS = 'diferenciais';
  static const CAMPO_INCLUSAO = 'inclusao';
  static const CAMPO_LATITUDE = 'latitude';
  static const CAMPO_LONGITUDE = 'longitude';
  int id;
  String nome;
  String descricao;
  String diferenciais;
  DateTime? dataInclusao;
  String latitude;
  String longitude;
  bool finalizada;

//contrutor de classe - inicializa as  váriaveis
  PontosTuristicos({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.diferenciais,
    this.dataInclusao,
    required this.latitude,
    required this.longitude,
    this.finalizada = false,
  });

  //retorno da data de inclusão
  String get prazoFormatado{
    if (dataInclusao == null){
      return '';
    }
    return DateFormat('dd/MM/yyyy').format(dataInclusao!);
  }
  Map<String, dynamic> toMap() => {
    CAMPO_ID: id == 0 ? null : id,
    CAMPO_NOME: nome,
    CAMPO_DIFERENCIAIS: diferenciais,
    CAMPO_DESCRICAO: descricao,
    CAMPO_INCLUSAO:
    dataInclusao == null ? null : DateFormat("yyyy-MM-dd").format(dataInclusao!),
    CAMPO_LATITUDE: latitude,
    CAMPO_LONGITUDE: longitude

  };
  factory PontosTuristicos.fromMap(Map<String, dynamic> map) => PontosTuristicos(
    id: map[CAMPO_ID] is int ? map[CAMPO_ID] : null,
    nome: map[CAMPO_NOME] is String ? map[CAMPO_NOME] : '',
    descricao: map[CAMPO_DESCRICAO] is String ? map[CAMPO_DESCRICAO] : '',
    diferenciais: map[CAMPO_DIFERENCIAIS] is String ? map[CAMPO_DIFERENCIAIS] : '',
    dataInclusao: map[CAMPO_INCLUSAO] is String
        ? DateFormat("yyyy-MM-dd").parse(map[CAMPO_INCLUSAO])
        : null,
    latitude: map[CAMPO_LATITUDE] is String ? map[CAMPO_LATITUDE] : '',
    longitude: map[CAMPO_LONGITUDE] is String ? map[CAMPO_LONGITUDE] : '',
  );

}