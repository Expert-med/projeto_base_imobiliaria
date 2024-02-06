import 'package:cloud_firestore/cloud_firestore.dart';

class NotificacaoService{

  Future<void> adicionarNotificacao(
    String titulo, String descricao, int parametro,DocumentReference hospitalDoc) async {
  try {
    // Obtém o último id_gerado de "notificacoes"
    QuerySnapshot notificacoesSnapshot = await hospitalDoc
        .collection("notificacoes")
        .orderBy("id", descending: true)
        .limit(1)
        .get();

    int ultimoIdGerado = 1;
    if (notificacoesSnapshot.docs.isNotEmpty) {
      ultimoIdGerado = (notificacoesSnapshot.docs[0]["id"] as int) + 1;
    }

    DateTime now = DateTime.now();

    // Converte a data e hora para uma string no formato desejado
    String dataHoraAtual = "${now.toLocal()}".split('.')[0];

    // Adiciona uma notificação à coleção "notificacoes" com o id_gerado apropriado
    await hospitalDoc
        .collection("notificacoes")
        .doc(ultimoIdGerado.toString()) // Converte para string se necessário
        .set({
      "data_hora": dataHoraAtual,
      "id": ultimoIdGerado,
      "parametro": parametro,
      "titulo": titulo,
      "descricao": descricao,
      "leu": 0,
    });

   

    print("Notificação adicionada com sucesso");
  } catch (error) {
    // Verifica se o widget ainda está montado antes de imprimir o erro
  
      print("Erro ao adicionar notificação: $error");
 
  }
}


}