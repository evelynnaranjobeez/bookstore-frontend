import 'package:bookstore_app_web/src/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';


class LifeExpectancyGraphPage extends StatefulWidget {
  final HomeController controller;

  const LifeExpectancyGraphPage({super.key, required this.controller});

  @override
  _LifeExpectancyGraphPageState createState() => _LifeExpectancyGraphPageState();
}

class _LifeExpectancyGraphPageState extends State<LifeExpectancyGraphPage> {
  bool loading = true; // To track if the data is still being fetched
  List<FlSpot> graphData = []; // Data points for the graph
  bool unauthorizad = false; // To track if the user is unauthorized

  @override
  void initState() {
    super.initState();
    fetchLifeExpectancyData(); // Fetch data when the widget is first loaded
  }

  // Function to fetch life expectancy data from the World Bank API
  Future<void> fetchLifeExpectancyData() async {

      List<dynamic> jsonData =
          await widget.controller.fetchLifeExpectancyData();

      // Check if the response contains an unauthorized message
      if (jsonData[0] is Map<String, dynamic> && jsonData[0]['message'] == 'Unauthorized.') {
        setState(() {
          unauthorizad = true;
        });
        return;
      }

      List<dynamic> data = jsonData;

      List<FlSpot> spots = [];
      for (var i = 0; i < data.length; i++) {
        double year = double.parse(data[i]['date']); // Get the year
        double lifeExpectancy = data[i]['value'] ??
            0.0; // Get life expectancy value (default 0.0 if null)

        if (lifeExpectancy != 0.0) {
          // Only add valid life expectancy data
          spots.add(FlSpot(
              year, lifeExpectancy)); // Add a new data point (year, value)
        }
      }

      setState(() {
        graphData =
            spots; // Update the state with the data points for the graph
        loading = false; // Indicate that data has finished loading
      });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:!unauthorizad? AppBar(title: const Text('Esperanza de vida en Ecuador')):null,
      body: unauthorizad
          ?  Center(
              child: Text(
                  'No autorizado para ver los datos', style: Theme.of(context).textTheme.titleMedium )) // Show unauthorized message
          : loading
              ? const Center(
                  child:
                      CircularProgressIndicator()) // Show loading indicator while fetching data
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: LineChart(
                    // Display the graph once the data is ready
                    LineChartData(
                      gridData: const FlGridData(
                          show: true), // Show grid lines on the graph
                      titlesData: FlTitlesData(
                        leftTitles: const AxisTitles(
                          axisNameWidget:
                              Text('Esperanza de vida (años)'),
                          // Y-axis label
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: AxisTitles(
                          axisNameWidget:
                              const Text('Año'), // X-axis label (year)
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 1, // Interval of 1 year between labels
                            getTitlesWidget: (value, meta) {
                              // Customize the X-axis labels
                              return Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  value.toInt().toString(), // Display the year
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 5),
                                ),
                              );
                            },
                          ),
                        ),
                        rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        // Hide right-side titles
                        topTitles: const AxisTitles(
                            sideTitles: SideTitles(
                                showTitles: false)), // Hide top-side titles
                      ),

                      lineBarsData: [
                        LineChartBarData(
                          spots: graphData,
                          // Data points to display on the graph
                          isCurved: true,
                          // Smooth the line
                          color: Colors.green,
                          // Line color
                          dotData: const FlDotData(show: true),
                          // Show data points on the graph
                          barWidth: 4,
                          // Width of the line
                          belowBarData: BarAreaData(
                              show: true,
                              color: Colors.green.withOpacity(
                                  0.2)), // Fill area under the line
                        ),
                      ],
                      lineTouchData: LineTouchData(
                        // Configure what happens when the user taps on a data point
                        touchTooltipData: LineTouchTooltipData(
                          getTooltipItems: (List<LineBarSpot> touchedSpots) {
                            return touchedSpots.map((spot) {
                              final year = spot.x
                                  .toInt(); // Get the year from the touched spot
                              final value = spot.y.toStringAsFixed(
                                  2); // Get the life expectancy value
                              return LineTooltipItem(
                                'Año: $year\nEsperanza de vida: $value',
                                // Display year and life expectancy
                                const TextStyle(color: Colors.white),
                              );
                            }).toList();
                          },
                        ),
                      ),
                    ),
                  ),
                ),
    );
  }
}
