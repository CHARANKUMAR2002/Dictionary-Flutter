import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';
import 'package:http/http.dart';
import 'package:google_fonts/google_fonts.dart';

class Meaning extends StatefulWidget {

  final phrase;

    const Meaning({required this.phrase});

  @override
  State<Meaning> createState() => _MeaningState();
}

class _MeaningState extends State<Meaning> {

  String apikey = "ed8aaedc7cmshf3c6a200313ac82p123172jsn50e430bde585";
  var word;
  List def = [];
  List body = [];
  List mean = [];
  ScrollController contentScroll = ScrollController();

  meaning(String phrase) async{
    Response res = await get(Uri.parse("https://api.dictionaryapi.dev/api/v2/entries/en/$phrase"),
    );
    setState(() {
      body = jsonDecode(res.body);
      body.forEach((element) { 
        Map object = element;
        String word = object['word'];
        mean = object['meanings'].forEach(
          (value){
            setState(() {
              def = value['definitions'];
            });
          }
        );
      });
    }
    );
    
    
  }

  dialog(){
    showDialog(context: context, 
    builder: (BuildContext Context){
      return AlertDialog(
    title: const Text('Search Phrase'),
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
    meaning(widget.phrase);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20,),
            InputChip(label: Text(widget.phrase), avatar: const Icon(Icons.search), 
            backgroundColor: const Color.fromARGB(255, 7, 123, 218), 
            onPressed: (){
              dialog();
            }, 
            elevation: 20, padding: const EdgeInsets.symmetric(horizontal: 15)),
            Expanded(
              child: ScrollSnapList(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext , int index){
                return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  controller: contentScroll,
                  child: Column(
                      children: [
                        SizedBox(height: 50,),
                        Container(
                          padding: EdgeInsets.all(20),
                          height: 200,
                          width: 300,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                              colors: [
                                Color(0xff12c2e9),
                                Color(0xffc471ed),
                                Color(0xfff64f59)
                              ]
                            ),
                            color: Color.fromARGB(173, 49, 44, 44)
                          ),
                          child: SelectableText("Definition: \n\n ${def[index]['definition']}\n", textAlign: TextAlign.left, style: GoogleFonts.lato(textStyle: TextStyle(fontSize: 25, fontStyle: FontStyle.italic)),),
                        ),
                        SizedBox(height: 30,),
                        
                        def[index]['example'] != null ? Container(
                          padding: EdgeInsets.all(20),
                          height: 200,
                          width: 300,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                              colors: [
                                Color(0xff12c2e9),
                                Color(0xffc471ed),
                                Color(0xfff64f59)
                              ]
                            ),
                            color: Color.fromARGB(173, 49, 44, 44)
                          ),
                          child: SelectableText("Example: \n\n${def[index]['example']}\n", textAlign: TextAlign.left, style: GoogleFonts.lato(textStyle: TextStyle(fontSize: 25, fontStyle: FontStyle.italic)),),
                        ) :
                        SizedBox(height: 20,),
                      ],
                    ),
                );
              }, 
              itemCount: def.length,
              itemSize: 300,
              dynamicItemSize: true,
              focusOnItemTap: true,
              onItemFocus: (index){},
              ),
            ),
            SizedBox(height: 20,)
          ]
          ),
        ),
      ),
    );
  }
}
