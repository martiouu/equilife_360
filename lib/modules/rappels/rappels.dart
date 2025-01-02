import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class RappelPage extends StatefulWidget {
  const RappelPage({super.key});

  @override
  State<RappelPage> createState() => _RappelPageState();
}

class _RappelPageState extends State<RappelPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade200,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.cyan, // Change la couleur de l'icône de retour ici
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              "Modifier",
              style: TextStyle(color: Colors.cyan, fontSize: 16),
            ),
          )
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 20),
                SizedBox(
                  height: 40,
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      hintText: "Recherche",
                      prefixIcon: const Icon(Ionicons.search, color: Colors.cyan),
                      suffixIcon: _controller.text.isNotEmpty
                          ? IconButton(
                        icon: const Icon(Ionicons.close, color: Colors.cyan),
                        onPressed: () => _controller.clear(),
                      )
                          : null,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, 'Today');
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.all(8),
                        width: size.width * 0.45,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Colors.cyan.shade800,
                                  child: Image.asset("assets/aujourdhui.webp"),
                                ),
                                const Spacer(),
                                const Text(
                                  "0",
                                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                            const Spacer(),
                            const Row(
                              children: [
                                Text(
                                  "Aujourd'hui",
                                  style: TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w500),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {},
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.all(8),
                        width: size.width * 0.45,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  child: Image.asset("assets/calendrier.webp"),
                                ),
                                const Spacer(),
                                const Text(
                                  "0",
                                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const Spacer(),
                            const Row(
                              children: [
                                Text(
                                  "Programmés",
                                  style: TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w500),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {},
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.all(8),
                        width: size.width * 0.45,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Colors.white,
                                  child: Image.asset("assets/boite-demballage.webp"),
                                ),
                                const Spacer(),
                                const Text(
                                  "0",
                                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                            const Spacer(),
                            const Row(
                              children: [
                                Text(
                                  "Tous",
                                  style: TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w500),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {},
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.all(8),
                        width: size.width * 0.45,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  child: Image.asset("assets/reverifier.webp", width: 30),
                                ),
                                const Spacer(),
                                const Text(
                                  "0",
                                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                            const Spacer(),
                            const Row(
                              children: [
                                Text(
                                  "Terminés",
                                  style: TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w500),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            child: TextButton(
              onPressed: () {
                // Action à réaliser lors de l'appui sur le bouton "Rappel"
              },
              child: Row(
                children: [
                  Image.asset("assets/plus.webp", width: 20,),
                  const SizedBox(width: 5),
                  const Text(
                    "Rappel",
                    style: TextStyle(color: Colors.cyan, fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
