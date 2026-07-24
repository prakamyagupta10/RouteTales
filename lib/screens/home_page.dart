import 'package:flutter/material.dart';

import '../widgets/feature_card.dart';
import 'map_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController destinationController =
  TextEditingController();

  @override
  void dispose() {
    destinationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xff2193b0),
              Color(0xff6dd5ed),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: 900,
              margin: const EdgeInsets.all(30),
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.travel_explore,
                    size: 90,
                    color: Colors.blue,
                  ),

                  const SizedBox(height: 15),

                  const Text(
                    "RouteTales",
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    "Your AI Powered Road Trip Companion",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 40),

                  TextField(
                    controller: destinationController,
                    decoration: InputDecoration(
                      hintText: "Enter your destination",
                      prefixIcon: const Icon(Icons.location_on),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  SizedBox(
                    width: 250,
                    height: 55,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.navigation),
                      label: const Text("Start Journey"),
                      onPressed: () {
                        if (destinationController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Please enter a destination",
                              ),
                            ),
                          );
                          return;
                        }

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MapPage(
                              destination:
                              destinationController.text.trim(),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 50),

                  const FeatureCard(
                    icon: Icons.auto_stories,
                    title: "AI Storytelling",
                    subtitle:
                    "Hear fascinating stories about every place you pass.",
                  ),

                  const SizedBox(height: 15),

                  const FeatureCard(
                    icon: Icons.restaurant,
                    title: "Food Discovery",
                    subtitle:
                    "Discover top-rated restaurants and local cuisine.",
                  ),

                  const SizedBox(height: 15),

                  const FeatureCard(
                    icon: Icons.location_city,
                    title: "Historical Places",
                    subtitle:
                    "Explore forts, temples and hidden gems on your route.",
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}