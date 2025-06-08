import 'package:flutter/material.dart';
import '../constants/app_theme.dart';
import '../models/cryptocurrency.dart';
import 'package:fl_chart/fl_chart.dart';

class TradingScreen extends StatefulWidget {
  const TradingScreen({Key? key}) : super(key: key);

  @override
  State<TradingScreen> createState() => _TradingScreenState();
}

class _TradingScreenState extends State<TradingScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _timeIntervals = ['1H', '4H', '1D', '1W', '1M', '1Y'];
  String _selectedTimeInterval = '1D';
  bool _isBuying = true;

  // Simulate selected crypto - in real app this would be passed in or managed with state management
  final Cryptocurrency _selectedCrypto = Cryptocurrency.mockData[0];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      appBar: AppBar(
        backgroundColor: AppTheme.darkBackground,
        elevation: 0,
        title: Row(
          children: [
            _buildCryptoIconSmall(),
            const SizedBox(width: 8),
            Text(
              '${_selectedCrypto.name}/${_selectedCrypto.symbol.toUpperCase()}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textWhite,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.star_border),
            color: AppTheme.textGrey,
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
            color: AppTheme.textGrey,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildPriceHeader(),
          _buildTimeIntervals(),
          _buildPriceChart(),
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildSpotTrading(),
                _buildFuturesTrading(),
                _buildMarginTrading(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCryptoIconSmall() {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: AppTheme.primaryColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          _selectedCrypto.symbol.substring(0, 1).toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildPriceHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _selectedCrypto.formattedPrice,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textWhite,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: _selectedCrypto.isPriceUp
                          ? AppTheme.priceUp.withOpacity(0.15)
                          : AppTheme.priceDown.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      _selectedCrypto.formattedPriceChange,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: _selectedCrypto.isPriceUp
                            ? AppTheme.priceUp
                            : AppTheme.priceDown,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '24h Change',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.textGrey,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              _buildStatItem('24h High', '\$${_selectedCrypto.high24h}'),
              const SizedBox(width: 20),
              _buildStatItem('24h Low', '\$${_selectedCrypto.low24h}'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppTheme.textGrey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppTheme.textWhite,
          ),
        ),
      ],
    );
  }

  Widget _buildTimeIntervals() {
    return Container(
      height: 36,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: _timeIntervals.length,
        itemBuilder: (context, index) {
          final interval = _timeIntervals[index];
          final isSelected = interval == _selectedTimeInterval;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedTimeInterval = interval;
              });
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.primaryColor : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? AppTheme.primaryColor : AppTheme.textGrey,
                  width: 1,
                ),
              ),
              child: Text(
                interval,
                style: TextStyle(
                  color: isSelected ? Colors.white : AppTheme.textGrey,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPriceChart() {
    return Container(
      height: 250,
      padding: const EdgeInsets.all(16),
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(
            show: true,
            drawVerticalLine: true,
            horizontalInterval: 1,
            verticalInterval: 1,
            getDrawingHorizontalLine: _getDrawingLine,
            getDrawingVerticalLine: _getDrawingLine,
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  const style = TextStyle(
                    color: AppTheme.textGrey,
                    fontSize: 10,
                  );
                  Widget text;
                  switch (value.toInt()) {
                    case 0:
                      text = const Text('Jan', style: style);
                      break;
                    case 2:
                      text = const Text('Mar', style: style);
                      break;
                    case 4:
                      text = const Text('May', style: style);
                      break;
                    case 6:
                      text = const Text('Jul', style: style);
                      break;
                    case 8:
                      text = const Text('Sep', style: style);
                      break;
                    case 10:
                      text = const Text('Nov', style: style);
                      break;
                    default:
                      text = const Text('');
                      break;
                  }
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    space: 8,
                    child: text,
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  if (value == meta.max || value == meta.min) {
                    return Container();
                  }
                  return Text(
                    '\$${value.toInt()}K',
                    style: const TextStyle(
                      color: AppTheme.textGrey,
                      fontSize: 10,
                    ),
                    textAlign: TextAlign.left,
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          minX: 0,
          maxX: 11,
          minY: 0,
          maxY: 6,
          lineBarsData: [
            LineChartBarData(
              spots: const [
                FlSpot(0, 3),
                FlSpot(1, 2.5),
                FlSpot(2, 3.1),
                FlSpot(3, 3.2),
                FlSpot(4, 2.8),
                FlSpot(5, 3.5),
                FlSpot(6, 3.9),
                FlSpot(7, 3.2),
                FlSpot(8, 4),
                FlSpot(9, 3.8),
                FlSpot(10, 4.2),
                FlSpot(11, 4.5),
              ],
              isCurved: true,
              color: AppTheme.primaryColor,
              barWidth: 2,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: AppTheme.chartGradientStart,
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppTheme.chartGradientStart,
                    AppTheme.chartGradientEnd,
                  ],
                ),
              ),
            ),
          ],
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              tooltipBgColor: AppTheme.cardDarkBackground.withOpacity(0.8),
              getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                return touchedBarSpots.map((barSpot) {
                  return LineTooltipItem(
                    '\$${(barSpot.y * 1000).toInt()}',
                    const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }).toList();
              },
            ),
          ),
        ),
      ),
    );
  }

  static FlLine _getDrawingLine(double value) {
    return FlLine(
      color: AppTheme.cardLightBackground,
      strokeWidth: 1,
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: AppTheme.darkBackground,
      child: TabBar(
        controller: _tabController,
        labelColor: AppTheme.textWhite,
        unselectedLabelColor: AppTheme.textGrey,
        indicatorColor: AppTheme.primaryColor,
        tabs: const [
          Tab(text: 'Spot'),
          Tab(text: 'Futures'),
          Tab(text: 'Margin'),
        ],
      ),
    );
  }

  Widget _buildSpotTrading() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBuySellToggle(),
          const SizedBox(height: 20),
          _buildAmountInput('Amount', 'BTC'),
          const SizedBox(height: 16),
          _buildAmountInput('Price', 'USDT'),
          const SizedBox(height: 16),
          _buildTotalSection(),
          const SizedBox(height: 24),
          _buildTradeButton(),
        ],
      ),
    );
  }

  Widget _buildBuySellToggle() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardDarkBackground,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _isBuying = true;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _isBuying ? AppTheme.priceUp : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    'Buy',
                    style: TextStyle(
                      color: _isBuying ? Colors.white : AppTheme.textGrey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _isBuying = false;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: !_isBuying ? AppTheme.priceDown : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    'Sell',
                    style: TextStyle(
                      color: !_isBuying ? Colors.white : AppTheme.textGrey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountInput(String label, String currency) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppTheme.textGrey,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          style: const TextStyle(color: AppTheme.textWhite),
          decoration: InputDecoration(
            hintText: '0.00',
            hintStyle: const TextStyle(color: AppTheme.textGrey),
            filled: true,
            fillColor: AppTheme.cardDarkBackground,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            suffixText: currency,
            suffixStyle: const TextStyle(
              color: AppTheme.textGrey,
              fontWeight: FontWeight.bold,
            ),
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
        ),
      ],
    );
  }

  Widget _buildTotalSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Total',
          style: TextStyle(
            color: AppTheme.textGrey,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.cardDarkBackground,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '0.00',
                style: TextStyle(
                  color: AppTheme.textWhite,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'USDT',
                style: TextStyle(
                  color: AppTheme.textGrey,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTradeButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: _isBuying ? AppTheme.priceUp : AppTheme.priceDown,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed: () {
        // Handle trade action
      },
      child: Text(
        _isBuying ? 'Buy BTC' : 'Sell BTC',
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Placeholder widgets for other trading types
  Widget _buildFuturesTrading() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          'Futures Trading Interface',
          style: TextStyle(color: AppTheme.textWhite),
        ),
      ),
    );
  }

  Widget _buildMarginTrading() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          'Margin Trading Interface',
          style: TextStyle(color: AppTheme.textWhite),
        ),
      ),
    );
  }
}
