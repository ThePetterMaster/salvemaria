class DdAssuntos {
  String? id;
  String? assunto;
  String? ordemExibicao;

  DdAssuntos({this.id, this.assunto, this.ordemExibicao});

  DdAssuntos.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    assunto = json['assunto'];
    ordemExibicao = json['ordem_exibicao'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['assunto'] = this.assunto;
    data['ordem_exibicao'] = this.ordemExibicao;
    return data;
  }
}
