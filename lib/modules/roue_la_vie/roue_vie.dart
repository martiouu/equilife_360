import 'package:flutter/material.dart';

class RoueVie extends StatefulWidget {
  const RoueVie({super.key});

  @override
  State<RoueVie> createState() => _RoueVieState();
}

class _RoueVieState extends State<RoueVie> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xff0f17ad).withOpacity(0.8),
              const Color(0xFF6985e8),
            ],
            begin: const FractionalOffset(0.0, 0.4),
            end: Alignment.topRight,
          ),
        ),
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 300,
              padding: const EdgeInsets.only(top: 70, left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios, size: 20, color: Colors.white),
                        onPressed: () {
                          // Action to go back to the previous page
                          Navigator.of(context).pop();
                        },
                      ),
                      const Icon(Icons.info_outline, size: 20, color: Colors.white,),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text("Roue de la vie", style: TextStyle(fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold),),
                  const SizedBox(height: 5),
                  const Text("Une vue d'ensemble de sa vie", style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w500)),

                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 90,
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xff3656ba),
                              Color(0xFF6588f4),
                            ],
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                          )
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.timer, size: 20, color: Colors.white,),
                            SizedBox(width: 5),
                            Text("68 min", style: TextStyle(fontSize: 16, color: Colors.white),),
                          ],
                        ),
                      ),
                      const SizedBox(width: 40),
                      Container(
                        width: 200,
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xff3656ba),
                              Color(0xFF6588f4),
                            ],
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                          )
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.handyman_outlined, size: 20, color: Colors.white,),
                            SizedBox(width: 5),
                            Text("Reinitialiser la roue", style: TextStyle(fontSize: 16, color: Colors.white),),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Flexible(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(70),
                  ),
                ),
                child: const Column(
                  children: [
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Kiou")
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
