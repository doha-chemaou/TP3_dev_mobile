import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:grouped_buttons/grouped_buttons.dart';


List liste = [];
List liste_ = [];
List resultats_ = [];
String description = "";
class DB {

  static Future<void> addsQuestion(String id, String i, String q, String c1,
      String c2, String c3, String c4, String b_n){//}, String r_c) {
    CollectionReference ref = FirebaseFirestore.instance.collection(
        "questions");
    //ref.doc(id);
    return
      ref.doc(id).set({
        'image_url': i,
        'question': q,
        'choix 1': c1,
        'choix 2': c2,
        'choix 3': c3,
        'choix 4': c4,
        'bonne réponse': b_n,
        'réponse choisie': "",
      }).then((value) => print("question Added"))
          .catchError((error) => print("Question not added: $error"));
  }
  static void fillingDB() {
    addsQuestion(
        "coupe du monde 2014",
        "https://www.laculturegenerale.com/wp-content/uploads/2019/12/quiz-culture-generale-debutant-4.jpg",
        "Quel pays a remporté la coupe du monde de football en 2014 ?",
        "Italie",
        "Argentine",
        "Allemagne",
        "Brésil",
        "Allemagne",
        );

    addsQuestion(
        "roméo et juliette",
        "https://www.laculturegenerale.com/wp-content/uploads/2019/12/quiz-culture-generale-debutant-5.jpg",
        "Dans quelle ville italienne l'action de la pièce Shakespeare (Roméo et Juliette) se situe-elle ?",
        "Venise",
        "Rome",
        "Milan",
        "Vérone",
        "Vérone",
        );

    addsQuestion(
        "animal rapide",
        "https://www.laculturegenerale.com/wp-content/uploads/2019/12/quiz-culture-generale-debutant-8.jpg",
        "Parmi les animaux suivants, lequel peut se déplacer le plus rapidement ?",
        "léopard",
        "mgdobe",
        "springbok",
        "chevreuil",
        "springbok",
        );

    addsQuestion(
        "Alea jacta",
        "https://www.laculturegenerale.com/wp-content/uploads/2019/12/quiz-culture-generale-debutant-2.jpg",
        "Qui a dit : « Le sort en est jeté » (Alea jacta est) ?",
        "Attila",
        "César",
        "Vertingétorix",
        "Auguste",
        "César",
        );
  }
  dynamic data;
  Future<dynamic> getData(String id) async {
    final data = await FirebaseFirestore.instance.collection("questions").doc(id).get(); //get the data;
    return data;
  }
  static Future<List> getCloudFirestoreQuestions() async {
    final firestoreInstance = FirebaseFirestore.instance;
    List l = [];
    liste_ = [];
    firestoreInstance.collection("questions").get().then((querySnapshot) {
      querySnapshot.docs.forEach((value) {
        l.add(value.data()); //(value.data());
        liste_.add(value.id);
      });
    }).catchError((onError) {
    });
    return l;
  }
  static Future<void> meth() async {
    liste = await getCloudFirestoreQuestions();

  }


  static Future<List> resultatss() async {
    //print("uuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu");
    //print(resultats_.isEmpty);
    if (resultats_.isEmpty){
      for (int i = 0 ; i < liste.length ; i++){
        resultats_.add("fausse");
      }
    }

    int k = 0;
    final firestoreInstance = await FirebaseFirestore.instance;
    firestoreInstance.collection("questions").get().then((querySnapshot) {
      querySnapshot.docs.forEach((value) {
        String bonne_reponse = value.data()["bonne réponse"];
        String reponse_choisie = value.data()["réponse choisie"];
        //print("___________________________");
        //print(bonne_reponse == reponse_choisie);
        //print(bonne_reponse);
        //print(reponse_choisie);
        resultats_[k] =  (bonne_reponse==reponse_choisie)? "juste" : "fausse" ; //(value.data());
        //print(resultats_[k]);
        k++;
      });
    }).catchError((onError) {
    }) ;

    return resultats_;
  }

