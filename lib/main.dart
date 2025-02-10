import 'package:firebase_core/firebase_core.dart'; // Firebase Core
import 'package:flutter/material.dart'; // Flutter Material
import 'package:online_store/common/custom_drawer/minhas_cores.dart'; // Cores personalizadas
import 'package:online_store/firebase_options.dart'; // Configurações do Firebase
import 'package:online_store/models/admin_users_manager.dart'; // Gerenciador de usuários admin
import 'package:online_store/models/cart_manager.dart'; // Gerenciador de carrinho
import 'package:online_store/models/home_manager.dart'; // Gerenciador de tela inicial
import 'package:online_store/models/product.dart'; // Modelo de produto
import 'package:online_store/models/product_manager.dart'; // Gerenciador de produtos
import 'package:online_store/models/user_manager.dart'; // Gerenciador de usuários
import 'package:online_store/models/page_manager.dart'; // Gerenciador de páginas
import 'package:online_store/screens/base/base_screen.dart'; // Tela base
import 'package:online_store/screens/base/login/login_screen.dart'; // Tela de login
import 'package:online_store/screens/base/login/signup_screen.dart'; // Tela de cadastro
import 'package:online_store/screens/cart/cart_screen.dart'; // Tela do carrinho
import 'package:online_store/screens/edit_product/edit_product_screens.dart'; // Tela de edição de produto
import 'package:online_store/screens/produtos/produtos_screen.dart'; // Tela de produtos
import 'package:provider/provider.dart'; // Gerenciamento de estado com Provider

// Função principal da aplicação
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Inicializa o binding do Flutter
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Configura o Firebase
  );

  runApp(const MyApp()); // Inicia a aplicação com MyApp
}

// Widget principal da aplicação
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Gerenciador de Usuários
        ChangeNotifierProvider<UserManager>(
          create: (_) => UserManager(),
        ),
        // Gerenciador de Produtos
        ChangeNotifierProvider<ProductManager>(
          create: (_) => ProductManager(),
        ),
        // Gerenciador de Tela Inicial
        ChangeNotifierProvider<HomeManager>(
          create: (_) => HomeManager(),
        ),
        // Gerenciador de Carrinho (Depende de UserManager)
        ChangeNotifierProxyProvider<UserManager, CartManager>(
          create: (_) => CartManager(),
          update: (_, userManager, cartManager) {
            cartManager ??= CartManager();
            cartManager.updateUser(userManager);
            return cartManager;
          },
        ),
        // Gerenciador de Usuários Admin (Depende de UserManager)
        ChangeNotifierProxyProvider<UserManager, AdminUsersManager>(
          create: (_) => AdminUsersManager(),
          update: (_, userManager, adminUsersManager) {
            adminUsersManager ??= AdminUsersManager();
            adminUsersManager.updateUser(userManager);
            return adminUsersManager;
          },
        ),
        // Gerenciador de Páginas
        ChangeNotifierProvider<PageManager>(
          create: (_) => PageManager(PageController()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false, // Remove o banner de debug
        theme: ThemeData(
          primaryColor: MinhasCores.rosa_2, // Define a cor primária
          scaffoldBackgroundColor:
              MinhasCores.rosa_2, // Cor do fundo do Scaffold
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent, // Fundo transparente
            elevation: 0, // Sem sombra
          ),
          visualDensity:
              VisualDensity.adaptivePlatformDensity, // Densidade adaptativa
        ),
        title: 'Online Store', // Nome do aplicativo
        initialRoute: '/login', // Rota inicial
        routes: {
          '/login': (_) => LoginScreen(), // Rota para a tela de login
          '/signup': (_) => SignupScreen(), // Rota para a tela de cadastro
          '/cart': (_) => const CartScreen(), // Rota para a tela do carrinho
          '/base': (_) => BaseScreen(), // Rota base
        },
        onGenerateRoute: (settings) {
          // Gerenciamento de rotas dinâmicas
          switch (settings.name) {
            case '/edit_product':
              final product = settings.arguments as Product?;
              return MaterialPageRoute(
                builder: (_) => EditProductScreens(p: product),
              );

            case '/produtos':
              final product = settings.arguments as Product?;
              if (product != null) {
                return MaterialPageRoute(
                  builder: (_) => ProdutosScreen(product: product),
                );
              }
              return _errorRoute('Produto inválido.');

            default:
              return _errorRoute('Rota não encontrada.');
          }
        },
      ),
    );
  }

  // Rota de erro personalizada
  Route<dynamic> _errorRoute(String message) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: const Text('Erro'), // Título do AppBar
          centerTitle: true, // Centraliza o título
          backgroundColor: Colors.red, // Fundo vermelho
        ),
        body: Center(
          child: Text(
            message, // Mensagem de erro
            style: const TextStyle(
              fontSize: 18,
              color: Colors.red, // Texto em vermelho
            ),
          ),
        ),
      ),
    );
  }
}
