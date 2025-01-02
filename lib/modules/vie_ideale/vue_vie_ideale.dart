import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../services/retour_vie_ideale_service.dart';
import '../../services/list_vie_ideale_service.dart';

class VueVieIdeale extends StatefulWidget {
  const VueVieIdeale({super.key});

  @override
  State<VueVieIdeale> createState() => _VueVieIdealeState();
}

class _VueVieIdealeState extends State<VueVieIdeale> {
  late Future<List<Map<String, String>>> _dataFuture;

  @override
  void initState() {
    super.initState();
    _dataFuture = _fetchTitlesQuestionsAndObjectifs();
  }

  // Fonction pour récupérer les titres, questions et objectifs correspondants aux réponses
  Future<List<Map<String, String>>> _fetchTitlesQuestionsAndObjectifs() async {
    try {
      final returnService = ReturnVieIdealeService();
      final listService = ListVieIdealeService();

      // Récupérer les données des réponses aux questionnaires
      final responseData = await returnService.fetchData();

      // Extraire les UUIDs des réponses
      final roueQuestionUuids = (responseData['data'] as List)
          .map((item) => item['roues_question_uuid'] as String)
          .toList();

      // Extraire les objectifs des réponses
      final objectifs = (responseData['data'] as List)
          .map((item) => item['objectif'] as String)
          .toList();

      // Récupérer tous les titres, questions et UUIDs
      final titles = await listService.listTitles();
      final questions = await listService.listQuestions();
      final uuids = await listService.listUuids();

      // Liste combinée des titres, questions et objectifs correspondants
      final matchedData = <Map<String, String>>[];

      // Associer les UUIDs avec les titres, questions et objectifs correspondants
      for (var i = 0; i < uuids.length; i++) {
        if (roueQuestionUuids.contains(uuids[i])) {
          matchedData.add({
            'title': titles[i],
            'question': questions[i],
            'objectif': objectifs[i],  // Ajouter l'objectif correspondant
          });
        }
      }

      return matchedData;
    } catch (e) {
      print('Error fetching data: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(20.0),
            bottomLeft: Radius.circular(20.0),
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.cyan.shade700,
        centerTitle: true,
        title: const Text(
          "Ma vie idéale",
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white, // Change la couleur de l'icône de retour ici
        ),
      ),
      body: FutureBuilder<List<Map<String, String>>>(
        future: _dataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: SpinKitWave(
              color: Colors.cyan,
              size: 20.0,
            ));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Aucune donnée n'a été trouvée"));
          } else {
            final data = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: data.length,
              itemBuilder: (context, index) {
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    //color: Colors.cyan.shade900,
                    border: Border.all(color: Colors.cyan.shade900)
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data[index]['title'] ?? '',
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        data[index]['question'] ?? '',
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                        ),
                      ),
                      const Divider(color: Colors.black38),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 15,
                            child: Image.asset("assets/fusee (1).webp"),
                          ),
                          const SizedBox(width: 10),
                          Expanded(  // Ajoutez Expanded ici
                            child: Text(
                              data[index]['objectif'] ?? '',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontStyle: FontStyle.italic,
                              ),
                              softWrap: true,
                              overflow: TextOverflow.visible,
                            ),
                          ),
                        ],
                      ),

                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
