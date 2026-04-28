import '../../domain/entities/artisan_entity.dart';

class ArtisanModel {
  final int id;
  final String name;
  final String community;
  final Specialty specialty;
  final int yearsOfExperience;
  final String photoUrl;
  final String biography;

  const ArtisanModel({
    required this.id,
    required this.name,
    required this.community,
    required this.specialty,
    required this.yearsOfExperience,
    required this.photoUrl,
    required this.biography,
  });

  factory ArtisanModel.fromJson(Map<String, dynamic> json) {
    final specialties = Specialty.values;
    return ArtisanModel(
      id: json['id'] as int,
      name: '${json['name']['firstname']} ${json['name']['lastname']}',
      community: json['address']['city'] as String,
      specialty: specialties[json['id'] % specialties.length],
      yearsOfExperience: (json['id'] * 3) % 25 + 1,
      photoUrl: 'https://i.pravatar.cc/150?u=${json['id']}',
      biography: 'Artesano de ${json['address']['city']} especializado en '
          '${specialties[json['id'] % specialties.length].label}. '
          'Contacto: ${json['email']}',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'community': community,
        'specialty': specialty.index,
        'yearsOfExperience': yearsOfExperience,
        'photoUrl': photoUrl,
        'biography': biography,
      };

  ArtisanEntity toEntity() => ArtisanEntity(
        id: id,
        name: name,
        community: community,
        specialty: specialty,
        yearsOfExperience: yearsOfExperience,
        photoUrl: photoUrl,
        biography: biography,
      );
}
