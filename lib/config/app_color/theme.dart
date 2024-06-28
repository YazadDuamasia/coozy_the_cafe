import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(4288953362),
      surfaceTint: Color(4288953362),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4294938728),
      onPrimaryContainer: Color(4282716416),
      secondary: Color(4287581236),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4294947994),
      onSecondaryContainer: Color(4284228880),
      tertiary: Color(4287508992),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4291512832),
      onTertiaryContainer: Color(4294967295),
      error: Color(4290386458),
      onError: Color(4294967295),
      errorContainer: Color(4294957782),
      onErrorContainer: Color(4282449922),
      surface: Color(4294965494),
      onSurface: Color(4280555797),
      onSurfaceVariant: Color(4283908667),
      outline: Color(4287328617),
      outlineVariant: Color(4292788406),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4282002985),
      inversePrimary: Color(4294948252),
      primaryFixed: Color(4294958031),
      onPrimaryFixed: Color(4281863168),
      primaryFixedDim: Color(4294948252),
      onPrimaryFixedVariant: Color(4286720000),
      secondaryFixed: Color(4294958031),
      onSecondaryFixed: Color(4281863168),
      secondaryFixedDim: Color(4294948252),
      onSecondaryFixedVariant: Color(4285674783),
      tertiaryFixed: Color(4294958030),
      onTertiaryFixed: Color(4281798144),
      tertiaryFixedDim: Color(4294948248),
      onTertiaryFixedVariant: Color(4286458880),
      surfaceDim: Color(4293646031),
      surfaceBright: Color(4294965494),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4294963692),
      surfaceContainer: Color(4294961635),
      surfaceContainerHigh: Color(4294632669),
      surfaceContainerHighest: Color(4294237911),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(4286260480),
      surfaceTint: Color(4288953362),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4290925095),
      onPrimaryContainer: Color(4294967295),
      secondary: Color(4285346332),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4289290824),
      onSecondaryContainer: Color(4294967295),
      tertiary: Color(4286064896),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4291512832),
      onTertiaryContainer: Color(4294967295),
      error: Color(4287365129),
      onError: Color(4294967295),
      errorContainer: Color(4292490286),
      onErrorContainer: Color(4294967295),
      surface: Color(4294965494),
      onSurface: Color(4280555797),
      onSurfaceVariant: Color(4283645495),
      outline: Color(4285618770),
      outlineVariant: Color(4287591789),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4282002985),
      inversePrimary: Color(4294948252),
      primaryFixed: Color(4290925095),
      onPrimaryFixed: Color(4294967295),
      primaryFixedDim: Color(4288756239),
      onPrimaryFixedVariant: Color(4294967295),
      secondaryFixed: Color(4289290824),
      onSecondaryFixed: Color(4294967295),
      secondaryFixedDim: Color(4287384114),
      onSecondaryFixedVariant: Color(4294967295),
      tertiaryFixed: Color(4291512832),
      onTertiaryFixed: Color(4294967295),
      tertiaryFixedDim: Color(4288821760),
      onTertiaryFixedVariant: Color(4294967295),
      surfaceDim: Color(4293646031),
      surfaceBright: Color(4294965494),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4294963692),
      surfaceContainer: Color(4294961635),
      surfaceContainerHigh: Color(4294632669),
      surfaceContainerHighest: Color(4294237911),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(4282650880),
      surfaceTint: Color(4288953362),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4286260480),
      onPrimaryContainer: Color(4294967295),
      secondary: Color(4282520065),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4285346332),
      onSecondaryContainer: Color(4294967295),
      tertiary: Color(4282520320),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4286064896),
      onTertiaryContainer: Color(4294967295),
      error: Color(4283301890),
      onError: Color(4294967295),
      errorContainer: Color(4287365129),
      onErrorContainer: Color(4294967295),
      surface: Color(4294965494),
      onSurface: Color(4278190080),
      onSurfaceVariant: Color(4281409562),
      outline: Color(4283645495),
      outlineVariant: Color(4283645495),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4282002985),
      inversePrimary: Color(4294961120),
      primaryFixed: Color(4286260480),
      onPrimaryFixed: Color(4294967295),
      primaryFixedDim: Color(4283832064),
      onPrimaryFixedVariant: Color(4294967295),
      secondaryFixed: Color(4285346332),
      onSecondaryFixed: Color(4294967295),
      secondaryFixedDim: Color(4283440136),
      onSecondaryFixedVariant: Color(4294967295),
      tertiaryFixed: Color(4286064896),
      onTertiaryFixed: Color(4294967295),
      tertiaryFixedDim: Color(4283636224),
      onTertiaryFixedVariant: Color(4294967295),
      surfaceDim: Color(4293646031),
      surfaceBright: Color(4294965494),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4294963692),
      surfaceContainer: Color(4294961635),
      surfaceContainerHigh: Color(4294632669),
      surfaceContainerHighest: Color(4294237911),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(4294948252),
      surfaceTint: Color(4294948252),
      onPrimary: Color(4284226048),
      primaryContainer: Color(4294408522),
      onPrimaryContainer: Color(4280550912),
      secondary: Color(4294958031),
      onSecondary: Color(4283768843),
      secondaryContainer: Color(4294550662),
      onSecondaryContainer: Color(4283440136),
      tertiary: Color(4294948248),
      onTertiary: Color(4284029952),
      tertiaryContainer: Color(4291512832),
      onTertiaryContainer: Color(4294967295),
      error: Color(4294948011),
      onError: Color(4285071365),
      errorContainer: Color(4287823882),
      onErrorContainer: Color(4294957782),
      surface: Color(4279963917),
      onSurface: Color(4294237911),
      onSurfaceVariant: Color(4292788406),
      outline: Color(4289104770),
      outlineVariant: Color(4283908667),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4294237911),
      inversePrimary: Color(4288953362),
      primaryFixed: Color(4294958031),
      onPrimaryFixed: Color(4281863168),
      primaryFixedDim: Color(4294948252),
      onPrimaryFixedVariant: Color(4286720000),
      secondaryFixed: Color(4294958031),
      onSecondaryFixed: Color(4281863168),
      secondaryFixedDim: Color(4294948252),
      onSecondaryFixedVariant: Color(4285674783),
      tertiaryFixed: Color(4294958030),
      onTertiaryFixed: Color(4281798144),
      tertiaryFixedDim: Color(4294948248),
      onTertiaryFixedVariant: Color(4286458880),
      surfaceDim: Color(4279963917),
      surfaceBright: Color(4282660402),
      surfaceContainerLowest: Color(4279634952),
      surfaceContainerLow: Color(4280555797),
      surfaceContainer: Color(4280818969),
      surfaceContainerHigh: Color(4281607971),
      surfaceContainerHighest: Color(4282331694),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(4294949796),
      surfaceTint: Color(4294948252),
      onPrimary: Color(4281338112),
      primaryContainer: Color(4294408522),
      onPrimaryContainer: Color(4278190080),
      secondary: Color(4294958031),
      onSecondary: Color(4283243014),
      secondaryContainer: Color(4294550662),
      onSecondaryContainer: Color(4278190080),
      tertiary: Color(4294949793),
      onTertiary: Color(4281207552),
      tertiaryContainer: Color(4294402061),
      onTertiaryContainer: Color(4278190080),
      error: Color(4294949553),
      onError: Color(4281794561),
      errorContainer: Color(4294923337),
      onErrorContainer: Color(4278190080),
      surface: Color(4279963917),
      onSurface: Color(4294965752),
      onSurfaceVariant: Color(4293117114),
      outline: Color(4290354580),
      outlineVariant: Color(4288183669),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4294237911),
      inversePrimary: Color(4286851072),
      primaryFixed: Color(4294958031),
      onPrimaryFixed: Color(4280747520),
      primaryFixedDim: Color(4294948252),
      onPrimaryFixedVariant: Color(4284882176),
      secondaryFixed: Color(4294958031),
      onSecondaryFixed: Color(4280747520),
      secondaryFixedDim: Color(4294948252),
      onSecondaryFixedVariant: Color(4284294672),
      tertiaryFixed: Color(4294958030),
      onTertiaryFixed: Color(4280682240),
      tertiaryFixedDim: Color(4294948248),
      onTertiaryFixedVariant: Color(4284686336),
      surfaceDim: Color(4279963917),
      surfaceBright: Color(4282660402),
      surfaceContainerLowest: Color(4279634952),
      surfaceContainerLow: Color(4280555797),
      surfaceContainer: Color(4280818969),
      surfaceContainerHigh: Color(4281607971),
      surfaceContainerHighest: Color(4282331694),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(4294965752),
      surfaceTint: Color(4294948252),
      onPrimary: Color(4278190080),
      primaryContainer: Color(4294949796),
      onPrimaryContainer: Color(4278190080),
      secondary: Color(4294965752),
      onSecondary: Color(4278190080),
      secondaryContainer: Color(4294949796),
      onSecondaryContainer: Color(4278190080),
      tertiary: Color(4294965752),
      onTertiary: Color(4278190080),
      tertiaryContainer: Color(4294949793),
      onTertiaryContainer: Color(4278190080),
      error: Color(4294965753),
      onError: Color(4278190080),
      errorContainer: Color(4294949553),
      onErrorContainer: Color(4278190080),
      surface: Color(4279963917),
      onSurface: Color(4294967295),
      onSurfaceVariant: Color(4294965752),
      outline: Color(4293117114),
      outlineVariant: Color(4293117114),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4294237911),
      inversePrimary: Color(4283504128),
      primaryFixed: Color(4294959319),
      onPrimaryFixed: Color(4278190080),
      primaryFixedDim: Color(4294949796),
      onPrimaryFixedVariant: Color(4281338112),
      secondaryFixed: Color(4294959319),
      onSecondaryFixed: Color(4278190080),
      secondaryFixedDim: Color(4294949796),
      onSecondaryFixedVariant: Color(4281272576),
      tertiaryFixed: Color(4294959318),
      onTertiaryFixed: Color(4278190080),
      tertiaryFixedDim: Color(4294949793),
      onTertiaryFixedVariant: Color(4281207552),
      surfaceDim: Color(4279963917),
      surfaceBright: Color(4282660402),
      surfaceContainerLowest: Color(4279634952),
      surfaceContainerLow: Color(4280555797),
      surfaceContainer: Color(4280818969),
      surfaceContainerHigh: Color(4281607971),
      surfaceContainerHighest: Color(4282331694),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
        useMaterial3: true,
        brightness: colorScheme.brightness,
        colorScheme: colorScheme,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: colorScheme.primary,
          selectionColor: colorScheme.primary.withOpacity(0.7),
          selectionHandleColor: colorScheme.primary,
        ),
        textTheme: textTheme.apply(
          bodyColor: colorScheme.onSurface,
          displayColor: colorScheme.onSurface,
        ),
        appBarTheme: AppBarTheme(
          centerTitle: false,
          titleTextStyle: textTheme.titleLarge!.copyWith(color: Colors.white),
          backgroundColor: colorScheme.primary,
          iconTheme: const IconThemeData(
            color: Colors.white,
            size: 24.0,
          ),
          actionsIconTheme: const IconThemeData(
            color: Colors.white,
            size: 24.0,
          ),
        ),
        scaffoldBackgroundColor: colorScheme.background,
        canvasColor: colorScheme.surface,
        dividerColor: colorScheme.primary,
      );

  List<ExtendedColor> get extendedColors => [];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
