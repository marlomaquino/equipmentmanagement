import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SecondPage extends StatefulWidget {
  const SecondPage({super.key});

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _employeeNameController = TextEditingController();
  final TextEditingController _purposeController = TextEditingController();

  final CollectionReference _assignedequipment =
    FirebaseFirestore.instance.collection('assignedequipment');
      
    Future _viewAssignedItemDetails([DocumentSnapshot? documentSnapshot]) async {
      if (documentSnapshot != null) {

        _nameController.text = documentSnapshot['name'];
        _descriptionController.text = documentSnapshot['description'];
        _employeeNameController.text = documentSnapshot['employeeName'];
        _purposeController.text = documentSnapshot['purpose'];

      }

      await showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (BuildContext ctx) {
            return Padding(
              padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(documentSnapshot!['image']),
                    TextField(
                      enabled: false,
                      controller: _employeeNameController,
                      decoration: const InputDecoration(labelText: 'Requester Name'),
                    ),
                    TextField(
                      enabled: false,
                      controller: _purposeController,
                      decoration: const InputDecoration(labelText: 'Purpose'),
                    ),
                    TextField(
                      enabled: false,
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Equipment Name'),
                    ),
                    TextField(
                      enabled: false,
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
              ),
            );
          },
      );
    }
      
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Assigned Equipments', style: TextStyle(
            color: Colors.black
            ),
          ),
        ),
      backgroundColor: Colors.blue[100],
      ),
      body: StreamBuilder(
        stream: _assignedequipment.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return ListView.builder(   
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot =
                    streamSnapshot.data!.docs[index];
                  return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(documentSnapshot['name']),
                    subtitle: Text(documentSnapshot['description']),
                    trailing: SizedBox(
                      width: 50,
                      child: Row(
                        children: [
                              IconButton(
                              icon: const Icon(Icons.remove_red_eye),
                              onPressed: () =>
                                  _viewAssignedItemDetails(documentSnapshot)),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );

        },
      ), 
    );
  }
}