class SalesChannels {
  static const String retail = 'retail';
  static const String wholesale = 'wholesale';

  static String normalize(String value) {
    switch (value) {
      case 'Retail':
        return retail;
      case 'Wholesale':
        return wholesale;
      default:
        return value;
    }
  }
}
