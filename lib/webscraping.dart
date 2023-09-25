
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:webscraping/quotespage.dart';


class WebScraping extends StatefulWidget {
  const WebScraping({Key? key}) : super(key: key);


  @override
  _WebScrapingState createState() => _WebScrapingState();
}
class _WebScrapingState extends State<WebScraping> {
  List quotes=[];
  List author=[];
  bool isData=false;
  void initState(){
    super.initState();
    getQuotes();
  }
  getQuotes()async{
    String url="https://quotes.toscrape.com/";
    Uri uri=Uri.parse(url);
    http.Response response=await http.get(uri);
    dom.Document document=parser.parse(response.body);
    final quotesclass=document.getElementsByClassName("quote");
    quotes=quotesclass.map((element)=>element.getElementsByClassName('text')[0].innerHtml).toList();
    print(quotes);
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
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top:50),
              child: Text("Quotes", style: TextStyle(fontSize: 20, color: Colors.deepOrange),),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                children: categories.map((category){
                  return InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => QuotesPage(category)));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.pink,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(category.toUpperCase(), style: TextStyle(fontSize: 20, color: Colors.white),)),
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 20,),
             isData == false ? Center(child: CircularProgressIndicator()) : ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: quotes.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.all(10),
                    child: Card(
                      elevation: 10,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0, left: 20, bottom: 20),
                            child: Text(quotes[index], style: TextStyle(fontSize: 18, color: Colors.black, fontWeight:FontWeight.bold),),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0, left: 20, bottom: 20),
                            child: Text(author[index], style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold,),),
                          ),
                          ],
                        ),
                      ),
                    );
                  },
             )
          ],
        ),
      ),
    );
  }
}