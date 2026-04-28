// ============================================================================
//  test/features/products/product_repository_mock_test.dart
//
//  PRUEBAS UNITARIAS — ProductModel, ProductRepositoryMock, ProductEntity
//  Ejecutar con: flutter test test/features/products/product_repository_mock_test.dart -v
// ============================================================================

import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';

import 'package:artesanias_andinas/core/errors/failures.dart';
import 'package:artesanias_andinas/features/products/data/models/product_model.dart';
import 'package:artesanias_andinas/features/products/data/repositories/product_repository_mock.dart';
import 'package:artesanias_andinas/features/products/domain/entities/product_entity.dart';

void main() {
  // ── Datos de prueba reutilizables ────────────────────────────────────────
  const tProductJson = {
    'id': 1,
    'title': 'Manta Qero Tradicional',
    'description': 'Manta tejida a mano con lana de alpaca.',
    'price': 180.0,
    'category': 'textiles',
    'image': 'https://picsum.photos/seed/manta/400/400',
    'stock': 12,
    'artisan': 'María Quispe Mamani',
    'origin': "Q'ero, Paucartambo",
  };

  const tProductMap = {
    'id': 1,
    'name': 'Manta Qero Tradicional',
    'description': 'Manta tejida a mano con lana de alpaca.',
    'price': 180.0,
    'category': 'textiles',
    'imageUrl': 'https://picsum.photos/seed/manta/400/400',
    'stock': 12,
    'artisan': 'María Quispe Mamani',
    'origin': "Q'ero, Paucartambo",
  };

  const tEntity = ProductEntity(
    id: 1,
    name: 'Manta Qero Tradicional',
    description: 'Manta tejida a mano con lana de alpaca.',
    price: 180.0,
    category: ProductCategory.textiles,
    imageUrl: 'https://picsum.photos/seed/manta/400/400',
    stock: 12,
    artisan: 'María Quispe Mamani',
    origin: "Q'ero, Paucartambo",
  );

  // ════════════════════════════════════════════════════════════════════════
  // GRUPO 1: ProductModel — DTO
  // ════════════════════════════════════════════════════════════════════════
  group('ProductModel — DTO', () {
    test('fromJson() debe construir un ProductModel desde JSON de la API', () {
      // ARRANGE & ACT
      final model = ProductModel.fromJson(tProductJson);
      // ASSERT
      expect(model.id, equals(1));
      expect(model.name, equals('Manta Qero Tradicional'));
      expect(model.price, equals(180.0));
      expect(model.category, equals('textiles'));
    });

    test('fromJson() debe manejar el campo title como alias de name', () {
      final json = {'id': 2, 'title': 'Producto Test', 'price': 50.0};
      final model = ProductModel.fromJson(json);
      expect(model.name, equals('Producto Test'));
    });

    test('toJson() debe serializar correctamente el modelo', () {
      final model = ProductModel.fromJson(tProductJson);
      final json = model.toJson();
      expect(json['id'], equals(1));
      expect(json['name'], equals('Manta Qero Tradicional'));
      expect(json['price'], equals(180.0));
    });

    test('fromMap() debe construir un ProductModel desde mapa SQLite', () {
      final model = ProductModel.fromMap(tProductMap);
      expect(model.id, equals(1));
      expect(model.name, equals('Manta Qero Tradicional'));
      expect(model.stock, equals(12));
    });

    test('toMap() debe incluir todos los campos necesarios para SQLite', () {
      final model = ProductModel.fromMap(tProductMap);
      final map = model.toMap();
      expect(map.containsKey('id'), isTrue);
      expect(map.containsKey('name'), isTrue);
      expect(map.containsKey('price'), isTrue);
      expect(map.containsKey('cachedAt'), isTrue);
    });

    test('toEntity() debe convertir el modelo en una ProductEntity válida', () {
      final model = ProductModel.fromMap(tProductMap);
      final entity = model.toEntity();
      expect(entity, isA<ProductEntity>());
      expect(entity.id, equals(1));
      expect(entity.category, equals(ProductCategory.textiles));
    });

    test('fromEntity() debe crear un modelo desde una entidad del dominio', () {
      final model = ProductModel.fromEntity(tEntity);
      expect(model.id, equals(tEntity.id));
      expect(model.name, equals(tEntity.name));
      expect(model.category, equals('textiles'));
    });

    test('categorías de la API deben mapearse al enum del dominio', () {
      final modelJewelery = ProductModel.fromJson(
          {'id': 1, 'category': 'jewelery', 'price': 10.0});
      final modelElectronics = ProductModel.fromJson(
          {'id': 2, 'category': 'electronics', 'price': 10.0});
      final modelMensClothing = ProductModel.fromJson(
          {'id': 3, 'category': "men's clothing", 'price': 10.0});

      expect(
          modelJewelery.toEntity().category, equals(ProductCategory.joyeria));
      expect(modelElectronics.toEntity().category,
          equals(ProductCategory.ceramica));
      expect(modelMensClothing.toEntity().category,
          equals(ProductCategory.textiles));
    });
  });

  // ════════════════════════════════════════════════════════════════════════
  // GRUPO 2: ProductRepositoryMock — Contrato
  // ════════════════════════════════════════════════════════════════════════
  group('ProductRepositoryMock — Contrato', () {
    late ProductRepositoryMock repository;

    setUp(() {
      repository = ProductRepositoryMock();
    });

    test('getProducts() debe retornar Right con lista de productos', () async {
      // ACT
      final result = await repository.getProducts();
      // ASSERT
      expect(result.isRight(), isTrue);
    });

    test('getProducts() debe retornar 12 productos', () async {
      final result = await repository.getProducts();
      final products = result.getOrElse(() => []);
      expect(products.length, equals(12));
    });

    test('los productos retornados deben ser instancias de ProductEntity',
        () async {
      final result = await repository.getProducts();
      final products = result.getOrElse(() => []);
      expect(products.first, isA<ProductEntity>());
    });

    test('getProductById() con id existente debe retornar Right', () async {
      final result = await repository.getProductById(1);
      expect(result.isRight(), isTrue);
      final product = result.getOrElse(() => throw Exception());
      expect(product.id, equals(1));
    });

    test(
        'getProductById() con id inexistente debe retornar Left(NotFoundFailure)',
        () async {
      final result = await repository.getProductById(999);
      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure, isA<NotFoundFailure>()),
        (_) => fail('Debería retornar Left'),
      );
    });

    test('searchProducts() debe retornar coincidencias por nombre', () async {
      final result = await repository.searchProducts('Manta');
      final products = result.getOrElse(() => []);
      expect(products.isNotEmpty, isTrue);
      expect(products.first.name.toLowerCase().contains('manta'), isTrue);
    });

    test('searchProducts() debe retornar coincidencias por artesano', () async {
      final result = await repository.searchProducts('María');
      final products = result.getOrElse(() => []);
      expect(products.isNotEmpty, isTrue);
    });

    test('searchProducts() debe retornar lista vacía para query sin resultados',
        () async {
      final result = await repository.searchProducts('xyzabc123');
      final products = result.getOrElse(() => []);
      expect(products.isEmpty, isTrue);
    });

    test('getProductsByCategory() debe filtrar por categoría textiles',
        () async {
      final result =
          await repository.getProductsByCategory(ProductCategory.textiles);
      final products = result.getOrElse(() => []);
      expect(products.isNotEmpty, isTrue);
      expect(products.every((p) => p.category == ProductCategory.textiles),
          isTrue);
    });

    test('cacheProducts() debe retornar Right sin errores', () async {
      final result = await repository.cacheProducts([tEntity]);
      expect(result.isRight(), isTrue);
    });
  });

  // ════════════════════════════════════════════════════════════════════════
  // GRUPO 3: ProductEntity — Reglas de Negocio
  // ════════════════════════════════════════════════════════════════════════
  group('ProductEntity — Reglas de Negocio', () {
    test('isAvailable debe ser true si stock > 0', () {
      expect(tEntity.isAvailable, isTrue);
    });

    test('isAvailable debe ser false si stock es 0', () {
      const sinStock = ProductEntity(
        id: 99,
        name: 'Sin stock',
        description: '',
        price: 10.0,
        category: ProductCategory.otro,
        imageUrl: '',
        stock: 0,
        artisan: '',
        origin: '',
      );
      expect(sinStock.isAvailable, isFalse);
    });

    test('isPremium debe ser true si precio > 200', () {
      const premium = ProductEntity(
        id: 99,
        name: 'Premium',
        description: '',
        price: 250.0,
        category: ProductCategory.pintura,
        imageUrl: '',
        stock: 1,
        artisan: '',
        origin: '',
      );
      expect(premium.isPremium, isTrue);
    });

    test('isPremium debe ser false si precio <= 200', () {
      expect(tEntity.isPremium, isFalse);
    });

    test('formattedPrice debe incluir el símbolo S/.', () {
      expect(tEntity.formattedPrice, contains('S/.'));
    });

    test('formattedPrice debe mostrar el precio con 2 decimales', () {
      expect(tEntity.formattedPrice, equals('S/. 180.00'));
    });
  });
}
