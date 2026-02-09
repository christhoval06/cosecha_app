class Currency {
  final String code;
  final String symbol;

  const Currency({
    required this.code,
    required this.symbol,
  });
}

const List<Currency> defaultCurrencies = [
  Currency(code: 'USD', symbol: r'$'),
  Currency(code: 'EUR', symbol: '€'),
  Currency(code: 'PEN', symbol: 'S/'),
  Currency(code: 'MXN', symbol: r'$'),
  Currency(code: 'COP', symbol: r'$'),
];
