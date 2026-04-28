// ============================================================================
//  features/auth/presentation/controllers/auth_controller.dart
//
//  CONTROLADOR de autenticación.
//  Gestiona el estado de sesión del usuario usando Riverpod.
//  Los Use Cases son resueltos por get_it (Service Locator).
// ============================================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/auth_entity.dart';
import '../../domain/usecases/login_usecase.dart';

// Estado de la sesión: null = no autenticado, AuthEntity = autenticado
final authProvider =
    AsyncNotifierProvider<AuthController, AuthEntity?>(AuthController.new);

class AuthController extends AsyncNotifier<AuthEntity?> {
  late final LoginUseCase _login;
  late final LogoutUseCase _logout;
  late final GetCurrentUserUseCase _getCurrentUser;

  @override
  Future<AuthEntity?> build() async {
    _login = sl<LoginUseCase>();
    _logout = sl<LogoutUseCase>();
    _getCurrentUser = sl<GetCurrentUserUseCase>();

    // Verificar si hay sesión activa
    final result = await _getCurrentUser(NoParams());
    return result.fold((_) => null, (user) => user);
  }

  /// Inicia sesión y actualiza el estado
  Future<String?> login(String email, String password) async {
    state = const AsyncValue.loading();
    final result = await _login(LoginParams(email: email, password: password));
    return result.fold(
      (failure) {
        state = const AsyncValue.data(null);
        return failure.message; // retorna mensaje de error
      },
      (user) {
        state = AsyncValue.data(user);
        return null; // null = éxito
      },
    );
  }

  /// Cierra sesión
  Future<void> logout() async {
    await _logout(NoParams());
    state = const AsyncValue.data(null);
  }

  bool get isAuthenticated => state.valueOrNull != null;
}
