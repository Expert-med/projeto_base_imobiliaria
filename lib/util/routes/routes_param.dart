class RouteParams {
  final String? nome;
  final String? id;

  RouteParams({this.nome, this.id});

  factory RouteParams.fromRoute(String route) {
    final nomeRegExp = RegExp(r'/corretor/([^/]+)/?');
    final idRegExp = RegExp(r'/imoveis/([^/]+)/?');

    final nomeMatch = nomeRegExp.firstMatch(route);
    final idMatch = idRegExp.firstMatch(route);

    final nome = nomeMatch != null ? nomeMatch.group(1) : null;
    final id = idMatch != null ? idMatch.group(1) : null;

    return RouteParams(nome: nome, id: id);
  }
}