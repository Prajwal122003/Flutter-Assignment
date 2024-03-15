import 'package:flutter/material.dart'; 
import 'package:http/http.dart' as http; 
import 'dart:convert'; 
import 'dart:core'; 
import 'package:url_launcher/url_launcher.dart'; 

void main() => runApp(MyApp()); 

class News { 
final String title; 
final String image; 
final String content; 
final String url; 

News({required this.title, required this.image, required this.content, required this.url}); 

factory News.fromJson(Map<String, dynamic> json) { 
	return News( 
	title: json['title'], 
	image: json['urlToImage'], 
	content: json['content'], 
	url: json["url"] 
	); 
} 
} 

class NewsCard extends StatelessWidget { 
final News news; 

NewsCard({required this.news}); 

void _launchURL(String url) async { 
	final Uri _url = Uri.parse(url); 
	if (!await launchUrl(_url,mode: LaunchMode.inAppWebView)) { 
	throw 'Could not launch $url'; 
} 
} 

@override 
Widget build(BuildContext context) { 
	return Card( 
	margin: EdgeInsets.all(8.0), 
	child: ExpansionTile( 
		leading: Image.network(news.image), 
		title: Text(news.title,style: 
		TextStyle(color: Colors.green,fontSize: 16, 
		fontWeight: FontWeight.w400),), 
		children: <Widget>[ 
		Padding( 
			padding: EdgeInsets.all(10.0), 
			child: Text( 
			news.content, 
			style: TextStyle(fontSize: 16.0), 
			), 
		), 
		InkWell( 
			child: Text("Read More",style: TextStyle(color: Colors.blue,height: 3),), 
			onTap: (){ 
			_launchURL(news.url); 
			} 
		) 
		], 
	), 
	); 
} 
} 

class MyApp extends StatefulWidget { 
@override 
_MyAppState createState() => _MyAppState(); 
} 

class _MyAppState extends State<MyApp> { 
List<News> _news = []; 

@override 
void initState() { 
	super.initState(); 
	_getNewsData(); 
} 

Future<void> _getNewsData() async { 
http.Response newsResponse; 
String apiKey = "YOUR_API_KEY"; 
String urlString = 
	"https://newsapi.org/v2/top-headlines?sources=techcrunch&apiKey=$apiKey"; 
	
Uri uri = Uri.parse(urlString); 
newsResponse = await http.get(uri); 

if (newsResponse.statusCode == 200) { 
	Map<String, dynamic> jsonData = json.decode(newsResponse.body); 
	if (jsonData['articles'] != null) { 
	List<dynamic> articles = jsonData['articles']; 
	_news = articles.map((json) => News.fromJson(json)).toList(); 
	} else { 
	throw Exception('No articles found in the response'); 
	} 
} else { 
	throw Exception('Failed to load news'); 
} 
} 


@override 
Widget build(BuildContext context) { 
	return MaterialApp( 
	title: 'Gfg News Reader App', 
	debugShowCheckedModeBanner: false, 
	home: Scaffold( 
		backgroundColor: const Color.fromARGB(255, 202, 242, 203), 
		appBar: AppBar( 
		title: Text('Gfg News Reader App'), 
		backgroundColor: Colors.green, 
		), 
		body: _news==null ? CircularProgressIndicator() :ListView.builder( 
				itemCount: _news.length, 
				itemBuilder: (context, index) { 
				return NewsCard(news: _news[index]); 
				}, 
			), 
	), 
	); 
} 
} 
