import 'package:flutter/material.dart';
import 'package:immobiliakamer/components/mybuttom.dart';

class PremierePage extends StatelessWidget {
  const PremierePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //logo
            
               Icon(
                 Icons.real_estate_agent,
                 size: 180,
                 color: Theme.of(context).colorScheme.inversePrimary,
               ),
              const SizedBox(height: 10,), 
            //titre
                Text("IMMOBILIA",
                style: TextStyle(
                  fontSize: 25, fontWeight: FontWeight.bold
                ),
                ),
            //sous titre
                Text("L'immobilier à portée de main.",
                style: TextStyle(
                  fontWeight: FontWeight.normal
                ),),
                const SizedBox(height: 40,),
            //boutons
                MyButton(onTap: ()=>Navigator.pushReplacementNamed(context, '/acceuil'),
                child: Text("Continuer en tant que visiteur",
                style: TextStyle(
                  color: Colors.black
                ),)),
                const SizedBox(height: 20,),
                ElevatedButton(onPressed: () =>Navigator.pushReplacementNamed(context,'/login'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  backgroundColor: Colors.grey.shade700
                ),
                child: Text("Se connecter",
                style: TextStyle(
                  color: Colors.white
                ),))
          ],
        ),
      ),
    );
  }
}