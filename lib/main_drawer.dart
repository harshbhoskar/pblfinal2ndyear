import 'package:pbl_studentend_clubbed/cart_screen.dart';
import 'package:pbl_studentend_clubbed/filters_screen.dart';
import 'package:pbl_studentend_clubbed/tabs_screen.dart';
import './login_screen.dart';
import 'package:flutter/material.dart';
import 'filters_screen.dart';
import 'cart_screen.dart';
import 'canteen_end.dart';

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
              height: 120,
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              alignment: Alignment.centerLeft,
              color: Theme.of(context).colorScheme.secondary,
              child: const Text('Welcome User')),
          const SizedBox(
            height: 20,
          ),
          ListTile(
            leading: const Icon(
              Icons.restaurant,
            ),
            title: const Text(
              'canteen end',
            ),
            onTap: () {
              Navigator.of(context).pushNamed(CanteenEnd.routeName);
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.settings,
            ),
            title: const Text(
              'filters',
            ),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(FiltersScreen.routeName);
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.logout,
            ),
            title: const Text(
              'logout',
            ),
            onTap: () {
              Navigator.pushReplacementNamed(context, LoginScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
}
