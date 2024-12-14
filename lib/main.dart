import 'package:firebase_core/firebase_core.dart'; // Importa o pacote Firebase Core para inicializar o Firebase
import 'package:flutter/material.dart'; // Importa o Flutter para construir a interface do usuário
import 'package:online_store/common/custom_drawer/minhas_cores.dart'; // Importa o arquivo de cores personalizadas
import 'package:online_store/firebase_options.dart'; // Importa as opções de configuração do Firebase
import 'package:online_store/models/cart_manager.dart'; // Importa o gerenciador de carrinho
import 'package:online_store/models/home_manager.dart'; // Importa o gerenciador de home
import 'package:online_store/models/product.dart'; // Importa o modelo de produto
import 'package:online_store/models/product_manager.dart'; // Importa o gerenciador de produtos
import 'package:online_store/models/user_manager.dart'; // Importa o gerenciador de usuários
import 'package:online_store/models/page_manager.dart'; // Importa o gerenciador de páginas
import 'package:online_store/screens/base/base_screen.dart'; // Importa a tela base
import 'package:online_store/screens/base/login/login_screen.dart'; // Importa a tela de login
import 'package:online_store/screens/base/login/signup_screen.dart'; // Importa a tela de cadastro
import 'package:online_store/screens/cart/cart_screen.dart'; // Importa a tela de carrinho
import 'package:online_store/screens/produtos/produtos_screen.dart'; // Importa a tela de produtos
import 'package:provider/provider.dart'; // Importa o pacote provider para gerenciar o estado

Future<void> main() async {
  // Função principal que inicializa o aplicativo
  WidgetsFlutterBinding
      .ensureInitialized(); // Garante que o binding do Flutter esteja inicializado
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions
        .currentPlatform, // Inicializa o Firebase com as opções de configuração
  );

  runApp(const MyApp()); // Executa o aplicativo MyApp
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) =>
              UserManager(), // Cria uma instância do gerenciador de usuários
          lazy:
              false, // Garante que o gerenciador de usuários seja criado imediatamente
        ),
        ChangeNotifierProvider(
          create: (_) =>
              ProductManager(), // Cria uma instância do gerenciador de produtos
          lazy:
              false, // Garante que o gerenciador de produtos seja criado imediatamente
        ),
        ChangeNotifierProvider(
          create: (_) =>
              HomeManager(), // Cria uma instância do gerenciador de home
          lazy:
              false, // Garante que o gerenciador de home seja criado imediatamente
        ),
        ChangeNotifierProxyProvider<UserManager, CartManager>(
          create: (_) =>
              CartManager(), // Cria uma instância do gerenciador de carrinho
          lazy:
              false, // Garante que o gerenciador de carrinho seja criado imediatamente
          update: (_, userManager, cartManager) => cartManager!
            ..updateUser(userManager), // Atualiza o gerenciador de carrinho
        ),
        ChangeNotifierProvider(
          create: (_) => PageManager(
              PageController()), // Cria uma instância do gerenciador de páginas
          lazy:
              false, // Garante que o gerenciador de páginas seja criado imediatamente
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false, // Remove a bandeira de debug
        theme: ThemeData(
          primaryColor: MinhasCores.rosa_2, // Define a cor primária
          scaffoldBackgroundColor:
              MinhasCores.rosa_2, // Define a cor de fundo do Scaffold
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors
                .transparent, // Define a cor de fundo do AppBar como transparente
            elevation: 0, // Remove a elevação do AppBar
          ),
          visualDensity: VisualDensity
              .adaptivePlatformDensity, // Ajusta a densidade visual para o tipo de plataforma
        ),
        title: 'Online Store', // Define o título do aplicativo
        initialRoute: '/login', // Define a rota inicial
        onGenerateRoute: (settings) {
          // Define o gerador de rotas
          switch (settings.name) {
            case '/login':
              return MaterialPageRoute(
                builder: (_) => LoginScreen(), // Rota para a tela de login
              );
            case '/signup':
              return MaterialPageRoute(
                builder: (_) => SignupScreen(), // Rota para a tela de cadastro
              );
            case '/produtos':
              return MaterialPageRoute(
                builder: (_) => ProdutosScreen(
                  product: settings.arguments
                      as Product, // Rota para a tela de produtos com um produto como argumento
                ),
              );
            case '/cart':
              return MaterialPageRoute(
                builder: (_) => CartScreen(), // Rota para a tela de carrinho
              );
            case '/base':
              return MaterialPageRoute(
                builder: (_) => BaseScreen(), // Rota para a tela base
              );
            default:
              return MaterialPageRoute(
                builder: (_) =>
                    LoginScreen(), // Rota padrão para a tela de login
              );
          }
        },
      ),
    );
  }
}
