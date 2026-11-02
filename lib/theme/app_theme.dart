import 'package:flutter/material.dart';

/// Central design tokens for the "soft & cotton-like" look.
///
/// Every screen and widget reads colors, radii, shadows, spacing, type and
/// motion from here so the whole app stays visually consistent.

class AppColors {
  AppColors._();

  // Neutrals
  static const background = Color(0xFFF7F5F9);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceMuted = Color(0xFFF1EEF5);

  // Text
  static const textPrimary = Color(0xFF3B3A4A);
  static const textSecondary = Color(0xFF8C8A9C);
  static const textTertiary = Color(0xFFB7B4C4);

  // The one soft accent (lavender) and its tints.
  static const accent = Color(0xFF9B8CF2);
  static const accentDeep = Color(0xFF7E6EE0);
  static const accentSoft = Color(0xFFE9E5FD);
  static const accentGlow = Color(0x339B8CF2);

  // Pastel product backdrops.
  static const peach = Color(0xFFFDE8E1);
  static const mint = Color(0xFFDFF3EC);
  static const sky = Color(0xFFE0ECFB);
  static const butter = Color(0xFFFDF3D9);
  static const lilac = Color(0xFFEDE7FB);
  static const blush = Color(0xFFFBE4EE);

  // Status
  static const star = Color(0xFFF5C46B);
  static const heart = Color(0xFFF08AA6);
  static const danger = Color(0xFFE88B8B);

  static const accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFB3A6F7), Color(0xFF8F7EEF)],
  );

  static const promoGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFE4DEFF), Color(0xFFFBE2EC)],
  );

  static const profileGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFE7E1FD), Color(0x00F7F5F9)],
  );
}

class AppSpacing {
  AppSpacing._();

  static const double xxs = 4;
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;

  /// Horizontal page gutter.
  static const double page = 20;
}

class AppRadii {
  AppRadii._();

  static const double sm = 16;
  static const double md = 20;
  static const double lg = 24;
  static const double xl = 28;
  static const double pill = 999;

  static const BorderRadius smAll = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius mdAll = BorderRadius.all(Radius.circular(md));
  static const BorderRadius lgAll = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius xlAll = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius pillAll = BorderRadius.all(Radius.circular(pill));
}

class AppShadows {
  AppShadows._();

  /// Barely-there lift for cards resting on the background.
  static const soft = [
    BoxShadow(color: Color(0x0F5B4E9E), blurRadius: 30, offset: Offset(0, 10)),
  ];

  /// A slightly stronger cloud for floating elements (nav bar, CTA).
  static const floating = [
    BoxShadow(color: Color(0x1A5B4E9E), blurRadius: 40, offset: Offset(0, 16)),
  ];

  /// Used while an element is pressed: closer and tighter.
  static const pressed = [
    BoxShadow(color: Color(0x0A5B4E9E), blurRadius: 14, offset: Offset(0, 4)),
  ];

  static const accentGlow = [
    BoxShadow(color: Color(0x409B8CF2), blurRadius: 28, offset: Offset(0, 12)),
  ];
}

class AppMotion {
  AppMotion._();

  static const fast = Duration(milliseconds: 250);
  static const medium = Duration(milliseconds: 350);
  static const slow = Duration(milliseconds: 450);

  static const Curve standard = Curves.easeInOutCubic;
  static const Curve gentle = Curves.easeOutCubic;

  /// Spring-like curve with a whisper of overshoot.
  static const Curve spring = Cubic(0.34, 1.36, 0.64, 1);

  static const double pressScale = 0.96;
}

class AppText {
  AppText._();

  static const String fontFamily = 'Nunito';

  static const display = TextStyle(
    fontFamily: fontFamily,
    fontSize: 28,
    height: 1.2,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -0.3,
  );

  static const title = TextStyle(
    fontFamily: fontFamily,
    fontSize: 22,
    height: 1.25,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const heading = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    height: 1.3,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const body = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    height: 1.55,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );

  static const label = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    height: 1.3,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const caption = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    height: 1.3,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );

  static const price = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    height: 1.2,
    fontWeight: FontWeight.w700,
    color: AppColors.accentDeep,
  );
}

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    final base = ThemeData(
      useMaterial3: true,
      fontFamily: AppText.fontFamily,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.accent,
        primary: AppColors.accent,
        surface: AppColors.background,
      ),
    );

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.background,
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      textTheme: base.textTheme.apply(
        bodyColor: AppColors.textPrimary,
        displayColor: AppColors.textPrimary,
      ),
    );
  }
}
