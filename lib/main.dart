import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeActivity(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeActivity extends StatefulWidget {
  const HomeActivity({super.key});

  @override
  _NameNumberListScreenState createState() => _NameNumberListScreenState();
}

class _NameNumberListScreenState extends State<HomeActivity> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController numberController = TextEditingController();

  List<Map<String, String>> entries = [];

  void addEntry() {
    String name = nameController.text.trim();
    String number = numberController.text.trim();

    if (name.isNotEmpty && number.isNotEmpty) {
      setState(() {
        entries.add({'name': name, 'number': number});
      });

      nameController.clear();
      numberController.clear();
    }
  }

  void confirmDelete(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Confirm Deletion"),
        content: Text("Are you sure you want to delete this contact?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                entries.removeAt(index);
              });
              Navigator.pop(context);
            },
            child: Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void makePhoneCall(String phoneNumber) async{
    final Uri url = Uri(scheme: 'tel', path: phoneNumber);
    if(await canLaunchUrl(url)){
      await launchUrl(url);
    }else{
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact List'),
        titleSpacing: 0,
        centerTitle: true,
        backgroundColor: Colors.grey,
        toolbarHeight: 60,
        toolbarOpacity: 1,
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: "Enter Name"),
            ),
            TextField(
              controller: numberController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Enter Number"),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Background color
                foregroundColor: Colors.white, // Text color
              ),
              onPressed: addEntry,
              child: Text("Add Contact"),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: entries.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: index % 2 == 0 ? Colors.blueGrey : Colors.blue,
                        foregroundColor: Colors.cyanAccent,
                        child: Text(
                          entries[index]['name']![0],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      title: Text(entries[index]['name']!),
                      subtitle: Text(entries[index]['number']!),
                      trailing: IconButton(
                          onPressed: () => makePhoneCall(entries[index]['number']!),
                          icon: Icon(Icons.phone, color: Colors.blue,)),
                      onLongPress: () => confirmDelete(index),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
