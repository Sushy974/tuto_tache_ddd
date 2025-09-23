import 'package:tuto_tache_ddd/app/app.dart';
import 'package:tuto_tache_ddd/bootstrap.dart';

Future<void> main() async {
  await bootstrap(() => const App());
}
