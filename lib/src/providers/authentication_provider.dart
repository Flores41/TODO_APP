import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:todo_list_app/src/models/models.dart';

import '../services/services.dart';

//crear una enumeracion de estados
enum AuthState { authenticated, unauthenticated, loading }

class AuthenticacionProvider extends ChangeNotifier {
  //Creacion del provider hacieno uso de nuestra clase UserRepoFirebase
  final _userRepo = UserRepoFirebase();
  //Variable para el estado de la autenticacion
  AuthState _authState = AuthState.loading;
  AuthState get getauthState => _authState;

  bool _isLoading = false;
  bool get getisLoading => _isLoading;

  //!Simulacion de carga de 2 segundos antes de cambiar el estado
  Future<void> init() async {
    await Future.delayed(const Duration(seconds: 2));
    notifyListeners();
  }

  //! Método para establecer el estado de carga
  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  //!Metodo para iniciar sesion
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      //Establecer el estado de carga
      setLoading(true);
      //Establecer el estado de autenticacion
      _authState = AuthState.loading;
      notifyListeners();
      //Simulacion de carga de 2 segundos antes de cambiar el estado
      await init(); 
      //Iniciar sesion con email y contraseña
      await _userRepo.signInWithEmailAndPassword(email, password);
      _authState = AuthState.authenticated;
      notifyListeners();
    } catch (e) {
      //Imprimir el error
      log(e.toString());
      _authState = AuthState.unauthenticated;
      notifyListeners();
      //Relanzar el error
      rethrow;
    } finally {
      setLoading(false);
    }
  }

  //!Metodo para registrarse  y guardar un usuario
  Future<UserModel?> signUpWithEmailAndPassword(
      UserModel userModel, String password) async {
    try {
      //Establecer el estado de carga
      setLoading(true);
      //Establecer el estado de autenticacion
      _authState = AuthState.loading;
      notifyListeners();
      await init();
      //Registrarse con email y contraseña
      final user =
          await _userRepo.signUpWithEmailAndPassword(userModel, password);
      //Guardar el usuario
      await _userRepo.saveUser(user);
      //Retornar el usuario
      return user;
    } catch (e) {
      //Imprimir el error
      log(e.toString());
      //Relanzar el error
      rethrow;
    } finally {
      setLoading(false);
    }
  }

  //!Metodo para cerrar sesion
  Future<void> signOut() async {
    try {
      //Cerrar sesion
      await _userRepo.signOut();
    } catch (e) {
      //Imprimir el error
      log(e.toString());
      //Relanzar el error
      rethrow;
    }
  }

  //!Metodo para obtener el usuario actual
  Future<UserModel?> getUser() async {
    try {
      //Obtener el usuario actual
      return await _userRepo.getUser();
    } catch (e) {
      //Imprimir el error
      log(e.toString());
      //Relanzar el error
      rethrow;
    }
  }
  
    //Metodo para obtner el ID del usuario actual
  String? getUserId()  {
    try {
      //Obtener el ID del usuario actual
      return  _userRepo.getUserId();
    } catch (e) {
      //Imprimir el error
      log(e.toString());
      //Relanzar el error
      rethrow;
    }
  }
 
}


 // //Metodo para verficar si el usuario esta autenticado y ya no volver a iniciar sesion
  // Future<void> checkAuth() async {
  //   try {
  //     //Obtener el usuario actual
  //     final user = await _userRepo.getUser();
  //     //Verificar si el usuario es diferente de nulo
  //     if (user != null) {
  //       //Establecer el estado de autenticacion
  //       _authState = AuthState.authenticated;
  //     } else {
  //       //Establecer el estado de autenticacion
  //       _authState = AuthState.unauthenticated;
  //     }
  //     notifyListeners();
  //   } catch (e) {
  //     //Imprimir el error
  //     log(e.toString());
  //     //Relanzar el error
  //     rethrow;
  //   }
  // }
