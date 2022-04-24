import 'package:flutter/material.dart';
import 'meal_detail_screen.dart';
import '/meal.dart';

class MealItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;
  final int duration;
  final Complexity complexity;
  final Affordability affordability;

  MealItem({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.affordability,
    required this.complexity,
    required this.duration,
});

  String get complexityText{
    switch(complexity){
      case Complexity.Simple:
        return 'simple';
      case Complexity.Challenging:
        return 'challenging';
      case Complexity.Hard:
        return 'hard';
      default:
        return 'unknown';
    }
  }

  String get affordabilityText{
    switch(affordability){
      case Affordability.Affordable:
        return 'affordable';
      case Affordability.Pricey:
        return 'pricey';
      case Affordability.Luxurious:
        return 'expensive';
      default:
        return 'unknown';
    }
  }
  void selectMeal(BuildContext context) {
    Navigator.of(context)
        .pushNamed(
      MealDetailScreen.routeName,
      arguments:id,
    )
        .then((result){
          if(result!=null){

          }
    }
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => selectMeal(context),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 4,
        margin: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  child: Image.network(
                    imageUrl,
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  bottom:20,
                  right: 10,
                  child: Container(
                    width: 350,
                    color: Colors.black54,
                    padding: const EdgeInsets.symmetric(vertical:5,horizontal:20 ),
                  child: Text(
                  title,
                  style: const TextStyle(
                  fontSize: 26,
                  color: Colors.white,
                ),
                  softWrap: true,
                  overflow: TextOverflow.fade,
                ),
                  ),
                ),
              ],
            ),
            Padding(padding: EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Row(children:<Widget>[
                  Icon(Icons.schedule,),
                  SizedBox(width:6,),
                  Text('$duration min'),
                ],),
                Row(children:<Widget>[
                  Icon(Icons.work),
                  SizedBox(width:6,),
                  Text(complexityText),
                ],),
                Row(children:<Widget>[
                  Icon(Icons.money_off_sharp),
                  SizedBox(width:6,),
                  Text(affordabilityText),
                ],),
              ],
            )
            ),
          ],
        ),
      ),
    );
  }
}