//Home_Screen
//홈화면을 나타내며, 버튼,
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class HomeScreen extends StatefulWidget{
  const HomeScreen({Key? key}) : super(key: key);

  State<HomeScreen> createState() =>_HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.green[400],

    );
  }
}