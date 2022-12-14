import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:projek2/model/resto_list.dart';
import 'package:projek2/Apiresto.dart';

enum ResultState { loading, noData, hasData, error }

class RestaurantProvider extends ChangeNotifier {
  final Service service;

  RestaurantProvider({required this.service}) {
    _fetchAllRestaurant();
  }

  late RestaurantResult _restaurantResult;
  ResultState _state = ResultState.loading;
  String _message = '';

  String get message => _message;

  RestaurantResult get result => _restaurantResult;

  ResultState get state => _state;

  Future<dynamic> _fetchAllRestaurant() async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final article = await service.RestaurantList();
      if (article.restaurants.isEmpty) {
        _state = ResultState.noData;
        notifyListeners();
        return _message = 'Empty Data';
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        return _restaurantResult = article;
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
