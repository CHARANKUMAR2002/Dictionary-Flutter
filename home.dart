import 'meaning.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:google_fonts/google_fonts.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final style = const TextStyle(fontSize: 20);
  final quoteStyle = const TextStyle(fontSize: 20,);
  final authorStyle = const TextStyle(fontSize: 20,);
  var word = "Search A Word";
  String url = "https://motivational-quotes1.p.rapidapi.com/motivation";
  String apikey = "ed8aaedc7cmshf3c6a200313ac82p123172jsn50e430bde585";
  var quote;
  var author;

  quotes() async{

    var quote = await post(Uri.parse(url),
    headers: {
      'content-type': 'application/json',
      'X-RapidAPI-Key': apikey,
      'X-RapidAPI-Host': 'motivational-quotes1.p.rapidapi.com'
    }
    );
    var split = quote.body.split("-");
    var first = split.first;
    var last = split.last;
    setState(() {
      this.quote = first;
      author = last;
    });
  }

  dialog(){
    showDialog(context: context, 
    builder: (BuildContext Context){
      return AlertDialog(
    title: Text('Search Phrase'),
    content: TextField(
      autofocus: true,
      onSubmitted: (value) {
        setState(() {
          word = value;
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Meaning(phrase: word,)));
        });
      },
    ),
    
  );
    }
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    quotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dictionary", style: GoogleFonts.actor(textStyle: style)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15))),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          InputChip(label: Text(word), avatar: Icon(Icons.search), 
          backgroundColor: Color.fromARGB(255, 7, 123, 218),
          
          onPressed: (){
            dialog();
          }, 
          elevation: 20, padding: EdgeInsets.symmetric(horizontal: 15)),
                Center(
                    child: Container(
                      padding: EdgeInsets.all(20),
                      height: 250, 
                      width: 300,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          Color(0xfffc00ff),
                          Color(0xff00dbde)
                        ]),
                        borderRadius: BorderRadius.circular(20),
                        color: Color.fromARGB(173, 49, 44, 44)
                      ),
                      child: quote != null ? SingleChildScrollView(
                        controller: ScrollController(),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SelectableText("$quote", textAlign: TextAlign.justify, style: GoogleFonts.notoSans(textStyle: quoteStyle),),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                author != "null" ? SelectableText("- $author", textAlign: TextAlign.right, style: GoogleFonts.dancingScript(textStyle: authorStyle),) :
                                Text("- Unknown", textAlign: TextAlign.right, style: GoogleFonts.dancingScript(textStyle: authorStyle),),
                              ],
                            )
                          ],
                        ),
                      )
                      : Center(
                            child: CircularProgressIndicator(color: Color.fromARGB(255, 7, 123, 218),),
                    ),
                  ),
                  ),
                
                SizedBox(width: 30,),
              ],
            ),
    );
  }
}