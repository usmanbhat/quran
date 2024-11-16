import 'package:flutter/material.dart';
import 'database_helper.dart';

void main() => runApp(SepiaApp());

class SepiaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sepia Flutter App',
      theme: ThemeData(
        primarySwatch: Colors.brown,
        cardColor: Color(0xFFF5E6CC), // Sepia color
        textTheme: TextTheme(
          bodyText2: TextStyle(color: Colors.brown[900]),
        ),
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Map<String, dynamic>>> items;

  @override
  void initState() {
    super.initState();
    items = _fetchItems();
  }

  Future<List<Map<String, dynamic>>> _fetchItems() async {
    final db = await DatabaseHelper.instance.database;
    return await db.query('your_table_name'); // Replace with your table name
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sepia Flutter App'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: items,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final items = snapshot.data!;

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              return Card(
                margin: EdgeInsets.all(8.0),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        items[index]
                            ['title'], // Adjust field names as necessary
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(items[index]
                          ['description']), // Adjust field names as necessary
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
