class Cryptocurrency {
  final String id;
  final String name;
  final String symbol;
  final String image;
  final double currentPrice;
  final double priceChangePercentage24h;
  final double high24h;
  final double low24h;
  final double marketCap;
  final double volume24h;
  final List<double> sparklineData;

  Cryptocurrency({
    required this.id,
    required this.name,
    required this.symbol,
    required this.image,
    required this.currentPrice,
    required this.priceChangePercentage24h,
    required this.high24h,
    required this.low24h,
    required this.marketCap,
    required this.volume24h,
    required this.sparklineData,
  });

  bool get isPriceUp => priceChangePercentage24h >= 0;

  String get formattedPrice => '\$${currentPrice.toStringAsFixed(currentPrice < 1 ? 4 : 2)}';

  String get formattedPriceChange {
    final sign = isPriceUp ? '+' : '';
    return '$sign${priceChangePercentage24h.toStringAsFixed(2)}%';
  }

  // Sample data for UI mockup
  static List<Cryptocurrency> mockData = [
    Cryptocurrency(
      id: 'bitcoin',
      name: 'Bitcoin',
      symbol: 'BTC',
      image: 'assets/icons/btc.png',
      currentPrice: 64253.21,
      priceChangePercentage24h: 2.34,
      high24h: 65102.34,
      low24h: 63021.56,
      marketCap: 1258000000000,
      volume24h: 28500000000,
      sparklineData: [
        63200, 63400, 63900, 64100, 64300, 64200, 64250, 64100, 64050, 64200, 64300, 64250
      ],
    ),
    Cryptocurrency(
      id: 'ethereum',
      name: 'Ethereum',
      symbol: 'ETH',
      image: 'assets/icons/eth.png',
      currentPrice: 3456.78,
      priceChangePercentage24h: -1.25,
      high24h: 3521.45,
      low24h: 3412.34,
      marketCap: 417000000000,
      volume24h: 15300000000,
      sparklineData: [
        3510, 3490, 3470, 3450, 3430, 3440, 3460, 3450, 3440, 3450, 3460, 3456
      ],
    ),
    Cryptocurrency(
      id: 'binancecoin',
      name: 'BNB',
      symbol: 'BNB',
      image: 'assets/icons/bnb.png',
      currentPrice: 612.34,
      priceChangePercentage24h: 3.78,
      high24h: 615.67,
      low24h: 589.23,
      marketCap: 94300000000,
      volume24h: 2120000000,
      sparklineData: [
        590, 595, 600, 605, 610, 608, 612, 614, 612, 611, 612, 612
      ],
    ),
    Cryptocurrency(
      id: 'solana',
      name: 'Solana',
      symbol: 'SOL',
      image: 'assets/icons/sol.png',
      currentPrice: 143.21,
      priceChangePercentage24h: 5.67,
      high24h: 144.56,
      low24h: 135.78,
      marketCap: 62500000000,
      volume24h: 3450000000,
      sparklineData: [
        136, 138, 140, 139, 141, 142, 143, 142, 143, 142, 143, 143
      ],
    ),
    Cryptocurrency(
      id: 'cardano',
      name: 'Cardano',
      symbol: 'ADA',
      image: 'assets/icons/ada.png',
      currentPrice: 0.45,
      priceChangePercentage24h: -2.34,
      high24h: 0.47,
      low24h: 0.44,
      marketCap: 16000000000,
      volume24h: 542000000,
      sparklineData: [
        0.47, 0.46, 0.45, 0.44, 0.45, 0.46, 0.45, 0.44, 0.45, 0.45, 0.45, 0.45
      ],
    ),
  ];
}
