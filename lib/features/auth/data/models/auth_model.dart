// ============================================================================
//  features/auth/data/models/auth_model.dart
//
//  MODELO de autenticación — Capa Data
//  Serializa/deserializa la respuesta del servidor y convierte a AuthEntity.
// ============================================================================

import '../../domain/entities/auth_entity.dart';

class AuthModel {
  final String id;
  final String name;
  final String email;
  final String role;
  final String token;

  const AuthModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.token,
  });

  // ── Desde JSON de la API ────────────────────────────────────────────────
  factory AuthModel.fromJson(Map<String, dynamic> json) => AuthModel(
        id: json['id']?.toString() ?? '',
        name: json['username'] as String? ?? json['name'] as String? ?? '',
        email: json['email'] as String? ?? '',
        role: json['role'] as String? ?? 'customer',
        token: json['token'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'role': role,
        'token': token,
      };

  // ── Desde mapa SQLite ────────────────────────────────────────────────────
  factory AuthModel.fromMap(Map<String, dynamic> map) => AuthModel(
        id: map['id'] as String,
        name: map['name'] as String,
        email: map['email'] as String,
        role: map['role'] as String? ?? 'customer',
        token: map['token'] as String? ?? '',
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'email': email,
        'role': role,
        'token': token,
      };

  // ── Conversión al dominio ───────────────────────────────────────────────
  AuthEntity toEntity() => AuthEntity(
        id: id,
        name: name,
        email: email,
        role: _mapRole(role),
        token: token,
      );

  static UserRole _mapRole(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return UserRole.admin;
      case 'artisan':
      case 'artesano':
        return UserRole.artisan;
      default:
        return UserRole.customer;
    }
  }
}
