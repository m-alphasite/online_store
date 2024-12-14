import 'package:flutter/material.dart';
import 'package:online_store/common/custom_drawer/custom_drawer.dart';
import 'package:online_store/common/custom_drawer/minhas_cores.dart';
import 'package:online_store/models/home_manager.dart';
import 'package:online_store/screens/home/components/section_list.dart';
import 'package:online_store/screens/home/components/section_staggered.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MinhasCores.rosa_1,
      drawer: const CustomDrawer(),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            snap: true,
            floating: true,
            pinned: true,
            elevation: 0,
            toolbarHeight: 70.0,
            iconTheme: const IconThemeData(color: Colors.white),
            actions: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                color: Colors.white,
                onPressed: () => Navigator.of(context).pushNamed('/cart'),
              ),
            ],
            flexibleSpace: const FlexibleSpaceBar(
              title: Text(
                'Pandora Fashion',
                style: TextStyle(color: Colors.white),
              ),
              centerTitle: true,
            ),
          ),
          Consumer<HomeManager>(
            builder: (_, homeManager, __) {
              final List<Widget> children =
                  homeManager.sections.map<Widget>((section) {
                switch (section.type) {
                  case 'List':
                    return SectionList(section);
                  case 'Staggered':
                    return SectionStaggered(section);
                  default:
                    return Container();
                }
              }).toList();
              return SliverList(
                delegate: SliverChildListDelegate(children),
              );
            },
          ),
        ],
      ),
    );
  }
}
