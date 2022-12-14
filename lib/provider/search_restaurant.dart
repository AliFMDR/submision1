import 'dart:io';
import 'package:flutter/material.dart';
import 'package:projek2/Apiresto.dart';
import 'package:projek2/model/resto_search.dart';
import 'package:projek2/provider/list_restaurant.dart';

class SearchRestaurantProvider extends ChangeNotifier {
  final Service service;

  SearchRestaurantProvider({required this.service}) {
    fetchAllRestaurant(search);
  }

  SearchRestaurantResult? _restaurantResult;
  ResultState? _state;
  String _message = '';
  String _search = '';

  String get message => _message;

  SearchRestaurantResult? get result => _restaurantResult;

  String get search => _search;

  ResultState? get state => _state;

  Future<dynamic> fetchAllRestaurant(String search) async {
    try {
      if (search.isNotEmpty) {
        _state = ResultState.loading;
        _search = search;
        notifyListeners();
        final restaurant = await service.getTextField(search);
        if (restaurant.restaurants.isEmpty) {
          _state = ResultState.noData;
          notifyListeners();
          return _message = 'Empty Data!';
        } else {
          _state = ResultState.hasData;
          notifyListeners();
          return _restaurantResult = restaurant;
        }
      } else {
        return _message = 'text null';
      }
    } on SocketException {
      _state = ResultState.error;
      notifyListeners();
      return _message = "No internet connection";
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      return _message = 'Error --> $e';
    }
  }
}
