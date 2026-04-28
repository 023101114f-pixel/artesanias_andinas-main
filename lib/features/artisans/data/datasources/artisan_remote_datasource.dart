import 'package:dio/dio.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/artisan_model.dart';

abstract class ArtisanRemoteDataSource {
  Future<List<ArtisanModel>> getArtisans();
  Future<ArtisanModel> getArtisanById(int id);
}

class ArtisanRemoteDataSourceImpl implements ArtisanRemoteDataSource {
  final Dio client;

  const ArtisanRemoteDataSourceImpl({required this.client});

  @override
  Future<List<ArtisanModel>> getArtisans() async {
    try {
      final response = await client.get('/users');
      return (response.data as List)
          .map((json) => ArtisanModel.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Error al obtener artesanos',
      );
    }
  }

  @override
  Future<ArtisanModel> getArtisanById(int id) async {
    try {
      final response = await client.get('/users/$id');
      return ArtisanModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Error al obtener artesano',
      );
    }
  }
}
