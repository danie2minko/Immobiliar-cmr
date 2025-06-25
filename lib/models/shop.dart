import 'package:flutter/material.dart';
import 'package:immobiliakamer/models/products.dart';

class Shop extends ChangeNotifier{
  final List<Products> _shop=[
    Products( type: "Maison", 
    description: "02 chambres, 01 salon, cuisine et douche", 
    prix: 70, ville: "Douala", 
    quartier: "Akwa"),

     Products( type: "Maison", 
    description: "02 chambres, 01 salon, cuisine et douche", 
    prix: 70, ville: "Douala", 
    quartier: "Akwa"),

     Products( type: "Maison", 
    description: "02 chambres, 01 salon, cuisine et douche", 
    prix: 70, ville: "Douala", 
    quartier: "Akwa"),

     Products( type: "Maison", 
    description: "02 chambres, 01 salon, cuisine et douche", 
    prix: 70, ville: "Douala", 
    quartier: "Akwa"),

     Products( type: "Maison", 
    description: "02 chambres, 01 salon, cuisine et douche", 
    prix: 70, ville: "Douala", 
    quartier: "Akwa")
  ];
  
  List <Products> get shop=> _shop;
}
