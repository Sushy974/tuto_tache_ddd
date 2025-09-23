import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tuto_tache_ddd/pages/detail_tache/bloc/detail_tache_bloc.dart';
import 'package:tuto_tache_ddd/pages/detail_tache/bloc/detail_tache_event.dart';
import 'package:tuto_tache_ddd/pages/detail_tache/views/detail_tache_view_mobile.dart';

class DetailTachePage extends StatelessWidget {
  const DetailTachePage({super.key});

  static Page<void> page() => const MaterialPage<void>(
    child: DetailTachePage(),
    name: '/detail_tache',
  );

  static Route<bool?> route() => MaterialPageRoute<bool?>(
    builder: (_) => const DetailTachePage(),
    settings: const RouteSettings(name: '/detail_tache'),
  );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DetailTacheBloc()..add(const DetailTacheCharge()),
      child: const DetailTacheViewMobile(),
    );
  }
}
