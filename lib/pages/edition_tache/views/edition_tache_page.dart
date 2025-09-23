import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tuto_tache_ddd/pages/edition_tache/bloc/edition_tache_bloc.dart';
import 'package:tuto_tache_ddd/pages/edition_tache/bloc/edition_tache_event.dart';
import 'package:tuto_tache_ddd/pages/edition_tache/views/edition_tache_view_mobile.dart';

class EditionTachePage extends StatelessWidget {
  const EditionTachePage({super.key});

  static Page<void> page() => const MaterialPage<void>(
    child: EditionTachePage(),
    name: '/edition_tache',
  );

  static Route<bool?> route() => MaterialPageRoute<bool?>(
    builder: (_) => const EditionTachePage(),
    settings: const RouteSettings(name: '/edition_tache'),
  );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EditionTacheBloc()..add(const EditionTacheInitialisee()),
      child: const EditionTacheViewMobile(),
    );
  }
}
