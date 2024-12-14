import 'package:flutter/material.dart'; // Importa o pacote Flutter para construção de interfaces
import 'package:online_store/common/custom_drawer/custom_drawer.dart'; // Importa o drawer personalizado
import 'package:online_store/common/custom_drawer/minhas_cores.dart'; // Importa as cores personalizadas
import 'package:online_store/models/home_manager.dart'; // Importa o gerenciador de home
import 'package:online_store/screens/home/components/section_list.dart'; // Importa o componente SectionList
import 'package:online_store/screens/home/components/section_staggered.dart'; // Importa o componente SectionStaggered
import 'package:provider/provider.dart'; // Importa o pacote provider para gerenciamento de estado

// Classe HomeScreen que estende StatelessWidget para criar a tela inicial
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MinhasCores.rosa_1, // Define a cor de fundo do Scaffold
      drawer: const CustomDrawer(), // Adiciona o drawer personalizado
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            snap: true, // Permite que a AppBar apareça ao puxar para baixo
            floating: true, // Faz a AppBar flutuar
            pinned: true, // Fixa a AppBar no topo
            elevation: 0, // Remove a sombra da AppBar
            toolbarHeight: 70.0, // Define a altura da AppBar
            iconTheme: const IconThemeData(
                color: Colors.white), // Define a cor dos ícones como branco
            actions: [
              IconButton(
                icon: const Icon(
                    Icons.shopping_cart), // Ícone de carrinho de compras
                color: Colors.white, // Cor do ícone
                onPressed: () => Navigator.of(context).pushNamed(
                    '/cart'), // Navega para a tela de carrinho ao clicar
              ),
            ],
            flexibleSpace: const FlexibleSpaceBar(
              title: Text(
                'Pandora Fashion', // Título da AppBar
                style: TextStyle(color: Colors.white),
              ),
              centerTitle: true, // Centraliza o título
            ),
          ),
          Consumer<HomeManager>(
            builder: (_, homeManager, __) {
              // Obtém as seções do HomeManager
              final List<Widget> children =
                  homeManager.sections.map<Widget>((section) {
                switch (section.type) {
                  case 'List':
                    return SectionList(section); // Retorna a SectionList
                  case 'Staggered':
                    return SectionStaggered(
                        section); // Retorna a SectionStaggered
                  default:
                    return Container(); // Retorna um Container vazio para tipos desconhecidos
                }
              }).toList();
              return SliverList(
                delegate: SliverChildListDelegate(
                    children), // Define a delegate da lista de seções
              );
            },
          ),
        ],
      ),
    );
  }
}
