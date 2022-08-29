
import 'package:admin_side_fashop/view/admin_screen.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


import '../../components/components.dart';
import '../../controller/cash_helper.dart';
import 'login_cubit/login_cubit.dart';
import 'login_cubit/login_states.dart';

// ignore: must_be_immutable
class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state)
        {
          // Listener in Login State if Error Show toast with error
          if(state is LoginErrorState)
          {
            Fluttertoast.showToast(msg: 'Error');
          }
          // Listener in Login state if success save uId in CacheHelper and navigate to HomeLayout
          if(state is LoginSuccessState)
          {
            // CacheHelper to save token or Authorization and navigate and finish to the main home screen
            CashHelper.saveData(
              key: 'uId',
              value: state.uId,
            ).then((value) {

              navigateAndFinish(
                context,
                const AdminScreen(),
              );
            },
            );
          }
        },
        builder: (context, state) {
          var height = MediaQuery.of(context).size.height;
          var width = MediaQuery.of(context).size.width;

          return Scaffold(
            body: Stack(
              children: [
                Image.asset(
                  'assets/images/back.jpg',
                  width: width,
                  height: height,
                  fit: BoxFit.cover,
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      children: <Widget>[
                        CircleAvatar(
                          radius: 75.0,
                          backgroundColor: Colors.transparent,
                          child: Image.asset(
                            'assets/images/lg.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                        // ******************  Email and Password TextField  ***************
                        defaultTextFormField(
                          controller: _emailController,
                          label: 'Enter your Email',
                          keyboardType: TextInputType.emailAddress,
                          prefix: Icons.email,
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return 'Email must not be Empty!';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),

                        defaultTextFormField(
                          controller: _passwordController,
                          label: 'Enter your Password',
                          keyboardType: TextInputType.text,
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return 'Password must not be Empty!';
                            }
                            return null;
                          },
                          secure: LoginCubit.get(context).isPasswordShown,
                          prefix: Icons.password,
                          suffix: LoginCubit.get(context).suffix,
                          suffixPressed: ()
                          {
                            LoginCubit.get(context).changePasswordVisibility();
                          },
                        ),
                        // ****************   Forget Password  ******************
                        Container(
                          alignment: Alignment.centerLeft,
                          child: TextButton(
                            onPressed: () {},
                            child: const Text('Forget Password?'),
                          ),
                        ),
                        // ***********************   Sign In Button  ***********************
                        ConditionalBuilder(
                          condition: state is! LoginLoadingState,
                          builder: (context) =>
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 120.0),
                                child: TextButton(
                                  onPressed: () {
                                    if(_formKey.currentState!.validate())
                                    {
                                      LoginCubit.get(context).userLogin(
                                        email: _emailController.text.trim(),
                                        password: _passwordController.text.trim(),
                                      );
                                    }
                                  },
                                  child: const Text('Sign In >'),
                                ),
                              ),
                          fallback: (context) =>
                          const Center(child: CircularProgressIndicator()),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              const Text(
                                'Dont\'t have account?   ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  //navigateAndFinish(context, RegisterScreen());
                                },
                                child: const Text(
                                  'Sign up',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        // ********************   Or Continue with   *********************
                        // Center(child: Text('------------------- Or Continue with Email ---------------'),)
                        Stack(
                          children: const [
                            Divider(
                              thickness: 2.25,
                            ),
                            Center(
                              child: Text(
                                'Or Continue with : ',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        // ********************   Apple Sign In Button   *******************
                        defaultSigningInRowButton(
                          rowBackgroundColor: Colors.grey,
                          title: 'Connect with Apple',
                          titleStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                            color: Colors.white,
                          ),
                          width: 10.0,
                          icon: FontAwesomeIcons.apple,
                          onPressed: () {},
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        // ***********************   Google Sign In Button   ***************
                        defaultSigningInRowButton(
                          rowBackgroundColor: Colors.grey,
                          title: 'Connect with Google',
                          titleStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                            color: Colors.white,
                          ),
                          width: 10.0,
                          icon: FontAwesomeIcons.google,
                          iconColor: Colors.red,
                          onPressed: () {
                            LoginCubit.get(context).signInWithGoogle();
                            //signInWithGoogle();
                            // login();
                          },
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        // *********************   Facebook Sign In Button   ***************
                        defaultSigningInRowButton(
                          rowBackgroundColor: Colors.grey,
                          title: 'Connect with Facebook',
                          titleStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                            color: Colors.white,
                          ),
                          width: 10.0,
                          icon: FontAwesomeIcons.facebook,
                          iconColor: Colors.blue,
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}