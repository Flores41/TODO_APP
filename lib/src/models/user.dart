//Entidades de usuario para el manejo de datos con firebase

// UserEntity
class UserEntity {
  String id;
  String email;
  String username;

//Crear el constructor de la clase
  UserEntity({
    required this.id,
    required this.email,
    required this.username,
  });

  //Mapear los datos de firebase a la clase
  factory UserEntity.fromMap(
    Map<String, dynamic> data,
  ) {
    return UserEntity(
      id: data['id'],
      email: data['email'],
      username: data['username'],
    );
  }
  // Mapear los datos de la clase a firebase
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'username': username,
    };
  }
}

// UserModel
class UserModel {
  String id;
  String email;
  String username;

  UserModel({
    required this.id,
    required this.email,
    required this.username,
  });
  // Mapear los datos de la clase a la entidad
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      email: email,
      username: username,
    );
  }

//  Mapear los datos de la entidad a la clase
  static UserModel fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      email: entity.email,
      username: entity.username,
    );
  }

  // Crear un usuario vacio
  static UserModel empty = UserModel(
    id: '',
    email: '',
    username: '',
  );
}
