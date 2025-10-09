import 'package:cinetrack/core/asset_images.dart';
import 'package:cinetrack/features/auth/repositories/auth_repository.dart';
import 'package:cinetrack/features/auth/routes/auth_routes.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.surface,
            Color.fromARGB(255, 83, 47, 130),
            Theme.of(context).colorScheme.surface,
          ],
          transform: GradientRotation(120),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFcd90f5).withAlpha(40),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFcd90f5), width: 0.5),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipOval(
                    child: Image.asset(
                      AssetImages.mainIcon,
                      width: 75,
                      height: 75,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'CineTrack',
                    style: Theme.of(
                      context,
                    ).textTheme.displayLarge?.copyWith(color: Colors.white),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Sua jornada cinematográfica começa aqui',
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 20),
                  Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 10,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Text(
                              'Email',
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                          ),
                          TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              hintText: 'Digite seu email',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, digite um email';
                              } else if (!RegExp(
                                r'^[\w\.-]+@[\w\.-]+\.\w+$',
                              ).hasMatch(value)) {
                                return "Por favor, digite um e-mail válido";
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Text(
                              'Senha',
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                          ),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: 'Digite sua senha',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, digite uma senha';
                              } else if (value.length < 6) {
                                return 'Por favor, digite uma senha válida com no mínimo 6 caracteres';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  SizedBox(
                    width: 400,
                    child: ElevatedButton(
                      style: Theme.of(context).elevatedButtonTheme.style,
                      onPressed: () async {
                        bool isValid = _formKey.currentState!.validate();
                        if (!isValid) return;
                        try {
                          final authRepository = AuthRepository();
                          await authRepository.login(
                            email: _emailController.text,
                            password: _passwordController.text,
                          );
                          if (!context.mounted) return;
                          Navigator.of(
                            context,
                          ).popUntil((route) => route.isFirst);
                          Navigator.of(context).pushReplacementNamed('/home');
                        } on AuthException catch (e) {
                          if (!context.mounted) return;
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Erro'),
                                content: Text(e.getMessage()),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Ok'),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                      child: const Text('Entrar'),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'Não tem uma conta? ',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      TextButton(
                        // sem estilizar o TextButton, fica uma sombra quando passa o mouse em cima
                        // sem o padding, fica um espaço indesejado
                        style: ButtonStyle(
                          foregroundColor: WidgetStateProperty.all(
                            Color(0xFFf5b938),
                          ),
                          overlayColor: WidgetStateProperty.all(
                            Colors.transparent,
                          ),
                          padding: WidgetStateProperty.all(EdgeInsets.zero),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, AuthRoutes.createAccount);
                        },
                        child: Text(
                          'Criar Conta',
                          style: TextStyle(fontWeight: FontWeight.normal),
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    style: ButtonStyle(
                      padding: WidgetStateProperty.all(EdgeInsets.zero),
                      overlayColor: WidgetStateProperty.all(Colors.transparent),
                    ),
                    onPressed: () {},
                    child: Text(
                      'Esqueceu a senha?',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
