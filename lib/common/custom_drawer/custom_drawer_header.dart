import 'package:flutter/material.dart'; // Importa o pacote Flutter para construir a interface do usuário
import 'package:online_store/common/custom_drawer/minhas_cores.dart'; // Importa um arquivo de cores personalizadas
import 'package:online_store/models/user_manager.dart'; // Importa o gerenciador de usuário
import 'package:provider/provider.dart'; // Importa o pacote provider para gerenciar o estado

// Classe CustomDrawerHeader que estende StatelessWidget para criar o cabeçalho do drawer personalizado
class CustomDrawerHeader extends StatelessWidget {
  const CustomDrawerHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // Container com uma decoração de fundo gradiente
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            MinhasCores.rosa_1, // Cor do gradiente (rosa 1)
            MinhasCores.rosa_2, // Cor do gradiente (rosa 2)
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      padding: const EdgeInsets.fromLTRB(
        32,
        24,
        16,
        8,
      ), // Define o padding do container
      height: 290, // Define a altura do container
      child: Stack(
        children: <Widget>[
          // Utiliza Consumer para escutar mudanças no UserManager
          Consumer<UserManager>(
            builder: (_, userManager, __) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  // Adiciona a imagem do logo
                  Image.asset(
                    "assets/images/icon_o.png",
                    width: 100, // Define a largura da imagem
                    height: 100, // Define a altura da imagem
                  ),
                  const SizedBox(height: 8), // Espaço entre a imagem e o texto
                  const Text(
                    'Pandora Fashion', // Nome da loja
                    style: TextStyle(
                      fontSize: 29,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 255, 255, 255), // Cor do texto
                    ),
                  ),
                  // Exibe uma saudação ao usuário logado
                  Text(
                    'Olá, ${userManager.user?.name ?? ''}', // Nome do usuário
                    overflow: TextOverflow
                        .ellipsis, // Trunca o texto se for muito longo
                    maxLines:
                        2, // Define o número máximo de linhas para o texto
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Cor do texto
                    ),
                  ),
                  // Adiciona um GestureDetector para login/logout
                  GestureDetector(
                    onTap: () {
                      if (userManager.isLoggedIn) {
                        userManager
                            .signOut(); // Faz logout se o usuário estiver logado
                      } else {
                        Navigator.of(context)
                            .pushNamed('/login'); // Navega para a tela de login
                      }
                    },
                    // Texto para login/logout
                    child: Text(
                      userManager.isLoggedIn
                          ? 'Sair' // Mostra "Sair" se o usuário estiver logado
                          : 'Entre ou cadastre-se >', // Mostra "Entre ou cadastre-se" se não estiver logado
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: MinhasCores.rosa_3, // Cor do texto
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
