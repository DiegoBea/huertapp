import 'package:flutter/material.dart';
import 'package:huertapp/providers/login_form_provider.dart';
import 'package:huertapp/services/services.dart';
import 'package:huertapp/themes/app_theme.dart';
import 'package:huertapp/ui/input_decorations.dart';
import 'package:huertapp/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:auth_buttons/auth_buttons.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/background_login.jpg"),
              fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: false,
        body: AuthBackground(
            child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 250),
              CardContainer(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      'Iniciar sesión',
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    const SizedBox(height: 30),
                    ChangeNotifierProvider(
                      create: (_) => LoginFormProvider(),
                      child: const _LoginForm(),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              TextButton(
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, '/register'),
                style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(
                        Colors.greenAccent.withOpacity(0.1)),
                    shape: MaterialStateProperty.all(const StadiumBorder())),
                child: const Text(
                  'Crear nueva cuenta',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(context);

    return Container(
      child: Form(
          key: loginForm.formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              TextFormField(
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecorations.authInputDecorations(
                    hintText: 'usuario@email.com',
                    labelText: 'Correo electrónico',
                    prefixIcon: Icons.alternate_email),
                onChanged: (value) => loginForm.email = value,
                validator: (value) {
                  String pattern =
                      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

                  RegExp regExp = RegExp(pattern);

                  return regExp.hasMatch(value ?? '')
                      ? null
                      : 'Formato de email inválido';
                },
              ),
              const SizedBox(height: 30),
              TextFormField(
                autocorrect: false,
                obscureText: true,
                decoration: InputDecorations.authInputDecorations(
                    hintText: '******',
                    labelText: 'Contraseña',
                    prefixIcon: Icons.lock),
                onChanged: (value) => loginForm.password = value,
                validator: (value) {
                  if (value != null && value.length >= 8) return null;
                  return 'La contraseña debe tener 8 caracteres';
                },
              ),
              const SizedBox(height: 30),
              MaterialButton(
                  onPressed: loginForm.isLoading
                      ? null
                      : () async {
                          final authService =
                              Provider.of<AuthService>(context, listen: false);

                          FocusScope.of(context).unfocus();

                          if (!loginForm.isValidForm()) return;

                          final String? errorMsg = await authService.signIn(
                              loginForm.email, loginForm.password);

                          loginForm.isLoading = true;

                          if (errorMsg == null) {
                            Navigator.pushReplacementNamed(context, '/home');
                          } else {
                            print(errorMsg);
                            loginForm.isLoading = false;
                          }
                        },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  elevation: 0,
                  disabledColor: Colors.grey,
                  color: AppTheme.primary,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 80, vertical: 15),
                    child: Text(
                      loginForm.isLoading ? 'Cargando...' : 'Iniciar sesión',
                      style: const TextStyle(color: Colors.white),
                    ),
                  )),
              const SizedBox(height: 30),
              // GoogleAuthButton(onPressed: (){}, text: 'Iniciar con google', isLoading: false,),
              SizedBox(
                width: 270,
                child: SignInButton(Buttons.Email,
                    text: 'Iniciar sesión con Email',
                    onPressed: loginForm.isLoading
                      ? (){}
                      : () async {
                          final authService =
                              Provider.of<AuthService>(context, listen: false);

                          FocusScope.of(context).unfocus();

                          if (!loginForm.isValidForm()) return;

                          final String? errorMsg = await authService.signIn(
                              loginForm.email, loginForm.password);

                          loginForm.isLoading = true;

                          if (errorMsg == null) {
                            Navigator.pushReplacementNamed(context, '/home');
                          } else {
                            print(errorMsg);
                            loginForm.isLoading = false;
                          }
                        },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
              SizedBox(
                width: 270,
                child: SignInButton(Buttons.Google,
                    text: 'Iniciar sesión con google',
                    onPressed: () {},
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
            ],
          )),
    );
  }
}
