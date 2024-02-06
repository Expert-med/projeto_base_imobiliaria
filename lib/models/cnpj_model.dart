class CNPJModel {
  String? cnpjRaiz;
  String? razaoSocial;
  String? capitalSocial;
  String? responsavelFederativo;
  String? atualizadoEm;
  Porte? porte;
  Porte? naturezaJuridica;
  QualificacaoDoResponsavel? qualificacaoDoResponsavel;
  List<Socios>? socios;
  Simples? simples;
  Estabelecimento? estabelecimento;

  CNPJModel(
      {this.cnpjRaiz,
      this.razaoSocial,
      this.capitalSocial,
      this.responsavelFederativo,
      this.atualizadoEm,
      this.porte,
      this.naturezaJuridica,
      this.qualificacaoDoResponsavel,
      this.socios,
      this.simples,
      this.estabelecimento});

  CNPJModel.fromJson(Map<String, dynamic> json) {
    cnpjRaiz = json['cnpj_raiz'];
    razaoSocial = json['razao_social'];
    capitalSocial = json['capital_social'];
    responsavelFederativo = json['responsavel_federativo'];
    atualizadoEm = json['atualizado_em'];
    porte = json['porte'] != null ? new Porte.fromJson(json['porte']) : null;
    naturezaJuridica = json['natureza_juridica'] != null
        ? new Porte.fromJson(json['natureza_juridica'])
        : null;
    qualificacaoDoResponsavel = json['qualificacao_do_responsavel'] != null
        ? new QualificacaoDoResponsavel.fromJson(
            json['qualificacao_do_responsavel'])
        : null;
    if (json['socios'] != null) {
      socios = <Socios>[];
      json['socios'].forEach((v) {
        socios!.add(new Socios.fromJson(v));
      });
    }
    simples =
        json['simples'] != null ? new Simples.fromJson(json['simples']) : null;
    estabelecimento = json['estabelecimento'] != null
        ? new Estabelecimento.fromJson(json['estabelecimento'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cnpj_raiz'] = this.cnpjRaiz;
    data['razao_social'] = this.razaoSocial;
    data['capital_social'] = this.capitalSocial;
    data['responsavel_federativo'] = this.responsavelFederativo;
    data['atualizado_em'] = this.atualizadoEm;
    if (this.porte != null) {
      data['porte'] = this.porte!.toJson();
    }
    if (this.naturezaJuridica != null) {
      data['natureza_juridica'] = this.naturezaJuridica!.toJson();
    }
    if (this.qualificacaoDoResponsavel != null) {
      data['qualificacao_do_responsavel'] =
          this.qualificacaoDoResponsavel!.toJson();
    }
    if (this.socios != null) {
      data['socios'] = this.socios!.map((v) => v.toJson()).toList();
    }
    if (this.simples != null) {
      data['simples'] = this.simples!.toJson();
    }
    if (this.estabelecimento != null) {
      data['estabelecimento'] = this.estabelecimento!.toJson();
    }
    return data;
  }
}

class Porte {
  String? id;
  String? descricao;

  Porte({this.id, this.descricao});

  Porte.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    descricao = json['descricao'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['descricao'] = this.descricao;
    return data;
  }
}

class QualificacaoDoResponsavel {
  int? id;
  String? descricao;

  QualificacaoDoResponsavel({this.id, this.descricao});

  QualificacaoDoResponsavel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    descricao = json['descricao'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['descricao'] = this.descricao;
    return data;
  }
}

class Socios {
  String? cpfCnpjSocio;
  String? nome;
  String? tipo;
  String? dataEntrada;
  String? cpfRepresentanteLegal;
  Null? nomeRepresentante;
  String? faixaEtaria;
  String? atualizadoEm;
  String? paisId;
  QualificacaoDoResponsavel? qualificacaoSocio;
  Null? qualificacaoRepresentante;
  Pais? pais;

  Socios(
      {this.cpfCnpjSocio,
      this.nome,
      this.tipo,
      this.dataEntrada,
      this.cpfRepresentanteLegal,
      this.nomeRepresentante,
      this.faixaEtaria,
      this.atualizadoEm,
      this.paisId,
      this.qualificacaoSocio,
      this.qualificacaoRepresentante,
      this.pais});

  Socios.fromJson(Map<String, dynamic> json) {
    cpfCnpjSocio = json['cpf_cnpj_socio'];
    nome = json['nome'];
    tipo = json['tipo'];
    dataEntrada = json['data_entrada'];
    cpfRepresentanteLegal = json['cpf_representante_legal'];
    nomeRepresentante = json['nome_representante'];
    faixaEtaria = json['faixa_etaria'];
    atualizadoEm = json['atualizado_em'];
    paisId = json['pais_id'];
    qualificacaoSocio = json['qualificacao_socio'] != null
        ? new QualificacaoDoResponsavel.fromJson(json['qualificacao_socio'])
        : null;
    qualificacaoRepresentante = json['qualificacao_representante'];
    pais = json['pais'] != null ? new Pais.fromJson(json['pais']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cpf_cnpj_socio'] = this.cpfCnpjSocio;
    data['nome'] = this.nome;
    data['tipo'] = this.tipo;
    data['data_entrada'] = this.dataEntrada;
    data['cpf_representante_legal'] = this.cpfRepresentanteLegal;
    data['nome_representante'] = this.nomeRepresentante;
    data['faixa_etaria'] = this.faixaEtaria;
    data['atualizado_em'] = this.atualizadoEm;
    data['pais_id'] = this.paisId;
    if (this.qualificacaoSocio != null) {
      data['qualificacao_socio'] = this.qualificacaoSocio!.toJson();
    }
    data['qualificacao_representante'] = this.qualificacaoRepresentante;
    if (this.pais != null) {
      data['pais'] = this.pais!.toJson();
    }
    return data;
  }
}

class Pais {
  String? id;
  String? iso2;
  String? iso3;
  String? nome;
  String? comexId;

  Pais({this.id, this.iso2, this.iso3, this.nome, this.comexId});

  Pais.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    iso2 = json['iso2'];
    iso3 = json['iso3'];
    nome = json['nome'];
    comexId = json['comex_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['iso2'] = this.iso2;
    data['iso3'] = this.iso3;
    data['nome'] = this.nome;
    data['comex_id'] = this.comexId;
    return data;
  }
}

class Simples {
  String? simples;
  String? dataOpcaoSimples;
  Null? dataExclusaoSimples;
  String? mei;
  Null? dataOpcaoMei;
  Null? dataExclusaoMei;
  String? atualizadoEm;

  Simples(
      {this.simples,
      this.dataOpcaoSimples,
      this.dataExclusaoSimples,
      this.mei,
      this.dataOpcaoMei,
      this.dataExclusaoMei,
      this.atualizadoEm});

  Simples.fromJson(Map<String, dynamic> json) {
    simples = json['simples'];
    dataOpcaoSimples = json['data_opcao_simples'];
    dataExclusaoSimples = json['data_exclusao_simples'];
    mei = json['mei'];
    dataOpcaoMei = json['data_opcao_mei'];
    dataExclusaoMei = json['data_exclusao_mei'];
    atualizadoEm = json['atualizado_em'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['simples'] = this.simples;
    data['data_opcao_simples'] = this.dataOpcaoSimples;
    data['data_exclusao_simples'] = this.dataExclusaoSimples;
    data['mei'] = this.mei;
    data['data_opcao_mei'] = this.dataOpcaoMei;
    data['data_exclusao_mei'] = this.dataExclusaoMei;
    data['atualizado_em'] = this.atualizadoEm;
    return data;
  }
}

class Estabelecimento {
  String? cnpj;
  List<AtividadesSecundarias>? atividadesSecundarias;
  String? cnpjRaiz;
  String? cnpjOrdem;
  String? cnpjDigitoVerificador;
  String? tipo;
  String? nomeFantasia;
  String? situacaoCadastral;
  String? dataSituacaoCadastral;
  String? dataInicioAtividade;
  Null? nomeCidadeExterior;
  String? tipoLogradouro;
  String? logradouro;
  String? numero;
  String? complemento;
  String? bairro;
  String? cep;
  String? ddd1;
  String? telefone1;
  Null? ddd2;
  Null? telefone2;
  Null? dddFax;
  Null? fax;
  String? email;
  Null? situacaoEspecial;
  Null? dataSituacaoEspecial;
  String? atualizadoEm;
  AtividadesSecundarias? atividadePrincipal;
  Pais? pais;
  Estado? estado;
  Cidade? cidade;
  Null? motivoSituacaoCadastral;
  List<InscricoesEstaduais>? inscricoesEstaduais;

  Estabelecimento(
      {this.cnpj,
      this.atividadesSecundarias,
      this.cnpjRaiz,
      this.cnpjOrdem,
      this.cnpjDigitoVerificador,
      this.tipo,
      this.nomeFantasia,
      this.situacaoCadastral,
      this.dataSituacaoCadastral,
      this.dataInicioAtividade,
      this.nomeCidadeExterior,
      this.tipoLogradouro,
      this.logradouro,
      this.numero,
      this.complemento,
      this.bairro,
      this.cep,
      this.ddd1,
      this.telefone1,
      this.ddd2,
      this.telefone2,
      this.dddFax,
      this.fax,
      this.email,
      this.situacaoEspecial,
      this.dataSituacaoEspecial,
      this.atualizadoEm,
      this.atividadePrincipal,
      this.pais,
      this.estado,
      this.cidade,
      this.motivoSituacaoCadastral,
      this.inscricoesEstaduais});

  Estabelecimento.fromJson(Map<String, dynamic> json) {
    cnpj = json['cnpj'];
    if (json['atividades_secundarias'] != null) {
      atividadesSecundarias = <AtividadesSecundarias>[];
      json['atividades_secundarias'].forEach((v) {
        atividadesSecundarias!.add(new AtividadesSecundarias.fromJson(v));
      });
    }
    cnpjRaiz = json['cnpj_raiz'];
    cnpjOrdem = json['cnpj_ordem'];
    cnpjDigitoVerificador = json['cnpj_digito_verificador'];
    tipo = json['tipo'];
    nomeFantasia = json['nome_fantasia'];
    situacaoCadastral = json['situacao_cadastral'];
    dataSituacaoCadastral = json['data_situacao_cadastral'];
    dataInicioAtividade = json['data_inicio_atividade'];
    nomeCidadeExterior = json['nome_cidade_exterior'];
    tipoLogradouro = json['tipo_logradouro'];
    logradouro = json['logradouro'];
    numero = json['numero'];
    complemento = json['complemento'];
    bairro = json['bairro'];
    cep = json['cep'];
    ddd1 = json['ddd1'];
    telefone1 = json['telefone1'];
    ddd2 = json['ddd2'];
    telefone2 = json['telefone2'];
    dddFax = json['ddd_fax'];
    fax = json['fax'];
    email = json['email'];
    situacaoEspecial = json['situacao_especial'];
    dataSituacaoEspecial = json['data_situacao_especial'];
    atualizadoEm = json['atualizado_em'];
    atividadePrincipal = json['atividade_principal'] != null
        ? new AtividadesSecundarias.fromJson(json['atividade_principal'])
        : null;
    pais = json['pais'] != null ? new Pais.fromJson(json['pais']) : null;
    estado =
        json['estado'] != null ? new Estado.fromJson(json['estado']) : null;
    cidade =
        json['cidade'] != null ? new Cidade.fromJson(json['cidade']) : null;
    motivoSituacaoCadastral = json['motivo_situacao_cadastral'];
    if (json['inscricoes_estaduais'] != null) {
      inscricoesEstaduais = <InscricoesEstaduais>[];
      json['inscricoes_estaduais'].forEach((v) {
        inscricoesEstaduais!.add(new InscricoesEstaduais.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cnpj'] = this.cnpj;
    if (this.atividadesSecundarias != null) {
      data['atividades_secundarias'] =
          this.atividadesSecundarias!.map((v) => v.toJson()).toList();
    }
    data['cnpj_raiz'] = this.cnpjRaiz;
    data['cnpj_ordem'] = this.cnpjOrdem;
    data['cnpj_digito_verificador'] = this.cnpjDigitoVerificador;
    data['tipo'] = this.tipo;
    data['nome_fantasia'] = this.nomeFantasia;
    data['situacao_cadastral'] = this.situacaoCadastral;
    data['data_situacao_cadastral'] = this.dataSituacaoCadastral;
    data['data_inicio_atividade'] = this.dataInicioAtividade;
    data['nome_cidade_exterior'] = this.nomeCidadeExterior;
    data['tipo_logradouro'] = this.tipoLogradouro;
    data['logradouro'] = this.logradouro;
    data['numero'] = this.numero;
    data['complemento'] = this.complemento;
    data['bairro'] = this.bairro;
    data['cep'] = this.cep;
    data['ddd1'] = this.ddd1;
    data['telefone1'] = this.telefone1;
    data['ddd2'] = this.ddd2;
    data['telefone2'] = this.telefone2;
    data['ddd_fax'] = this.dddFax;
    data['fax'] = this.fax;
    data['email'] = this.email;
    data['situacao_especial'] = this.situacaoEspecial;
    data['data_situacao_especial'] = this.dataSituacaoEspecial;
    data['atualizado_em'] = this.atualizadoEm;
    if (this.atividadePrincipal != null) {
      data['atividade_principal'] = this.atividadePrincipal!.toJson();
    }
    if (this.pais != null) {
      data['pais'] = this.pais!.toJson();
    }
    if (this.estado != null) {
      data['estado'] = this.estado!.toJson();
    }
    if (this.cidade != null) {
      data['cidade'] = this.cidade!.toJson();
    }
    data['motivo_situacao_cadastral'] = this.motivoSituacaoCadastral;
    if (this.inscricoesEstaduais != null) {
      data['inscricoes_estaduais'] =
          this.inscricoesEstaduais!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AtividadesSecundarias {
  String? id;
  String? secao;
  String? divisao;
  String? grupo;
  String? classe;
  String? subclasse;
  String? descricao;

  AtividadesSecundarias(
      {this.id,
      this.secao,
      this.divisao,
      this.grupo,
      this.classe,
      this.subclasse,
      this.descricao});

  AtividadesSecundarias.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    secao = json['secao'];
    divisao = json['divisao'];
    grupo = json['grupo'];
    classe = json['classe'];
    subclasse = json['subclasse'];
    descricao = json['descricao'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['secao'] = this.secao;
    data['divisao'] = this.divisao;
    data['grupo'] = this.grupo;
    data['classe'] = this.classe;
    data['subclasse'] = this.subclasse;
    data['descricao'] = this.descricao;
    return data;
  }
}

class Estado {
  int? id;
  String? nome;
  String? sigla;
  int? ibgeId;

  Estado({this.id, this.nome, this.sigla, this.ibgeId});

  Estado.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    sigla = json['sigla'];
    ibgeId = json['ibge_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nome'] = this.nome;
    data['sigla'] = this.sigla;
    data['ibge_id'] = this.ibgeId;
    return data;
  }
}

class Cidade {
  int? id;
  String? nome;
  int? ibgeId;
  String? siafiId;

  Cidade({this.id, this.nome, this.ibgeId, this.siafiId});

  Cidade.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    ibgeId = json['ibge_id'];
    siafiId = json['siafi_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nome'] = this.nome;
    data['ibge_id'] = this.ibgeId;
    data['siafi_id'] = this.siafiId;
    return data;
  }
}

class InscricoesEstaduais {
  String? inscricaoEstadual;
  bool? ativo;
  String? atualizadoEm;
  Estado? estado;

  InscricoesEstaduais(
      {this.inscricaoEstadual, this.ativo, this.atualizadoEm, this.estado});

  InscricoesEstaduais.fromJson(Map<String, dynamic> json) {
    inscricaoEstadual = json['inscricao_estadual'];
    ativo = json['ativo'];
    atualizadoEm = json['atualizado_em'];
    estado =
        json['estado'] != null ? new Estado.fromJson(json['estado']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['inscricao_estadual'] = this.inscricaoEstadual;
    data['ativo'] = this.ativo;
    data['atualizado_em'] = this.atualizadoEm;
    if (this.estado != null) {
      data['estado'] = this.estado!.toJson();
    }
    return data;
  }
}
