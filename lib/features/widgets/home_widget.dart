import'package:flutter/material.dart';

class HomeWidget extends StatelessWidget{
  const HomeWidget({super.key});

  @override
  Widget build(BuildContext context){
    return Column(
      crossAxisAlignment:  CrossAxisAlignment.start,
      children: [
        Center(child:Text("Hello Everyone"))
      ],
    );
  }
}