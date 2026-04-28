import 'package:equatable/equatable.dart';

enum Specialty {
  textiles('Textiles'),
  ceramica('Cerámica'),
  joyeria('Joyería'),
  madera('Madera Tallada'),
  pintura('Pintura');

  final String label;
  const Specialty(this.label);
}

class ArtisanEntity extends Equatable {
  final int id;
  final String name;
  final String community;
  final Specialty specialty;
  final int yearsOfExperience;
  final String photoUrl;
  final String biography;

  const ArtisanEntity({
    required this.id,
    required this.name,
    required this.community,
    required this.specialty,
    required this.yearsOfExperience,
    required this.photoUrl,
    required this.biography,
  });

  bool get isMaster => yearsOfExperience >= 10;

  String get title {
    if (yearsOfExperience >= 20) return 'Gran Maestro Artesano';
    if (yearsOfExperience >= 10) return 'Maestro Artesano';
    if (yearsOfExperience >= 5) return 'Artesano Experimentado';
    return 'Artesano';
  }

  @override
  List<Object?> get props =>
      [id, name, community, specialty, yearsOfExperience];
}
