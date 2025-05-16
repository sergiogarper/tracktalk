class UsuarioGlobal {
  static int? id;
  static String? nombre;
  static String? email;

  static void reset() {
    id = null;
    nombre = null;
    email = null;
  }

  static bool get isLoggedIn => id != null;
}
