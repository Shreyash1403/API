import 'package:corona_app/services/states_services.dart';
import 'package:corona_app/view/display_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shimmer/shimmer.dart';

class CountriesScreen extends StatefulWidget {
  const CountriesScreen({super.key});

  @override
  State<CountriesScreen> createState() => _CountriesScreenState();
}

class _CountriesScreenState extends State<CountriesScreen> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    StatesServices statesServices = StatesServices();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: const Text('Countries'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                onChanged: (value) {
                  setState(() {});
                },
                controller: searchController,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                  hintText: 'Search with country name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<dynamic>>(
                future: statesServices.countriesListApi(),
                builder: (context, snapshot) {
                  // if (snapshot.hasError) {
                  //   return Center(child: Text('Error: ${snapshot.error}'));
                  // } else
                  if (!snapshot.hasData ||
                      snapshot.data!.isEmpty ||
                      snapshot.connectionState == ConnectionState.waiting) {
                    return ListView.builder(
                        itemCount: 8,
                        itemBuilder: (context, index) {
                          return Shimmer.fromColors(
                              baseColor: Colors.grey.shade700,
                              highlightColor: Colors.grey.shade100,
                              child: Column(
                                children: [
                                  ListTile(
                                      leading: Container(
                                        height: 10,
                                        width: 89,
                                        color: Colors.white,
                                      ),
                                      title: Container(
                                        height: 10,
                                        width: 89,
                                        color: Colors.white,
                                      ),
                                      subtitle: Container(
                                        height: 10,
                                        width: 89,
                                        color: Colors.white,
                                      ))
                                ],
                              ));
                        });
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        var country = snapshot.data![index];
                        String name = snapshot.data![index]['country'];

                        if (searchController.text.isEmpty) {
                          return Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => DisplayScreen(
                                                image: snapshot.data![index]
                                                    ['countryInfo']['flag'],
                                                name: snapshot.data![index]
                                                    ['country'],
                                                totalCases: snapshot
                                                    .data![index]['cases'],
                                                totalRecovered: snapshot
                                                    .data![index]['recovered'],
                                                totalDeaths: snapshot
                                                    .data![index]['deaths'],
                                                active: snapshot.data![index]
                                                    ['active'],
                                                test: snapshot.data![index]
                                                    ['tests'],
                                                todayRecovered:
                                                    snapshot.data![index]
                                                        ['todayRecovered'],
                                                critical: snapshot.data![index]
                                                    ['critical'],
                                              )));
                                },
                                child: ListTile(
                                  leading: Image(
                                    height: 50,
                                    width: 50,
                                    image: NetworkImage(snapshot.data![index]
                                        ['countryInfo']['flag']),
                                  ),
                                  title: Text(country['country']),
                                  subtitle: Text(
                                      'Population: ${snapshot.data![index]['population']}'),
                                ),
                              ),
                            ],
                          );
                        } else if (name
                            .toLowerCase()
                            .contains(searchController.text.toLowerCase())) {
                          return Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DisplayScreen(
                                        image: snapshot.data![index]
                                            ['countryInfo']['flag'],
                                        name: snapshot.data![index]['country'],
                                        totalCases: snapshot.data![index]
                                            ['cases'],
                                        totalRecovered: snapshot.data![index]
                                            ['recovered'],
                                        totalDeaths: snapshot.data![index]
                                            ['deaths'],
                                        active: snapshot.data![index]['active'],
                                        test: snapshot.data![index]['tests'],
                                        todayRecovered: snapshot.data![index]
                                            ['todayRecovered'],
                                        critical: snapshot.data![index]
                                            ['critical'],
                                      ),
                                    ),
                                  );
                                },
                                child: ListTile(
                                  leading: Image(
                                    height: 50,
                                    width: 50,
                                    image: NetworkImage(snapshot.data![index]
                                        ['countryInfo']['flag']),
                                  ),
                                  title: Text(country['country']),
                                  subtitle: Text(
                                      'Population: ${snapshot.data![index]['population']}'),
                                ),
                              ),
                            ],
                          );
                        } else {
                          return Container();
                        }
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
