// ============================================================================
//  features/artisans/data/repositories/artisan_repository_mock.dart
//
//  REPOSITORIO MOCKEADO — Feature Artisans
//  5 artesanos de comunidades cusqueñas reales
// ============================================================================

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/artisan_entity.dart';
import '../../domain/repositories/artisan_repository.dart';
import '../models/artisan_model.dart';

class ArtisanRepositoryMock implements ArtisanRepository {
  static final List<ArtisanModel> _mockArtisans = [
    const ArtisanModel(
      id: 1,
      name: 'María Quispe Mamani',
      community: "Q'ero, Paucartambo",
      specialty: Specialty.textiles,
      yearsOfExperience: 22,
      photoUrl: 'https://i.pravatar.cc/150?u=1',
      biography:
          'Maestra tejedora de la nación Q\'ero, preserva técnicas ancestrales de telar de cintura con lana de alpaca y tintes naturales.',
    ),
    const ArtisanModel(
      id: 2,
      name: 'Juan Ccama Flores',
      community: 'Raqchi, Cusco',
      specialty: Specialty.ceramica,
      yearsOfExperience: 15,
      photoUrl: 'https://i.pravatar.cc/150?u=2',
      biography:
          'Ceramista de Raqchi especializado en réplicas de vasijas incas con técnicas prehispánicas y pigmentos minerales naturales.',
    ),
    const ArtisanModel(
      id: 3,
      name: 'Carmen Ttito Vargas',
      community: 'San Blas, Cusco',
      specialty: Specialty.joyeria,
      yearsOfExperience: 8,
      photoUrl: 'https://i.pravatar.cc/150?u=3',
      biography:
          'Joyera del barrio de San Blas, crea piezas en plata 950 con diseños de chakana y figuras de la cosmovisión andina.',
    ),
    const ArtisanModel(
      id: 4,
      name: 'Eusebio Ccorimanya',
      community: 'Pisac, Cusco',
      specialty: Specialty.madera,
      yearsOfExperience: 30,
      photoUrl: 'https://i.pravatar.cc/150?u=4',
      biography:
          'Gran maestro tallador de Pisac con más de 30 años creando máscaras ceremoniales y retablos para festividades andinas.',
    ),
    const ArtisanModel(
      id: 5,
      name: 'Fortunato Ttito Quispe',
      community: 'San Blas, Cusco',
      specialty: Specialty.pintura,
      yearsOfExperience: 18,
      photoUrl: 'https://i.pravatar.cc/150?u=5',
      biography:
          'Pintor de la Escuela Cusqueña, utiliza técnicas coloniales del siglo XVII combinadas con iconografía andina contemporánea.',
    ),
  ];

  @override
  Future<Either<Failure, List<ArtisanEntity>>> getArtisans() async {
    await Future.delayed(const Duration(milliseconds: 400));
    final entities = _mockArtisans.map((m) => m.toEntity()).toList();
    return Right(entities);
  }

  @override
  Future<Either<Failure, ArtisanEntity>> getArtisanById(int id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      final model = _mockArtisans.firstWhere((m) => m.id == id);
      return Right(model.toEntity());
    } catch (_) {
      return Left(NotFoundFailure(message: 'Artesano #$id no encontrado'));
    }
  }

  @override
  Future<Either<Failure, List<ArtisanEntity>>> getArtisansBySpecialty(
    Specialty specialty,
  ) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final results = _mockArtisans
        .where((m) => m.specialty == specialty)
        .map((m) => m.toEntity())
        .toList();
    return Right(results);
  }
}
