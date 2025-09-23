abstract class Horloge {
  DateTime maintenant();
}

class HorlogeSysteme implements Horloge {
  @override
  DateTime maintenant() {
    return DateTime.now();
  }
}
