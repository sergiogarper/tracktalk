import 'package:tracktalk/shared/models/cancion_model.dart';

class PlayerMemory {
  static Cancion? ultimaCancion;
  static double posicion = 0;
  static bool estabaReproduciendo = false;

  static void guardar(Cancion cancion, double pos, bool isPlaying) {
    ultimaCancion = cancion;
    posicion = pos;
    estabaReproduciendo = isPlaying;
  }

  static void limpiar() {
    ultimaCancion = null;
    posicion = 0;
    estabaReproduciendo = false;
  }
}
