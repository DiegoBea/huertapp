import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:huertapp/helpers/helpers.dart';
import 'package:huertapp/providers/login_form_provider.dart';
import 'package:huertapp/services/services.dart';
import 'package:huertapp/ui/input_decorations.dart';
import 'package:huertapp/widgets/widgets.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/background_login.jpg"),
              fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 250),
                  CardContainer(
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        Text(
                          translate('titles.register'),
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
                        Navigator.pushReplacementNamed(context, '/login'),
                    style: ButtonStyle(
                        overlayColor: MaterialStateProperty.all(
                            Colors.greenAccent.withOpacity(0.1)),
                        shape:
                            MaterialStateProperty.all(const StadiumBorder())),
                    child: Text(
                      translate(
                          'feedback.accountExistQuestion'), //'¿Ya tienes cuenta? Inicia sesión'
                      style: const TextStyle(
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

    return Form(
        key: loginForm.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecorations(
                  hintText: 'demo@email.com',
                  labelText: translate('titles.email'),
                  prefixIcon: Icons.alternate_email),
              onChanged: (value) => loginForm.email = value,
              validator: (value) {
                String pattern =
                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

                RegExp regExp = RegExp(pattern);

                return regExp.hasMatch(value ?? '')
                    ? null
                    : translate(
                        'validation.emailFormat'); // 'Formato de email inválido'
              },
            ),
            const SizedBox(height: 30),
            TextFormField(
              autocorrect: false,
              obscureText: true,
              decoration: InputDecorations.authInputDecorations(
                  hintText: '******',
                  labelText: translate('titles.password'),
                  prefixIcon: Icons.lock),
              onChanged: (value) => loginForm.password = value,
              validator: (value) {
                if (value != null && value.length >= 8) return null;
                return translate('validation.minChars', args: {
                  "value": 8
                }); //'La contraseña debe tener 8 caracteres'
              },
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: 270,
              child: SignInButton(Buttons.Email,
                  text: translate(
                          'titles.registerWithEmail'), //  'Registrarse con email',
                  onPressed: loginForm.isLoading
                      ? () {}
                      : () async {
                          final authService =
                              Provider.of<AuthService>(context, listen: false);
                          final weatherService =
                              Provider.of<WeatherService>(context, listen: false);

                          FocusScope.of(context).unfocus();

                          if (!loginForm.isValidForm()) return;

                          final String? errorMsg = await authService.signUp(
                              email: loginForm.email,
                              password: loginForm.password);

                          loginForm.isLoading = true;

                          if (errorMsg == null) {
                            
                            weatherService.loadLocations();
                            Navigator.pushReplacementNamed(context, '/main');
                          } else {
                            ToastHelper.showToast(translate('feedback.accountExist')); // 'La cuenta ya existe'
                            print(errorMsg);
                            loginForm.isLoading = false;
                          }
                        },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
            ),
          ],
        ));
  }
}
