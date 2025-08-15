enum Flavor {
  DEV,
  PROD,
}

class F {
  static Flavor? appFlavor;

  static String get title {
    switch (appFlavor) {
      case Flavor.DEV:
        return 'Ez Lend Dev';
      case Flavor.PROD:
        return 'Ez Lend';
      default:
        return 'EzLend';
    }
  }

  static String get baseUrl {
    switch (appFlavor) {
      case Flavor.DEV:
        return "https://test-api.ez-lend.loans/";
      case Flavor.PROD:
        return "https://api.ez-lend.loans/";
      default:
        return "https://api.ez-lend.loans/";
    }
  }
}
