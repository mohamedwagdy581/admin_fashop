import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'login_states.dart';


class LoginCubit extends Cubit<LoginStates>
{
  LoginCubit() : super(LoginInitialState());

  static LoginCubit get(context) => BlocProvider.of(context);

  void userLogin (
  {
    required String email,
    required String password,
})
  {
    emit(LoginLoadingState());

    FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password).then((value)
    {
      emit(LoginSuccessState(value.user!.uid));
    }).catchError((error)
    {
      emit(LoginErrorState(error.toString()));
    });
  }


  // SignIn with Google
  final googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _user;

  GoogleSignInAccount get user => _user!;

  Future signInWithGoogle() async {
    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) return;

    _user = googleUser;
    final googleAuthentication = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      idToken: googleAuthentication.idToken,
      accessToken: googleAuthentication.accessToken,
    );

    await FirebaseAuth.instance.signInWithCredential(credential).then((value)
    {
      emit(LoginSuccessState(value.user!.uid));
      //emit(LoginWithGoogleSuccessState());
    }).catchError((error)
    {
      emit(LoginErrorState(error));
    });

  }

  IconData suffix = Icons.visibility_off_outlined;
  bool isPasswordShown = true;
  void changePasswordVisibility ()
  {
    isPasswordShown = !isPasswordShown;
    suffix = isPasswordShown ? Icons.visibility_off_outlined : Icons.visibility_outlined;
    emit(LoginChangePasswordVisibilityState());
  }


}