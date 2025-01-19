import 'package:flutter/material.dart'; // Importa o Flutter para construir a interface do usuário
import 'package:online_store/common/custom_drawer/minhas_cores.dart'; // Importa o arquivo de cores personalizadas
import 'package:online_store/models/user_manager.dart'; // Importa o gerenciador de usuário
import 'package:provider/provider.dart'; // Importa o pacote provider para gerenciar o estado

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});

  final nameController =
      TextEditingController(); // Controlador para o campo de nome
  final emailController =
      TextEditingController(); // Controlador para o campo de e-mail
  final passwordController =
      TextEditingController(); // Controlador para o campo de senha
  final confirmPasswordController =
      TextEditingController(); // Controlador para o campo de confirmação de senha
  final GlobalKey<FormState> formKey =
      GlobalKey<FormState>(); // Chave para o formulário

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // Cria um Scaffold com a tela de cadastro
        body: Stack(
      // Cria uma pilha de widgets
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/image_2.jpg"), // Imagem de fundo
              fit: BoxFit.cover, // Ajusta a imagem ao tamanho do container
            ),
          ),
        ),
        Center(
          child: ListView(
            // Cria uma lista de widgets
            shrinkWrap: true, // Deixa a lista não ocupar o espaço restante
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              // Adicionando a imagem e o texto acima do Card
              Column(
                // Cria uma coluna de widgets
                children: const [
                  Image(
                    image: AssetImage("assets/images/image (2).png"), // Imagem
                    width: 280, // Largura da imagem
                  ),
                  SizedBox(height: 16), // Espaço entre a imagem e o texto
                  Text(
                    'Criar sua Conta',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 16), // Espaço entre o texto e o Card
                ],
              ),
              Card(
                color: Colors.white.withOpacity(0.8), // Define a cor do Card
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: Form(
                  key: formKey,
                  child: Consumer<UserManager>(
                    // Utiliza Consumer para escutar mudanças no UserManager
                    builder: (_, userManager, __) {
                      // Cria um builder
                      return ListView(
                        // Cria uma lista de widgets
                        padding: const EdgeInsets.all(16),
                        shrinkWrap: true,
                        children: <Widget>[
                          TextFormField(
                            enabled: !userManager
                                .loading, // Desabilita o campo enquanto o usuário está carregando
                            controller:
                                nameController, // Controla o campo de texto
                            decoration: getAuthenticationInputDecoration(
                                'Nome Completo'),
                            validator: (name) {
                              // Valida o campo
                              if (name == null || name.isEmpty) {
                                // Verifica se o campo está vazio
                                return 'Por favor, escreva seu nome completo'; // Retorna uma mensagem de erro
                              } else if (name.trim().split(' ').length <= 1) {
                                // Verifica se o nome tem menos de 2 palavras
                                return "Por favor, escreva seu nome completo"; // Retorna uma mensagem de erro
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            enabled: !userManager
                                .loading, // Desabilita o campo enquanto o usuário está carregando
                            controller:
                                emailController, // Controla o campo de texto
                            decoration: getAuthenticationInputDecoration(
                              'E-mail',
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, escreva seu e-mail';
                              }
                              if (!value.contains('@') ||
                                  !value.contains('.')) {
                                return 'Por favor, escreva um e-mail valido';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            enabled: !userManager.loading,
                            controller: passwordController,
                            decoration: getAuthenticationInputDecoration(
                              'Senha',
                            ),
                            obscureText: true,
                            validator: (pass) {
                              if (pass == null ||
                                  pass.isEmpty ||
                                  pass.length < 6) {
                                return 'Senha Inválida';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            enabled: !userManager.loading,
                            controller: confirmPasswordController,
                            decoration: getAuthenticationInputDecoration(
                              'Confirmar Senha',
                            ),
                            obscureText: true,
                            validator: (pass) {
                              if (pass == null ||
                                  pass.isEmpty ||
                                  pass.length < 6) {
                                return 'Senha Inválida';
                              }
                              if (pass != passwordController.text) {
                                return 'Senhas Diferentes';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: MinhasCores.rosa_1,
                            ),
                            onPressed: userManager.loading
                                ? null
                                : () {
                                    if (formKey.currentState!.validate()) {
                                      // Valida o formulário
                                      context.read<UserManager>().signUp(
                                            // Chama a função signUp do UserManager
                                            name: nameController
                                                .text, // Passa os dados do formulário
                                            email: emailController
                                                .text, // para a função signUp
                                            password: passwordController
                                                .text, // Passa os dados do formulário
                                            onFail: (e) {
                                              // Função de callback para falha
                                              ScaffoldMessenger.of(
                                                      context) // Mostra um snackbar com a mensagem de erro
                                                  .showSnackBar(
                                                // Mostra um snackbar com a mensagem de erro
                                                SnackBar(
                                                  // Cria um snackbar com a mensagem de erro
                                                  content: Text(
                                                    e,
                                                    style: const TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  backgroundColor:
                                                      Colors.deepPurple,
                                                ),
                                              );
                                            },
                                            onSuccess: (_) {
                                              // Função de callback para sucesso
                                              Navigator.of(
                                                      context) // Navega para a tela de base
                                                  .pushReplacementNamed(
                                                      // Navega para a tela de base
                                                      '/base');
                                            },
                                          );
                                    }
                                  },
                            child: userManager
                                    .loading // Se a função signUp estiver carregando
                                ? const CircularProgressIndicator(
                                    // Mostra um círculo de carregamento
                                    color: Colors.white,
                                  )
                                : const Text(
                                    'Criar Conta',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
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
      ],
    ));
  }
}

InputDecoration getAuthenticationInputDecoration(String label) {
  // Função para criar um InputDecoration personalizado
  return InputDecoration(
    // Cria um InputDecoration
    labelText: label, // Define o label do campo
    border: const OutlineInputBorder(), // Define a borda do campo
  );
}
