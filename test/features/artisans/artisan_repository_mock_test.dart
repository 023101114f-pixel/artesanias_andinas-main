// ============================================================================
//  test/features/artisans/artisan_repository_mock_test.dart
//
//  PRUEBAS UNITARIAS — ArtisanRepositoryMock
//  Ejecutar con: flutter test test/features/artisans/artisan_repository_mock_test.dart -v
// ============================================================================

import 'package:flutter_test/flutter_test.dart';
import 'package:artesanias_andinas/core/errors/failures.dart';
import 'package:artesanias_andinas/features/artisans/data/repositories/artisan_repository_mock.dart';
import 'package:artesanias_andinas/features/artisans/domain/entities/artisan_entity.dart';

void main() {
  group('ArtisanRepositoryMock — Contrato', () {
    late ArtisanRepositoryMock repository;

    setUp(() {
      repository = ArtisanRepositoryMock();
    });

    test('getArtisans() debe retornar Right con lista de artesanos', () async {
      final result = await repository.getArtisans();
      expect(result.isRight(), isTrue);
    });

    test('getArtisans() debe retornar 5 artesanos', () async {
      final result = await repository.getArtisans();
      final artisans = result.getOrElse(() => []);
      expect(artisans.length, equals(5));
    });

    test('getArtisanById() con id existente debe retornar Right', () async {
      final result = await repository.getArtisanById(1);
      expect(result.isRight(), isTrue);
      final artisan = result.getOrElse(() => throw Exception());
      expect(artisan.id, equals(1));
    });

    test(
        'getArtisanById() con id inexistente debe retornar Left(NotFoundFailure)',
        () async {
      final result = await repository.getArtisanById(999);
      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure, isA<NotFoundFailure>()),
        (_) => fail('Debería retornar Left'),
      );
    });

    test('getArtisansBySpecialty() debe filtrar correctamente por especialidad',
        () async {
      final result =
          await repository.getArtisansBySpecialty(Specialty.textiles);
      final artisans = result.getOrElse(() => []);
      expect(artisans.isNotEmpty, isTrue);
      expect(artisans.every((a) => a.specialty == Specialty.textiles), isTrue);
    });
  });

  group('ArtisanEntity — Reglas de Negocio', () {
    test('isMaster debe ser true si yearsOfExperience >= 10', () {
      const artisan = ArtisanEntity(
        id: 1,
        name: 'Test',
        community: 'Cusco',
        specialty: Specialty.textiles,
        yearsOfExperience: 10,
        photoUrl: '',
        biography: '',
      );
      expect(artisan.isMaster, isTrue);
    });

    test('isMaster debe ser false si yearsOfExperience < 10', () {
      const artisan = ArtisanEntity(
        id: 2,
        name: 'Test',
        community: 'Cusco',
        specialty: Specialty.ceramica,
        yearsOfExperience: 5,
        photoUrl: '',
        biography: '',
      );
      expect(artisan.isMaster, isFalse);
    });

    test('title debe retornar Gran Maestro Artesano si experiencia >= 20', () {
      const artisan = ArtisanEntity(
        id: 3,
        name: 'Test',
        community: 'Cusco',
        specialty: Specialty.madera,
        yearsOfExperience: 25,
        photoUrl: '',
        biography: '',
      );
      expect(artisan.title, equals('Gran Maestro Artesano'));
    });
  });
}
