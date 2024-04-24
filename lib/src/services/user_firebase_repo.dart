//Creacion de la clase UserRepoFirebase la cual implementa UserRepository

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_list_app/src/models/user.dart';
import 'package:todo_list_app/src/services/services.dart';

class UserRepoFirebase implements UserRepository {
  //Crear instancia de FirebaseAuth
  final FirebaseAuth _firebaseAuth;
  //crear una coleccion en firestore
  final userCollection = FirebaseFirestore.instance.collection('users');

  UserRepoFirebase({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

//Metodo para guardar un usuario
  @override
  Future<void> saveUser(UserModel user) async {
    //Guardar el usuario en firestore
    try {
      //Guardar el usuario en firestore
      await userCollection.doc(user.id).set(user.toEntity().toMap());
    } catch (e) {
      //Imprimir el error
      log(e.toString());
      //Relanzar el error
      rethrow;
    }
  }

  //Metodo para iniciar sesion
  @override
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    //Iniciar sesion con email y contraseña
    try {
      //Iniciar sesion con email y contraseña
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      //Imprimir el error
      log(e.toString());
      //Relanzar el error
      rethrow;
    }
  }

  //Metodo para cerrar sesion
  @override
  Future<void> signOut() async {
    //Cerrar sesion
    try {
      //Cerrar sesion
      await _firebaseAuth.signOut();
    } catch (e) {
      //Imprimir el error
      log(e.toString());
      //Relanzar el error
      rethrow;
    }
  }

  //Metodo para registrarse
  @override
  Future<UserModel> signUpWithEmailAndPassword(
      UserModel userModel, String password) async {
    //Registrarse con email y contraseña
    try {
      //Registrarse con email y contraseña
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: userModel.email, password: password);
      //Asignar el id del usuario
      userModel.id = userCredential.user!.uid;
      //Guardar el usuario en firestore
      return userModel;
    } catch (e) {
      //Imprimir el error
      log(e.toString());
      //Relanzar el error
      rethrow;
    }
  }

//Metodo para obtener el usuario actual
  @override
  Future<UserModel?> getUser() async {
    //Obtener el usuario actual
    try {
      //Obtener el usuario actual
      final user = _firebaseAuth.currentUser;
      //Si el usuario es nulo retornar nulo
      if (user != null) {
        return null;
      }
      //Si el usuario no es nulo obtener los datos del usuario
      else {
        //Obtener los datos del usuario
        final userData = await userCollection.doc(user!.uid).get();
        //Si los datos existen retornar un UserModel
        if (userData.exists) {
          //Retornar un UserModel
          return UserModel.fromEntity(UserEntity.fromMap(userData.data()!));
        }
        //Si los datos no existen retornar nulo
        else {
          return null;
        }
      }
    } catch (e) {
      //Imprimir el error
      log(e.toString());
      //Relanzar el error
      rethrow;
    }
  }

  //Metodo para obtener el ID del usuario actual
  @override
  String getUserId() {
    //Obtener el ID del usuario actual
    try {
      //Obtener el ID del usuario actual
      return _firebaseAuth.currentUser!.uid;
    } catch (e) {
      //Imprimir el error
      log(e.toString());
      //Relanzar el error
      rethrow;
    }
  }
}
