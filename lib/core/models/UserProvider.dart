class CurrentUser {
  final String id;
  final String name;
  final String email;
  String imageUrl;

  final int tipoUsuario;
  final Map<String, dynamic> contato;
  final List<Map<String, dynamic>> preferencias;
  final List<String> historico;
  final List<String> historicoBusca;
  final List<String> imoveisFavoritos;
  final String UID;

  CurrentUser({
    required this.id,
    required this.name,
    required this.email,
    required this.imageUrl,
    required this.tipoUsuario,
     required this.contato,
    required this.preferencias,
    required this.historico,
    required this.historicoBusca,
    required this.imoveisFavoritos,
    required this.UID,
  });
}
