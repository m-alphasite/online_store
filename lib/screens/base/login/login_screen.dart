import 'package:flutter/material.dart'; // Importa o Flutter para construir a interface do usuário
import 'package:online_store/common/custom_drawer/minhas_cores.dart'; // Importa o arquivo de cores personalizadas
import 'package:online_store/models/decoration.screen.dart'; // Importa o arquivo de cores personalizadas
import 'package:online_store/models/user_manager.dart'; // Importa o arquivo de gerenciamento de usuário
import 'package:provider/provider.dart'; // Importa o arquivo de gerenciamento de estado

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
          Container(
            decoration: const BoxDecoration(
              // Define a imagem de fundo
              image: DecorationImage(
                // Define a imagem de fundo
                image:
                    AssetImage('assets/images/image_2.jpg'), // Imagem de fundo
                fit: BoxFit.cover, // Ajusta a imagem ao tamanho do container
              ),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center, // Alinha o conteúdo ao centro
              crossAxisAlignment:
                  CrossAxisAlignment.stretch, // Alinha o conteúdo ao centro
              children: [
                SizedBox(
                  height: 12, // Espaço entre a imagem e o Card
                ),
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.end, // Alinha o conteúdo ao centro
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.all(0),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                            '/signup'); // Navega para a tela de cadastro
                      },
                      child: const Text(
                        'Criar Conta',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  // Alinha o conteúdo ao centro
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/images/logo.png",
                          width: 150,
                        ),
                        const SizedBox(
                            height: 16), // Espaço entre a imagem e o Card
                        Card(
                          // ignore: deprecated_member_use
                          color: Colors.white
                              .withOpacity(0.20), // Cor de fundo do Card
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          child: Form(
                            // Formulário
                            key: formKey, // Chave global para o formulário
                            child: Consumer<UserManager>(
                              // Consumidor de dados do usuário
                              builder: (_, userManager, __) {
                                // Construtor do formulário
                                return ListView(
                                  padding: const EdgeInsets.all(16),
                                  shrinkWrap: true,
                                  children: <Widget>[
                                    TextFormField(
                                      // Campo de e-mail
                                      controller:
                                          emailController, // Controlador para o campo de e-mail
                                      enabled: !userManager
                                          .loading, // Habilita ou desabilita o campo de e-mail
                                      decoration:
                                          getAuthenticationInputDecoration(
                                              'E-mail'),
                                      keyboardType: TextInputType
                                          .emailAddress, // Define o tipo de teclado
                                      autocorrect:
                                          false, // Desabilita a correção automática
                                      validator: (String? value) {
                                        // Validador
                                        if (value == null || value.isEmpty) {
                                          // Se o campo estiver vazio
                                          return 'Por favor, insira um e-mail'; // Retorna uma mensagem de erro
                                        }
                                        if (!value.contains('@')) {
                                          // Se o e-mail não tiver '@'
                                          return 'Por favor, insira um e-mail válido'; // Retorna uma mensagem de erro
                                        }
                                        if (!value.contains('.com')) {
                                          // Se o e-mail não tiver '.com'
                                          return 'Por favor, insira um e-mail válido'; // Retorna uma mensagem de erro
                                        }
                                        return null; // Retorna null
                                      },
                                    ),
                                    const SizedBox(
                                        height: 16), // Corrected to SizedBox
                                    TextFormField(
                                      controller:
                                          passwordController, // Controlador para o campo de senha
                                      enabled: !userManager
                                          .loading, // Habilita ou desabilita o campo de senha
                                      decoration:
                                          getAuthenticationInputDecoration(
                                              'Senha'),
                                      autocorrect:
                                          false, // Desabilita a correção automática
                                      obscureText:
                                          true, // Define o tipo de teclado
                                      validator: (pass) {
                                        // Validador
                                        if (pass ==
                                                null || // Se o campo estiver vazio
                                            pass.isEmpty || // Se o campo estiver vazio
                                            pass.length < 6) {
                                          // Se o campo estiver vazio
                                          return 'Por favor, insira uma senha com pelo menos 6 caracteres'; // Retorna uma mensagem de erro
                                        }
                                        return null;
                                      },
                                    ),
                                    Align(
                                      // Alinha o conteúdo ao centro
                                      alignment: Alignment
                                          .centerRight, // Alinha ao centro
                                      child: TextButton(
                                        // Botão de login
                                        onPressed: () {
                                          // Função de clique do botão
                                          // Implement password reset functionality here
                                        },
                                        style: TextButton.styleFrom(
                                          padding: const EdgeInsets.all(0),
                                        ),
                                        child: const Text(
                                          'Esqueceu a senha?',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                        height: 16), // Corrected to SizedBox
                                    SizedBox(
                                      height: 44,
                                      child: ElevatedButton(
                                        onPressed: userManager
                                                .loading // Verifica se o usuário está carregando
                                            ? null // Se estiver carregando, retorna null
                                            : () {
                                                if (formKey
                                                    .currentState! // Verifica se o formulário está válido
                                                    .validate()) {
                                                  // Se estiver, valida o formulário
                                                  context
                                                      .read<
                                                          UserManager>() // Consumidor de dados do usuário
                                                      .signIn(
                                                        // Função de login
                                                        email: emailController
                                                            .text,
                                                        password:
                                                            passwordController
                                                                .text,
                                                        onFail: (e) {
                                                          // Função de falha
                                                          ScaffoldMessenger.of(
                                                              // Mensagem de erro
                                                              context).showSnackBar(
                                                            SnackBar(
                                                              content: Text(e),
                                                              backgroundColor:
                                                                  Colors
                                                                      .deepPurple,
                                                            ),
                                                          );
                                                        },
                                                        onSuccess: (_) {
                                                          // Função de sucesso
                                                          Navigator.of(
                                                                  context) // Navega para a tela de base
                                                              .pushReplacementNamed(
                                                                  // Navega para a tela de base
                                                                  '/base');
                                                        },
                                                      );
                                                }
                                              },
                                        style: ElevatedButton.styleFrom(
                                          // Define o estilo do botão
                                          disabledBackgroundColor: // Define a cor de fundo do botão quando estiver carregando
                                              MinhasCores.rosa_1.withAlpha(120),
                                          backgroundColor: MinhasCores.rosa_1,
                                        ),
                                        child: userManager
                                                .loading // Verifica se o usuário está carregando
                                            ? const CircularProgressIndicator(
                                                // Cria um indicador de carregamento
                                                valueColor: // Define a cor do indicador
                                                    AlwaysStoppedAnimation< // Sem animação
                                                        Color>(Colors.white),
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
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: MinhasCores.rosa_1),
                                      onPressed: () {},
                                      child: const Text(
                                          'Entrar com Google', // Botão de login com Google
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.white)),
                                    ),
                                  ],
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
          ),
        ],
      ),
    );
  }
}
