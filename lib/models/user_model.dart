enum TipoUsuario { aluno, colaborador, outro }

enum MoraSozinho { sim, nao, vezes }

enum Sexo { masculino, feminino, naoBinario, prefiroNaoInformar }

class UserModel {
  final String? id;
  final String? email;
  final String? senha;
  final TipoUsuario? tipoUsuario;
  final String? nome;
  final String? faixaEtaria;
  final String? profissao;
  final MoraSozinho? moraSozinho;
  final Sexo? sexo;
  final String? tempoDisponivel;
  final String? hobbies;

  const UserModel({
    this.id,
    this.email,
    this.senha,
    this.tipoUsuario,
    this.nome,
    this.faixaEtaria,
    this.profissao,
    this.moraSozinho,
    this.sexo,
    this.tempoDisponivel,
    this.hobbies,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'senha': senha,
      'tipoUsuario': tipoUsuario?.name,
      'nome': nome,
      'faixaEtaria': faixaEtaria,
      'profissao': profissao,
      'moraSozinho': moraSozinho?.name,
      'sexo': sexo?.name,
      'tempoDisponivel': tempoDisponivel,
      'hobbies': hobbies,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      email: map['email'],
      senha: map['senha'],
      tipoUsuario: map['tipoUsuario'] != null
          ? TipoUsuario.values.firstWhere(
              (e) => e.name == map['tipoUsuario'],
              orElse: () => TipoUsuario.outro,
            )
          : null,
      nome: map['nome'],
      faixaEtaria: map['faixaEtaria'],
      profissao: map['profissao'],
      moraSozinho: map['moraSozinho'] != null
          ? MoraSozinho.values.firstWhere(
              (e) => e.name == map['moraSozinho'],
              orElse: () => MoraSozinho.nao,
            )
          : null,
      sexo: map['sexo'] != null
          ? Sexo.values.firstWhere(
              (e) => e.name == map['sexo'],
              orElse: () => Sexo.prefiroNaoInformar,
            )
          : null,
      tempoDisponivel: map['tempoDisponivel'],
      hobbies: map['hobbies'],
    );
  }
  @override
  String toString() {
    return 'UserModel(id: $id, email: $email, nome: $nome, tipoUsuario: $tipoUsuario, faixaEtaria: $faixaEtaria, profissao: $profissao, moraSozinho: $moraSozinho, sexo: $sexo, tempoDisponivel: $tempoDisponivel, hobbies: $hobbies)';
  }
}
