import 'package:corona_app/view/countries_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:corona_app/model/world_state_model.dart';
import 'package:corona_app/services/states_services.dart';
import 'package:pie_chart/pie_chart.dart';

class WorldStateScreen extends StatefulWidget {
  const WorldStateScreen({super.key});

  @override
  State<WorldStateScreen> createState() => _WorldStateScreenState();
}

class _WorldStateScreenState extends State<WorldStateScreen>
    with TickerProviderStateMixin {
  final colorList = <Color>[
    const Color(0xff4285F4),
    const Color(0xff1aa260),
    const Color(0xffde5246),
  ];
  late final AnimationController _controller;
  late Future<WorldStatesModel> futureWorldStates;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    futureWorldStates = StatesServices().fetchWorldStateModel();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(115, 21, 21, 21),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: FutureBuilder<WorldStatesModel>(
            future: futureWorldStates,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: SpinKitFadingCircle(size: 50, color: Colors.white),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Error: ${snapshot.error}',
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              } else if (!snapshot.hasData) {
                return const Center(
                  child: SpinKitFadingCircle(size: 50, color: Colors.white),
                );
              } else {
                WorldStatesModel worldState = snapshot.data!;
                return Column(
                  children: [
                    PieChart(
                      dataMap: {
                        'Total': worldState.cases?.toDouble() ?? 0,
                        'Recovered': worldState.recovered?.toDouble() ?? 0,
                        'Deaths': worldState.deaths?.toDouble() ?? 0,
                      },
                      animationDuration: const Duration(seconds: 3),
                      chartType: ChartType.ring,
                      legendOptions: const LegendOptions(
                        legendPosition: LegendPosition.left,
                        legendTextStyle: TextStyle(color: Colors.white),
                      ),
                      chartValuesOptions: const ChartValuesOptions(
                          showChartValuesInPercentage: true),
                      chartRadius: MediaQuery.of(context).size.width / 3.2,
                      colorList: colorList,
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.height * 0.06,
                      ),
                      child: Card(
                        color: Colors.grey.shade900,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              ReusableRow(
                                title: 'Total',
                                value: worldState.cases?.toString() ?? 'N/A',
                              ),
                              ReusableRow(
                                title: 'Recovered',
                                value:
                                    worldState.recovered?.toString() ?? 'N/A',
                              ),
                              ReusableRow(
                                title: 'Deaths',
                                value: worldState.deaths?.toString() ?? 'N/A',
                              ),
                              ReusableRow(
                                title: 'Critical',
                                value: worldState.critical?.toString() ?? 'N/A',
                              ),
                              ReusableRow(
                                title: 'Population',
                                value:
                                    worldState.population?.toString() ?? 'N/A',
                              ),
                              ReusableRow(
                                title: 'Affected Countries',
                                value:
                                    worldState.affectedCountries?.toString() ??
                                        'N/A',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) =>
                                    const CountriesScreen())));
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: const Color(0xff1aa260),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Center(
                          child: Text(
                            'Track Countries',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class ReusableRow extends StatelessWidget {
  final String title;
  final String value;

  const ReusableRow({required this.title, required this.value, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.white),
          ),
          Text(
            value,
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
