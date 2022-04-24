import 'package:pbl_studentend_clubbed/home_screen.dart';
import 'package:pbl_studentend_clubbed/login_screen.dart';
import 'package:pbl_studentend_clubbed/signup_screen.dart';

import './cart_screen.dart';
import 'package:pbl_studentend_clubbed/category_meals_screen.dart';
import 'package:pbl_studentend_clubbed/dummy_data.dart';
import 'package:pbl_studentend_clubbed/filters_screen.dart';
import 'package:pbl_studentend_clubbed/meal_detail_screen.dart';
import 'package:pbl_studentend_clubbed/tabs_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'tabs_screen.dart';
import 'filters_screen.dart';
import 'package:flutter/material.dart';
import 'dummy_data.dart';
import 'meal.dart';
import 'canteen_end.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//1.canteen end- order display and delete
//2.time stamp
//3.estimated time
//4.proper canteen end and student end terminals

//5. password difficulty -----DONE..
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  List<Meal> _cartMeals = [];

  void _toggleCart(String mealId) {
    final existingIndex = _cartMeals.indexWhere((meal) => meal.id == mealId);
    if (existingIndex >= 0) {
      _cartMeals.removeAt(existingIndex);
    } else {
      _cartMeals.add(DUMMY_MEALS.firstWhere((meal) => meal.id == mealId));
    }
  }

  bool _isMealCart(String id) {
    return _cartMeals.any((meal) => meal.id == id);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Canteenn',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: SignupScreen(),
      routes: {
        CategoryMealsScreen.routeName: (ctx) => CategoryMealsScreen(),
        MealDetailScreen.routeName: (ctx) =>
            MealDetailScreen(_toggleCart, _isMealCart),
        FiltersScreen.routeName: (ctx) => FiltersScreen(),
        CanteenEnd.routeName: (ctx) => CanteenEnd(),
        TabsScreen.routeName: (context) => TabsScreen(_cartMeals),
        SignupScreen.routeName: (context) => SignupScreen(),
        LoginScreen.routeName: (context) => LoginScreen(),
        HomeScreen.routeName: (context) => HomeScreen(),
      },
    );
  }
}
