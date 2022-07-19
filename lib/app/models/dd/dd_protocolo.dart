class DdProtocolo {
  String? id;
  String? protocolo;

  DdProtocolo({this.id, this.protocolo});

  DdProtocolo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    protocolo = json['protocolo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['protocolo'] = this.protocolo;
    return data;
  }
}