  //final data = await FirebaseFirestore.instance.collection("questions").doc(id).get(); //get the data;
  //return data;
  static void description_(){
    //print("***********************************here");
    //if(!resultats_.isEmpty)
      //resultats_ = [];
    resultatss();
    //final data = FirebaseFirestore.instance.collection("questions").get(); //get the data;
    //print("@@@@@@@@@@@@@@@@");
    //print(data);
      description = "";
      description+="\n\n";
      //await FirebaseFirestore.instance;
      for(int i = 0 ; i < liste.length ; i++){
        int k = i + 1;
        //print("_________________");
        //print()
        //print(resultats_[i]);
        description += "      Question " + k.toString() + " : " + resultats_[i] + "\n\n\n";
      }

  }

}
Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  DB.fillingDB();
  DB.meth();
  runApp(const MyApp());
}
 /**/
bool rep1 = false, rep2 = false, rep3 = false, rep4 = false;
String s_rep1 = "fausse",s_rep2="fausse",s_rep3="fausse",s_rep4="fausse";



void booltoString(){
  if(rep1) s_rep1 = "juste";
  if(rep2) s_rep2 = "juste";
  if(rep3) s_rep3 = "juste";
  if(rep4) s_rep4 = "juste";
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,//Color(0xFFAEEA00)
      ),
      home: const MyHomePage(
          title: 'Questions / Réponses'
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String description = "Bienvenue au Quizz. \nVous aurez 4 questions "
      "auxquelles vous pouvez répondre. \nPour chacune d'elles, vous avez "
      "4 propositions, l'une d'elle est juste. \nA la fin du quizz, vous aurez le résultat. \nVous pourrez ainsi "
      "refaire le quizz si vous le souhaitez ou bien participer à l'enrichissement de ce quizz en ajoutant une question.";


  void gotoQu1(BuildContext context){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MyQu1(title: '',)),
    );
  }

  @override
  Widget build(BuildContext context) {
    DB.meth();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width:300,
              //height:490,
              //color: const Color(0xFF607D8B),
              decoration: BoxDecoration(
                color: const Color(0xFF607D8B),
                border: Border.all(
                  color: Colors.black,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  description,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            Container(
              constraints: BoxConstraints(maxWidth: 250.0, minHeight: 50.0),
              //margin: EdgeInsets.all(10),
              margin: const EdgeInsets.only( left: 10, top: 20,right: 10),
              child: ElevatedButton(
                onPressed: () {
                  //resultats_ = [];
                  //print("begin-------------------------------------------------------");
                  for (int i = 0 ; i < liste.length  ; i++)
                    FirebaseFirestore.instance.collection('questions').doc(liste_[i]).update({'réponse choisie': ""});
                  resultats_ = [];
                  //liste_ = [];
                  //print(resultats_.isEmpty);
                  //DB.description_();
                  /*Future<FirebaseApp> _initializeFirebase() async {
                    FirebaseApp firebaseApp = await Firebase.initializeApp();

                    return firebaseApp;
                  }*/
                  //_initializeFirebase();
                  //Firebase.initializeApp();


                  gotoQu1(context);
                },
                style: ElevatedButton.styleFrom(
                  primary: const Color(0xFF76FF03), // background //0xFFAEEA00  0xFF64DD17 0xFF7CB342
                  onPrimary: Colors.white, // foreground
                ),
                //color: Theme.of(context).accentColor,
                child: Padding(
                  padding: EdgeInsets.all(0),
                  child: Container(
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const <Widget>[
                        Text(
                          'Commencer le Quizz',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.black,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class MyQu1 extends StatefulWidget {
  const MyQu1({Key? key, required this.title}) : super(key: key);

  final String title;


  @override
  State<MyQu1> createState() => Qu1();
}
class Qu1 extends State<MyQu1>{
  //DB qu1 = DB("","","","","","","");

  //String description = "Quel pays a remporté la coupe du monde de football en 2014 ?";
  void gotoResultats(BuildContext context){

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MyResultats(title: '',)),
    );

  }


  @override
  Widget build(BuildContext context) {
    List<String>? _checked = [];
    print("ooooooooooooooooooooooooooooooooooooooo");
    print(liste.length);
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text("Questions / Réponses"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 20),
            for (int i = 0 ; i < liste.length; i++)
              new Container(
                child: Column(children: [
                  new Container(margin: const EdgeInsets.only(bottom: 20),
                    child: Center(
                      child: Container(
                        decoration: BoxDecoration(
                          //color: const Color(0xFFFF80AB),
                          image: DecorationImage(
                              image: NetworkImage(liste[i]["image_url"]),
                              fit: BoxFit.cover),
                          border: Border.all(
                            color: const Color(0xFFFF80AB),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(200),
                        ),
                        width: 100,
                        height: 100,
                      ),
                    ),),
                  new Container(
                    margin: const EdgeInsets.only( bottom: 20),
                    width:300,
                    //height:125,
                    //color: const Color(0xFF607D8B),
                    decoration: BoxDecoration(
                      color: const Color(0xFF607D8B),
                      border: Border.all(
                        color: Colors.black,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        liste[i]["question"],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  new CheckboxGroup (
                      labels: <String>[
                        liste[i]["choix 1"],
                        liste[i]["choix 2"],
                        liste[i]["choix 3"],
                        liste[i]["choix 4"],
                      ],
                      //checkColor: const Color(0xFFFF80AB),
                      //fillColor: MaterialStateProperty.resolveWith(const Color(0xFFFF80AB)),
                      //value: isChecked,
                      //disabled: ["Wednesday", "Friday"],
                    onSelected: (List<String> checked) {
                      if (checked.length > 1) {
                        checked.removeAt(0);
                        //print('selected length  ${selected.length}');
                      }
                        //if(checked.toString() == liste[i]["bonne réponse"]){
                        //}
                        //print(checked.toString());
                      //print("______________________________________________");
                      //print(checked[0]);
                      /*print("______________________________________");
                      for (int i = 0 ; i < liste.length ; i++) {
                        print(liste[i]);
                        print("\n\n");
                      }*/
                      print("hehehehheheheheheheheh");
                      print(checked==[]);
                      //Future.delayed(const Duration(milliseconds: 500), () {

                        // Here you can write your code
                        print("______________________________________");
                        //for(int j = 0 ; j < liste_.length ; j++)
                        print(liste_);
                        print(liste.length);
                        FirebaseFirestore.instance.collection('questions').doc(liste_[i]).update({'réponse choisie': (checked==[]? "":checked[0])});
                        print(i);
                        print("#################################################");
                        //print(FirebaseFirestore.instance.collection('questions').doc(liste_[i])["réponse choisie"]);
                        //setState(() {
                          // Here you can write your code for open new view
                        //});

                      // });
                    }
                    ),

                  Divider(
                    height: 50,
                    thickness: 5,
                    color : const Color(0xFFFF80AB) ,
                  ),

                ]),
              ),
            Container(
              constraints: BoxConstraints(maxWidth: 400.0, minHeight: 50.0),
              //margin: EdgeInsets.all(10),
              margin: const EdgeInsets.only( left: 10, top: 20,right: 10,bottom:20),
            child : ElevatedButton(
              onPressed: () {
                //FirebaseFirestore.instance.collection("questions").get().then((querySnapshot) {
                  DB.description_();
                  /*DB.description_();
                for (int i = 0 ; i < liste.length ; i++){
                  print("hehehehhehehehhehe");
                  print(resultats_[i]);
                }*/
                  Future.delayed(const Duration(milliseconds: 500), () {

                    // Here you can write your code
                    gotoResultats(context);

                    setState(() {
                      // Here you can write your code for open new view
                    });

                  });

                //});
              },
              style: ElevatedButton.styleFrom(
                primary: const Color(0xFFFF80AB), // background //0xFFAEEA00  0xFF64DD17 0xFF7CB342
                onPrimary: Colors.white, // foreground
              ),
              //color: Theme.of(context).accentColor,
              child: Padding(
                padding: EdgeInsets.all(0),
                child: Container(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const <Widget>[
                      Text(
                        'voir les résultats',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward,
                        color: Colors.black,
                      )
                    ],
                  ),
                ),
              ),
            ),
    ),
            Divider(
              height: 50,
              thickness: 5,
              color : const Color(0xFFFF80AB) ,
            ),

          ],
        ),
      ),
    );
    throw UnimplementedError();
  }

}

class MyResultats extends StatefulWidget {

  const MyResultats({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyResultats> createState() => Resultats();
}
class Resultats extends State<MyResultats> {
  final firestoreInstance = FirebaseFirestore.instance;

  //List resultats = [];

  //String description = "" ;

  void gotoHome(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MyHomePage(title: '',)),
    );
  }
  void gotoAdd(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Addquestion(title: '',)),
    );
  }

  @override
  Widget build(BuildContext context) {
    DB.description_();
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text("Questions / Réponses"),
      ),
      body:RawScrollbar(
      thumbColor: const Color(0xFFFF80AB),
      thickness: 10,
      isAlwaysShown: true,
      radius: Radius.circular(10),
      //color : const Color(0xFF76FF03),
      child: SingleChildScrollView(
      padding: EdgeInsets.all(30),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              //for (int i = 0 ; i < 1 ; i ++) resultats_ = DB.description_();
              Container(

                margin: const EdgeInsets.only(left: 10, top: 40, right: 10),
                width: 300,
                //height:490,
                //color: const Color(0xFF607D8B),
                decoration: BoxDecoration(
                  color: const Color(0xFF607D8B),
                  border: Border.all(
                    color: Colors.black,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    description,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              Container(
                constraints: BoxConstraints(maxWidth: 250.0, minHeight: 50.0),
                //margin: EdgeInsets.all(10),
                margin: const EdgeInsets.only(left: 10, top: 20, right: 10),
                child: ElevatedButton(
                  onPressed: () {
                    //resultats_ = [];
                    //print("-------------------------------------------------------");
                    //print(resultats_.isEmpty);
                    /*for (int i = 0 ; i < liste.length ; i++){
                    resultats_[i] = "fausse";
                  }*/
                    Future.delayed(const Duration(milliseconds: 500), () {
                      // Here you can write your code
                      gotoHome(context);
                      setState(() {
                        // Here you can write your code for open new view
                      });
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    primary: const Color(0xFF76FF03),
                    // background //0xFFAEEA00  0xFF64DD17 0xFF7CB342
                    onPrimary: Colors.white, // foreground
                  ),
                  //color: Theme.of(context).accentColor,
                  child: Padding(
                    padding: EdgeInsets.all(0),
                    child: Container(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const <Widget>[
                          Text(
                            'Refaire le quizz',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward,
                            color: Colors.black,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                constraints: BoxConstraints(maxWidth: 250.0, minHeight: 50.0),
                //margin: EdgeInsets.all(10),
                margin: const EdgeInsets.only(left: 10, top: 20, right: 10),
                child: ElevatedButton(
                  onPressed: () {
                    //resultats_ = [];
                    //print("-------------------------------------------------------");
                    //print(resultats_.isEmpty);
                    /*for (int i = 0 ; i < liste.length ; i++){
                    resultats_[i] = "fausse";
                  }*/
                    //Future.delayed(const Duration(milliseconds: 500), () {
                      // Here you can write your code
                      gotoAdd(context);
                      //setState(() {
                        // Here you can write your code for open new view
                      //});
                    //});
                  },
                  style: ElevatedButton.styleFrom(
                    primary: const Color(0xFFFF80AB),
                    // background //0xFFAEEA00  0xFF64DD17 0xFF7CB342
                    onPrimary: Colors.white, // foreground
                  ),
                  //color: Theme.of(context).accentColor,
                  child: Padding(
                    padding: EdgeInsets.all(0),
                    child: Container(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const <Widget>[
                          Text(
                            'Ajouter une question',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward,
                            color: Colors.black,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }
}

class Addquestion extends StatefulWidget {
  const Addquestion({Key? key, required this.title}) : super(key: key);

  final String title;


  @override
  State<Addquestion> createState() => Addqu();
}
class Addqu extends State<Addquestion>{
  //DB qu1 = DB("","","","","","","");

  //String description = "Quel pays a remporté la coupe du monde de football en 2014 ?";
  void gotoHomepage(BuildContext context){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MyHomePage(title: '',)),
    );

  }

  final titre = TextEditingController();
  final question = TextEditingController();
  final choix_1 = TextEditingController();
  final choix_2 = TextEditingController();
  final choix_3 = TextEditingController();
  final choix_4 = TextEditingController();
  final image_url = TextEditingController();
  final bonne_reponse = TextEditingController();


  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    titre.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<String>? _checked = [];

    // TODO: implement build
    return Scaffold(
      resizeToAvoidBottomInset: false ,
      appBar: AppBar(
        title: const Text("Questions / Réponses"),
      ),
      body: RawScrollbar(
        thumbColor: const Color(0xFFFF80AB),
        thickness: 10,
        isAlwaysShown: true,
        radius: Radius.circular(10),
        //color : const Color(0xFF76FF03),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(30),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 20),
            //Expanded(
            //child:
            Padding(//id
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextFormField(
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'titre',
                ),
                controller: titre,

              ),
            ),
    //),
            Padding(//question
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextFormField(
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'question',
                ),
                controller: question,

              ),
            ),
            Padding(// choix 1
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextFormField(
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'choix 1',
                ),
                controller :choix_1,
              ),
            ),
            Padding(// choix 2
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextFormField(
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  //fillColor: const Color(0xFFFF80AB),
                  labelText: 'choix 2',
                ),
                controller : choix_2,
              ),
            ),
            Padding(// choix 3
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextFormField(
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'choix 3',
                ),
                controller : choix_3,
              ),
            ),
            Padding(// choix 4
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextFormField(
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'choix 4',
                ),
                controller : choix_4,
              ),
            ),
            /*Padding(// image_url
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextFormField(
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: "url d'image",
                ),
                controller : image_url,
              ),
            ),*/
            Padding(// bonne réponse
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextFormField(
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'bonne réponse',
                ),
                controller : bonne_reponse,
              ),
            ),
            Container(
              constraints: BoxConstraints(maxWidth: 250.0, minHeight: 50.0),
              //margin: EdgeInsets.all(10),
              margin: const EdgeInsets.only(left: 10, top: 20, right: 10),
              child: ElevatedButton(
                onPressed: () {
                  Future.delayed(const Duration(milliseconds: 500), () {
                    // Here you can write your code
                    if(!titre.text.isEmpty && !bonne_reponse.text.isEmpty && !question.text.isEmpty &&
                        !choix_1.text.isEmpty && !choix_2.text.isEmpty && !choix_3.text.isEmpty && !choix_4.text.isEmpty)
                      DB.addsQuestion(titre.text,"https://c8.alamy.com/compfr/r31yc2/alphabet-de-fleurs-question-mark-r31yc2.jpg",question.text,choix_1.text,choix_2.text,choix_3.text,choix_4.text,bonne_reponse.text.toString());
                    DB.meth();
                    gotoHomepage(context);
                    setState(() {
                      // Here you can write your code for open new view
                    });
                  });

                    //setState(() {
                      // Here you can write your code for open new view
                    //});
                  //});
                },
                style: ElevatedButton.styleFrom(
                  primary: const Color(0xFF76FF03),
                  onPrimary: Colors.white, // foreground
                ),
                child: Padding(
                  padding: EdgeInsets.all(0),
                  child: Container(
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const <Widget>[
                        Text(
                          'Ajouter',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.black,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    ),
    );
    throw UnimplementedError();
  }

}



