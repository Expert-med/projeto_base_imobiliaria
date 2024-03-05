class CurrentUser {
  final String id;
  final String name;
  final String email;
  String logoUrl;

  final int tipoUsuario;
  final Map<String, dynamic> contato;
  final List<Map<String, dynamic>> preferencias;
  final List<String> historico;
  final List<String> historicoBusca;
  final List<String> imoveisFavoritos;
  final String UID;
  final String num_identificacao;

  CurrentUser({
    required this.id,
    required this.name,
    required this.email,
    required this.logoUrl,
    required this.tipoUsuario,
     required this.contato,
    required this.preferencias,
    required this.historico,
    required this.historicoBusca,
    required this.imoveisFavoritos,
    required this.UID,
    required this.num_identificacao,
  });
}
