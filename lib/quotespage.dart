
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;

class QuotesPage extends StatefulWidget {
   // QuotesPage({Key? key}) : super(key: key);

  final String categname;
  QuotesPage(this.categname);

  @override
  _QuotesPageState createState() => _QuotesPageState();
}

class _QuotesPageState extends State<QuotesPage> {
  List quotes=[];
  List author=[];
  bool isData=false;
  void initState(){
    super.initState();
    getQuotes();
  }
  getQuotes()async{
    String url="https://quotes.toscrape.com/tag/${widget.categname}/";
    Uri uri=Uri.parse(url);
    http.Response response=await http.get(uri);
    dom.Document document=parser.parse(response.body);
    final quotesclass=document.getElementsByClassName("quote");
    quotes=quotesclass.map((element)=>element.getElementsByClassName('text')[0].innerHtml).toList();
    author=quotesclass.map((element)=>element.getElementsByClassName('author')[0].innerHtml).toList();
    setState(() {
      isData=true;
    });

  }
  List<String> categories = ["love", "inspirational", "life", "humor"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Column(
          children: [
        Container ( alignment: Alignment. center,
        margin: EdgeInsets.only(top: 50),
          child: Text("${widget.categname} quotes". toUpperCase(),style: TextStyle(color:Colors.black, fontSize: 25),),
        ),

            ListView.builder (
                shrinkWrap: true, physics: NeverScrollableScrollPhysics(),
                 itemCount: quotes. length, itemBuilder: (context, index) {
              return Container(
                  padding: EdgeInsets.all(19),
                  child: Card(
                    elevation: 10,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 20.0, left: 20, bottom: 20),
                          child: Text(
                              quotes[index], style: TextStyle(color: Colors
                              .black, fontSize: 30)),
                        ),
                      ],
                    ),
                  )
              );
            })
      // Text

          ],
        ),
      ),
    );
  }
}