import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tuto_tache_ddd/pages/liste_taches/bloc/liste_taches_bloc.dart';
import 'package:tuto_tache_ddd/pages/liste_taches/bloc/liste_taches_event.dart';
import 'package:tuto_tache_ddd/pages/liste_taches/views/liste_taches_view_mobile.dart';

class ListeTachesPage extends StatelessWidget {
  const ListeTachesPage({super.key});

  static Page<void> page() => const MaterialPage<void>(
    child: ListeTachesPage(),
    name: '/liste_taches',
  );

  static Route<bool?> route() => MaterialPageRoute<bool?>(
    builder: (_) => const ListeTachesPage(),
    settings: const RouteSettings(name: '/liste_taches'),
  );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ListeTachesBloc()..add(const ListeTachesDemarre()),
      child: const ListeTachesViewMobile(),
    );
  }
}
