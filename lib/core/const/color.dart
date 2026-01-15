import 'dart:ui';

class PastelColors {
  static const pastelMint = Color(0xFFB5EAD7);
  static const pastelPeach = Color(0xFFFFCCB6);
  static const pastelLavender = Color(0xFFE0BBE4);
  static const pastelSky = Color(0xFFA8D8EA);
  static const pastelLemon = Color(0xFFFFF4A3);
  static const pastelRose = Color(0xFFFFB3BA);
  static const pastelPeriwinkle = Color(0xFFBAB8FF);
  static const pastelCoral = Color(0xFFFFC5BF);
  static const pastelAqua = Color(0xFFB4E7E8);
  static const pastelButterscotch = Color(0xFFFFE8B3);
  static const pastelLilac = Color(0xFFE6C9E6);
  static const pastelBlush = Color(0xFFFDD5D5);
  static const pastelSage = Color(0xFFD4E4BC);
  static const pastelMauve = Color(0xFFD5B8E0);
  static const pastelCream = Color(0xFFFFF5E1);
  static const pastelMisty = Color(0xFFD1E8E2);
  static const pastelPowder = Color(0xFFB8C9E6);
  static const pastelApricot = Color(0xFFFFD4B3);
  static const pastelFog = Color(0xFFE8E4E6);
  static const pastelPistachio = Color(0xFFD5E8C4);

  Color getMonthColor(int month) {
    final colors = [
      Color(0xFFB5EAD7), // Jan - Mint
      Color(0xFFFFCCB6), // Fev - Peach
      Color(0xFFE0BBE4), // Mar - Lavender
      Color(0xFFA8D8EA), // Abr - Sky
      Color(0xFFFFF4A3), // Mai - Lemon
      Color(0xFFFFB3BA), // Jun - Rose
      Color(0xFFBAB8FF), // Jul - Periwinkle
      Color(0xFFFFC5BF), // Ago - Coral
      Color(0xFFB4E7E8), // Set - Aqua
      Color(0xFFFFE8B3), // Out - Butterscotch
      Color(0xFFE6C9E6), // Nov - Lilac
      Color(0xFFFDD5D5), // Dez - Blush
    ];

    return colors[month - 1];
  }

  final pastelColorsList = [
    PastelColors.pastelMint,
    PastelColors.pastelPeach,
    PastelColors.pastelLavender,
    PastelColors.pastelSky,
    PastelColors.pastelLemon,
    PastelColors.pastelRose,
    PastelColors.pastelPeriwinkle,
    PastelColors.pastelCoral,
    PastelColors.pastelAqua,
    PastelColors.pastelButterscotch,
    PastelColors.pastelLilac,
    PastelColors.pastelBlush,
    PastelColors.pastelSage,
    PastelColors.pastelMauve,
    PastelColors.pastelCream,
    PastelColors.pastelMisty,
    PastelColors.pastelPowder,
    PastelColors.pastelApricot,
    PastelColors.pastelFog,
    PastelColors.pastelPistachio,
  ];
}