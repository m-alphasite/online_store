import 'package:flutter/material.dart'; // Importa o pacote Flutter para construção de interfaces
import 'package:online_store/common/custom_drawer/minhas_cores.dart'; // Importa o arquivo de cores personalizadas
import 'package:online_store/models/decoration.screen.dart'; // Importa o arquivo de cores personalizadas
import 'package:online_store/models/user_manager.dart'; // Importa o gerenciador deUsuários
import 'package:provider/provider.dart'; // Importa o pacote provider para gerenciamento de estado

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final emailController =
      TextEditingController(); // Controlador para o campo de e-mail
  final passwordController =
      TextEditingController(); // Controlador para o campo de senha
  final GlobalKey<FormState> formKey =
      GlobalKey<FormState>(); // Chave global para o formulário

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fundo com imagem
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/image_2.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Botão "Criar Conta" posicionado mais acima
                  Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('/signup');
                      },
                      child: const Text(
                        'Criar Conta',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                  const SizedBox(height: 150),
                  // Logotipo da aplicação
                  Image.asset(
                    "assets/images/logo.png",
                    width: 150,
                    height: 150,
                  ),
                  const SizedBox(height: 16),
                  // Formulário dentro de um card transparente
                  Card(
                    color: Colors.white.withOpacity(0.20),
                    child: Form(
                      key: formKey,
                      child: Consumer<UserManager>(
                        builder: (_, userManager, __) {
                          return Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Campo de e-mail
                                TextFormField(
                                  controller: emailController,
                                  enabled: !userManager.loading,
                                  decoration: getAuthenticationInputDecoration(
                                      'E-mail'),
                                  keyboardType: TextInputType.emailAddress,
                                  autocorrect: false,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor, insira um e-mail';
                                    }
                                    if (!value.contains('@') ||
                                        !value.contains('.com')) {
                                      return 'Por favor, insira um e-mail válido';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),
                                // Campo de senha
                                TextFormField(
                                  controller: passwordController,
                                  enabled: !userManager.loading,
                                  decoration:
                                      getAuthenticationInputDecoration('Senha'),
                                  autocorrect: false,
                                  obscureText: true,
                                  validator: (pass) {
                                    if (pass == null || pass.isEmpty) {
                                      return 'Por favor, insira uma senha';
                                    }
                                    if (pass.length < 6) {
                                      return 'A senha deve ter pelo menos 6 caracteres';
                                    }
                                    return null;
                                  },
                                ),
                                // Botão "Esqueceu a senha?" posicionado próximo ao campo de senha
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () {
                                      // Implementar funcionalidade de redefinição de senha
                                    },
                                    child: const Text(
                                      'Esqueceu a senha?',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                // Botão de login
                                SizedBox(
                                  height: 44,
                                  child: ElevatedButton(
                                    onPressed: userManager.loading
                                        ? null
                                        : () {
                                            if (formKey.currentState!
                                                .validate()) {
                                              context
                                                  .read<UserManager>()
                                                  .signIn(
                                                    email: emailController.text,
                                                    password:
                                                        passwordController.text,
                                                    onFail: (e) {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                          content: Text(e),
                                                          backgroundColor:
                                                              Colors.deepPurple,
                                                        ),
                                                      );
                                                    },
                                                    onSuccess: (_) {
                                                      Navigator.of(context)
                                                          .pushReplacementNamed(
                                                              '/base');
                                                    },
                                                  );
                                            }
                                          },
                                    style: ElevatedButton.styleFrom(
                                      disabledBackgroundColor:
                                          MinhasCores.rosa_1.withAlpha(120),
                                      backgroundColor: MinhasCores.rosa_1,
                                    ),
                                    child: userManager.loading
                                        ? const CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    Colors.white),
                                          )
                                        : const Text(
                                            'LogIn',
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.white),
                                          ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                // Botão para login com Google
                                SizedBox(
                                  height: 44,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // Implementar login com Google
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: MinhasCores.rosa_1,
                                    ),
                                    child: const Text(
                                      'Entrar com Google',
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
