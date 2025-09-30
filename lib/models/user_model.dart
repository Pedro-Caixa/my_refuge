<<<<<<< HEAD:lib/models/user_model.dart
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
=======
import 'package:cloud_firestore/cloud_firestore.dart';

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
  final DateTime? createdAt;
  final DateTime? updatedAt;

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
    this.createdAt,
    this.updatedAt,
  });

  UserModel copyWith({
    String? id,
    String? email,
    String? senha,
    TipoUsuario? tipoUsuario,
    String? nome,
    String? faixaEtaria,
    String? profissao,
    MoraSozinho? moraSozinho,
    Sexo? sexo,
    String? tempoDisponivel,
    String? hobbies,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      senha: senha ?? this.senha,
      tipoUsuario: tipoUsuario ?? this.tipoUsuario,
      nome: nome ?? this.nome,
      faixaEtaria: faixaEtaria ?? this.faixaEtaria,
      profissao: profissao ?? this.profissao,
      moraSozinho: moraSozinho ?? this.moraSozinho,
      sexo: sexo ?? this.sexo,
      tempoDisponivel: tempoDisponivel ?? this.tempoDisponivel,
      hobbies: hobbies ?? this.hobbies,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

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
      'createdAt': createdAt,
      'updatedAt': updatedAt,
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

      createdAt: map['createdAt'] != null
          ? (map['createdAt'] is Timestamp
                ? (map['createdAt'] as Timestamp).toDate()
                : map['createdAt'] as DateTime?)
          : null,
      updatedAt: map['updatedAt'] != null
          ? (map['updatedAt'] is Timestamp
                ? (map['updatedAt'] as Timestamp).toDate()
                : map['updatedAt'] as DateTime?)
          : null,
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, email: $email, nome: $nome, tipoUsuario: $tipoUsuario, faixaEtaria: $faixaEtaria, profissao: $profissao, moraSozinho: $moraSozinho, sexo: $sexo, tempoDisponivel: $tempoDisponivel, hobbies: $hobbies, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}
>>>>>>> main:lib/models/userModel.dart
