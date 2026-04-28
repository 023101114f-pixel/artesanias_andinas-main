// ============================================================================
//  core/di/injection_container.dart
// ============================================================================
import '../../features/artisans/data/repositories/artisan_repository_mock.dart';

import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';

import '../network/dio_client.dart';
import '../database/app_database.dart';

// Features - Products
import '../../features/products/data/datasources/product_remote_datasource.dart';
import '../../features/products/data/datasources/product_local_datasource.dart';
import '../../features/products/data/repositories/product_repository_impl.dart';
import '../../features/products/data/repositories/product_repository_mock.dart'; // ← NUEVO
import '../../features/products/domain/repositories/product_repository.dart';
import '../../features/products/domain/usecases/get_products_usecase.dart';
import '../../features/products/domain/usecases/get_product_detail_usecase.dart';
import '../../features/products/domain/usecases/search_products_usecase.dart';

// Features - Favorites
import '../../features/favorites/data/datasources/favorite_local_datasource.dart';
import '../../features/favorites/data/repositories/favorite_repository_impl.dart';
import '../../features/favorites/domain/repositories/favorite_repository.dart';
import '../../features/favorites/domain/usecases/add_favorite_usecase.dart';
import '../../features/favorites/domain/usecases/remove_favorite_usecase.dart';
import '../../features/favorites/domain/usecases/get_favorites_usecase.dart';

// Features - Auth
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/logout_usecase.dart';
import '../../features/auth/domain/usecases/get_current_user_usecase.dart';

// Features - Artisans
import '../../features/artisans/data/datasources/artisan_remote_datasource.dart';
import '../../features/artisans/data/repositories/artisan_repository_impl.dart';
import '../../features/artisans/domain/repositories/artisan_repository.dart';
import '../../features/artisans/domain/usecases/get_artisans_usecase.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ══════════════════════════════════════════════════════════════════════════
  // CAPA EXTERNAL / INFRAESTRUCTURA
  // ══════════════════════════════════════════════════════════════════════════

  final database = await AppDatabase.getInstance();
  sl.registerSingleton<AppDatabase>(database);
  sl.registerLazySingleton<Dio>(() => DioClient.createDio());

  // ══════════════════════════════════════════════════════════════════════════
  // FEATURE: PRODUCTS
  // ══════════════════════════════════════════════════════════════════════════

  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(client: sl<Dio>()),
  );
  sl.registerLazySingleton<ProductLocalDataSource>(
    () => ProductLocalDataSourceImpl(database: sl<AppDatabase>()),
  );

  // ── MODO DESARROLLO: Mock activo (sin internet) ──────────────────────────
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryMock(), // ← Mock activado para Lab 10
  );

  // ── MODO PRODUCCIÓN: descomentar esto y comentar el Mock ─────────────────
  // sl.registerLazySingleton<ProductRepository>(
  //   () => ProductRepositoryImpl(
  //     remoteDataSource: sl<ProductRemoteDataSource>(),
  //     localDataSource: sl<ProductLocalDataSource>(),
  //   ),
  // );

  sl.registerFactory(
      () => GetProductsUseCase(repository: sl<ProductRepository>()));
  sl.registerFactory(
      () => GetProductDetailUseCase(repository: sl<ProductRepository>()));
  sl.registerFactory(
      () => SearchProductsUseCase(repository: sl<ProductRepository>()));

  // ══════════════════════════════════════════════════════════════════════════
  // FEATURE: FAVORITES
  // ══════════════════════════════════════════════════════════════════════════

  sl.registerLazySingleton<FavoriteLocalDataSource>(
    () => FavoriteLocalDataSourceImpl(database: sl<AppDatabase>()),
  );
  sl.registerLazySingleton<FavoriteRepository>(
    () => FavoriteRepositoryImpl(
      localDataSource: sl<FavoriteLocalDataSource>(),
    ),
  );
  sl.registerFactory(
      () => AddFavoriteUseCase(repository: sl<FavoriteRepository>()));
  sl.registerFactory(
      () => RemoveFavoriteUseCase(repository: sl<FavoriteRepository>()));
  sl.registerFactory(
      () => GetFavoritesUseCase(repository: sl<FavoriteRepository>()));

  // ══════════════════════════════════════════════════════════════════════════
  // FEATURE: AUTH
  // ══════════════════════════════════════════════════════════════════════════

  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(client: sl<Dio>()),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl<AuthRemoteDataSource>(),
    ),
  );
  sl.registerFactory(() => LoginUseCase(repository: sl<AuthRepository>()));
  sl.registerFactory(() => LogoutUseCase(repository: sl<AuthRepository>()));
  sl.registerFactory(
      () => GetCurrentUserUseCase(repository: sl<AuthRepository>()));

// ══════════════════════════════════════════════════════════════════════════
  // FEATURE: ARTISANS
  // ══════════════════════════════════════════════════════════════════════════

  sl.registerLazySingleton<ArtisanRemoteDataSource>(
    () => ArtisanRemoteDataSourceImpl(client: sl<Dio>()),
  );

  // ── MODO DESARROLLO: Mock activo ─────────────────────────────────────────
  sl.registerLazySingleton<ArtisanRepository>(
    () => ArtisanRepositoryMock(), // ← Mock activado para Lab 10
  );

  // ── MODO PRODUCCIÓN: descomentar esto y comentar el Mock ─────────────────
  // sl.registerLazySingleton<ArtisanRepository>(
  //   () => ArtisanRepositoryImpl(
  //       remoteDataSource: sl<ArtisanRemoteDataSource>()),
  // );

  sl.registerFactory(
    () => GetArtisansUseCase(repository: sl<ArtisanRepository>()),
  );
}
