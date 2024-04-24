//Clase abstracta para el manejo de datos de usuario con fierbase



import '../models/models.dart';

abstract class UserRepository{


  //Metodo para cerrar sesion
  Future<void> signOut();
  //Metodo para obtener el usuario actual
  Future<UserModel?> getUser();
  //Metodo para guardar un usuario
  Future<void> saveUser(UserModel user);
  //Metodo para iniciar sesion
  Future<void> signInWithEmailAndPassword(String email, String password);
  //Metodo para registrarse
  Future<UserModel?> signUpWithEmailAndPassword(UserModel userModel, String password);
  //Metodo para obtner el ID del usuario actual
  String getUserId();



}