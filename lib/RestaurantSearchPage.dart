import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import 'package:projek2/Apiresto.dart';
import 'package:projek2/widget_Search_resto.dart';
import 'package:projek2/provider/search_restaurant.dart';
import 'package:projek2/provider/list_restaurant.dart';

class RestaurantSearchPage extends StatefulWidget {
  const RestaurantSearchPage({Key? key}) : super(key: key);
  @override
  State<RestaurantSearchPage> createState() => _RestaurantSearchPageState();
}

class _RestaurantSearchPageState extends State<RestaurantSearchPage> {
  TextEditingController controller = TextEditingController();
  String hasil = "";

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SearchRestaurantProvider>(
      create: (_) => SearchRestaurantProvider(service: Service(Client())),
      child: Consumer<SearchRestaurantProvider>(builder: (context, state, _) {
        return Scaffold(
          backgroundColor: Colors.grey.shade100,
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.all(15.0),
                  padding: const EdgeInsets.only(left: 20, right: 10),
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 93, 161, 240),
                      boxShadow: [
                        BoxShadow(
                            offset: const Offset(0, 10),
                            blurRadius: 50,
                            color: Colors.grey.shade500.withOpacity(0.23))
                      ]),
                  child: TextField(
                    controller: controller,
                    style: TextStyle(color: Colors.black.withOpacity(0.6)),
                    decoration: InputDecoration(
                      hintText: 'Search',
                      hintStyle:
                          TextStyle(color: Colors.black.withOpacity(0.23)),
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      suffixIcon: Icon(
                        Icons.search,
                        color: Colors.black.withOpacity(0.6),
                      ),
                    ),
                    onChanged: (String query) {
                      if (query.isNotEmpty) {
                        setState(() {
                          hasil = query;
                        });
                        state.fetchAllRestaurant(hasil);
                      }
                    },
                  ),
                ),
                (hasil.isEmpty)
                    ? const Center(
                        child: Text('Search Restaurant'),
                      )
                    : Consumer<SearchRestaurantProvider>(
                        builder: (context, state, _) {
                          if (state.state == ResultState.loading) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (state.state == ResultState.hasData) {
                            return ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: state.result!.restaurants.length,
                              itemBuilder: (context, index) {
                                var restaurant =
                                    state.result!.restaurants[index];
                                return CardSearch(restaurant: restaurant);
                              },
                            );
                          } else if (state.state == ResultState.noData) {
                            return Center(child: Text(state.message));
                          } else if (state.state == ResultState.error) {
                            return Center(child: Text(state.message));
                          } else {
                            return const Center(
                                child:
                                    Text('Sorry, please check your network.'));
                          }
                        },
                      ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
