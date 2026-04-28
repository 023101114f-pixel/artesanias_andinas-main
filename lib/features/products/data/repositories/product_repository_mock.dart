// ============================================================================
//  features/products/data/repositories/product_repository_mock.dart
//
//  REPOSITORIO MOCKEADO — Capa Data
//  Implementa ProductRepository con datos estáticos en memoria.
//  No necesita internet ni base de datos.
// ============================================================================

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';
import '../models/product_model.dart';

class ProductRepositoryMock implements ProductRepository {
  // ── 12 productos artesanales cusqueños (10 base + 2 propios) ─────────
  static final List<ProductModel> _mockProducts = [
    const ProductModel(
      id: 1,
      name: 'Manta Qero Tradicional',
      description: 'Manta tejida a mano con lana de alpaca en telar ancestral.',
      price: 180.0,
      category: 'textiles',
      imageUrl: 'https://picsum.photos/seed/manta/400/400',
      stock: 12,
      artisan: 'María Quispe Mamani',
      origin: "Q'ero, Paucartambo",
    ),
    const ProductModel(
      id: 2,
      name: 'Chuspa Bordada',
      description:
          'Bolsa ceremonial bordada con motivos andinos en hilo de alpaca.',
      price: 85.0,
      category: 'textiles',
      imageUrl: 'https://picsum.photos/seed/chuspa/400/400',
      stock: 20,
      artisan: 'Rosa Huanca Ttito',
      origin: 'Chinchero, Cusco',
    ),
    const ProductModel(
      id: 3,
      name: 'Toro de Pucará',
      description: 'Figura de cerámica pintada a mano, símbolo de prosperidad.',
      price: 120.0,
      category: 'ceramica',
      imageUrl: 'https://picsum.photos/seed/toro/400/400',
      stock: 8,
      artisan: 'Juan Ccama Flores',
      origin: 'Pucará, Puno',
    ),
    const ProductModel(
      id: 4,
      name: 'Retablo Ayacuchano',
      description: 'Caja de arte popular con escenas costumbristas andinas.',
      price: 250.0,
      category: 'madera',
      imageUrl: 'https://picsum.photos/seed/retablo/400/400',
      stock: 5,
      artisan: 'Pedro Sulca Quispe',
      origin: 'San Blas, Cusco',
    ),
    const ProductModel(
      id: 5,
      name: 'Aretes de Plata Inca',
      description:
          'Aretes de plata 950 con diseño de chakana y piedra turquesa.',
      price: 95.0,
      category: 'joyeria',
      imageUrl: 'https://picsum.photos/seed/aretes/400/400',
      stock: 30,
      artisan: 'Carmen Ttito Vargas',
      origin: 'Cusco Centro',
    ),
    const ProductModel(
      id: 6,
      name: 'Tapiz Chinchero',
      description:
          'Tapiz tejido en telar de cintura con tintes naturales de plantas.',
      price: 320.0,
      category: 'textiles',
      imageUrl: 'https://picsum.photos/seed/tapiz/400/400',
      stock: 4,
      artisan: 'Nilda Callañaupa',
      origin: 'Chinchero, Cusco',
    ),
    const ProductModel(
      id: 7,
      name: 'Máscara de Diablo',
      description: 'Máscara festiva tallada en madera policromada para danzas.',
      price: 145.0,
      category: 'madera',
      imageUrl: 'https://picsum.photos/seed/mascara/400/400',
      stock: 7,
      artisan: 'Eusebio Ccorimanya',
      origin: 'Pisac, Cusco',
    ),
    const ProductModel(
      id: 8,
      name: 'Pintura Escuela Cusqueña',
      description:
          'Óleo sobre lienzo con técnica de la Escuela Cusqueña colonial.',
      price: 480.0,
      category: 'pintura',
      imageUrl: 'https://picsum.photos/seed/pintura/400/400',
      stock: 2,
      artisan: 'Fortunato Ttito',
      origin: 'San Blas, Cusco',
    ),
    const ProductModel(
      id: 9,
      name: 'Collar de Semillas Amazónicas',
      description:
          'Collar artesanal con semillas naturales de la selva cusqueña.',
      price: 55.0,
      category: 'joyeria',
      imageUrl: 'https://picsum.photos/seed/collar/400/400',
      stock: 25,
      artisan: 'Luz Marina Ríos',
      origin: 'Pillcopata, Cusco',
    ),
    const ProductModel(
      id: 10,
      name: 'Vasija Inca Réplica',
      description:
          'Réplica de vasija inca en cerámica con pigmentos naturales.',
      price: 200.0,
      category: 'ceramica',
      imageUrl: 'https://picsum.photos/seed/vasija/400/400',
      stock: 9,
      artisan: 'Andrés Merma Quispe',
      origin: 'Ollantaytambo, Cusco',
    ),
    // ── 2 productos propios ───────────────────────────────────────────────
    const ProductModel(
      id: 11,
      name: 'Awayu Boliviano',
      description:
          'Tela cuadrada multicolor usada para cargar bebés y objetos.',
      price: 160.0,
      category: 'textiles',
      imageUrl: 'https://picsum.photos/seed/awayu/400/400',
      stock: 15,
      artisan: 'Felicitas Mamani Coaquira',
      origin: 'Desaguadero, Puno',
    ),
    const ProductModel(
      id: 12,
      name: 'Kero Ceremonial',
      description:
          'Vaso ceremonial inca tallado en madera con incrustaciones de nácar.',
      price: 390.0,
      category: 'madera',
      imageUrl: 'https://picsum.photos/seed/kero/400/400',
      stock: 3,
      artisan: 'Domingo Huallpa Quispe',
      origin: "Q'enqo, Cusco",
    ),
  ];

  // ── Implementación del contrato ───────────────────────────────────────

  @override
  Future<Either<Failure, List<ProductEntity>>> getProducts() async {
    // Simula latencia de red
    await Future.delayed(const Duration(milliseconds: 500));
    final entities = _mockProducts.map((m) => m.toEntity()).toList();
    return Right(entities);
  }

  @override
  Future<Either<Failure, ProductEntity>> getProductById(int id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      final model = _mockProducts.firstWhere((m) => m.id == id);
      return Right(model.toEntity());
    } catch (_) {
      return Left(NotFoundFailure(message: 'Producto #$id no encontrado'));
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> searchProducts(
      String query) async {
    await Future.delayed(const Duration(milliseconds: 400));
    if (query.trim().isEmpty) return const Right([]);
    final q = query.toLowerCase();
    final results = _mockProducts
        .where((m) =>
            m.name.toLowerCase().contains(q) ||
            m.description.toLowerCase().contains(q) ||
            m.artisan.toLowerCase().contains(q))
        .map((m) => m.toEntity())
        .toList();
    return Right(results);
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getProductsByCategory(
    ProductCategory category,
  ) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final results = _mockProducts
        .where((m) => m.toEntity().category == category)
        .map((m) => m.toEntity())
        .toList();
    return Right(results);
  }

  @override
  Future<Either<Failure, void>> cacheProducts(
    List<ProductEntity> products,
  ) async {
    // En el mock no hay caché real, simplemente retorna éxito
    return const Right(null);
  }
}
