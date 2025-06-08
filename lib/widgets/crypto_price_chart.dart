import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../constants/app_theme.dart';
import '../models/cryptocurrency.dart';

class CryptoPriceChart extends StatelessWidget {
  final Cryptocurrency crypto;
  final double height;
  final bool showLabels;

  const CryptoPriceChart({
    Key? key,
    required this.crypto,
    this.height = 100,
    this.showLabels = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: showLabels),
          titlesData: FlTitlesData(
            show: showLabels,
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: showLabels,
                getTitlesWidget: (value, meta) {
                  if (value % 3 != 0) return const Text('');
                  return Text(
                    '${value.toInt()}h',
                    style: const TextStyle(
                      color: AppTheme.textGrey,
                      fontSize: 10,
                    ),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: showLabels,
                getTitlesWidget: (value, meta) {
                  if (meta.max == meta.min) return const Text('');
                  if (value == meta.min || value == meta.max) return const Text('');
                  
                  return Text(
                    value.toStringAsFixed(0),
                    style: const TextStyle(
                      color: AppTheme.textGrey,
                      fontSize: 10,
                    ),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: _createChartData(),
              isCurved: true,
              curveSmoothness: 0.3,
              color: crypto.isPriceUp ? AppTheme.priceUp : AppTheme.priceDown,
              barWidth: 2,
              isStrokeCapRound: true,
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: crypto.isPriceUp
                    ? AppTheme.priceUp.withOpacity(0.1)
                    : AppTheme.priceDown.withOpacity(0.1),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    crypto.isPriceUp
                        ? AppTheme.priceUp.withOpacity(0.3)
                        : AppTheme.priceDown.withOpacity(0.3),
                    crypto.isPriceUp
                        ? AppTheme.priceUp.withOpacity(0.0)
                        : AppTheme.priceDown.withOpacity(0.0),
                  ],
                ),
              ),
            ),
          ],
          lineTouchData: LineTouchData(
            enabled: showLabels,
            touchTooltipData: LineTouchTooltipData(
              tooltipBgColor: AppTheme.cardDarkBackground.withOpacity(0.8),
              tooltipRoundedRadius: 8,
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((touchedSpot) {
                  return LineTooltipItem(
                    '\$${touchedSpot.y.toStringAsFixed(2)}',
                    const TextStyle(
                      color: AppTheme.textWhite,
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

  List<FlSpot> _createChartData() {
    final List<FlSpot> spots = [];
    for (int i = 0; i < crypto.sparklineData.length; i++) {
      spots.add(FlSpot(i.toDouble(), crypto.sparklineData[i]));
    }
    return spots;
  }
}
