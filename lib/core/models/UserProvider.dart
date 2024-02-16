class ChatUser {
  final String id;
  final String name;
  final String email;
  String imageUrl; // Remova o modificador final

  final int tipoUsuario;

  ChatUser({
    required this.id,
    required this.name,
    required this.email,
    required this.imageUrl,
    required this.tipoUsuario,
  });
}
