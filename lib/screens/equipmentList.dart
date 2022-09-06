import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class EquipmentList extends StatelessWidget {
  const EquipmentList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Equipment Request Application',
      home: EquipmentListPages(),
    );
  }
}

class EquipmentListPages extends StatefulWidget {
  const EquipmentListPages({Key? key}) : super(key: key);

  @override
  _EquipmentListState createState() => _EquipmentListState();
}

class _EquipmentListState extends State<EquipmentListPages> {


  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _employeeNameController = TextEditingController();
  final TextEditingController _purposeController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _specificationController = TextEditingController();

  final CollectionReference _equipment =
      FirebaseFirestore.instance.collection('equipment');

  final CollectionReference _assignedequipment =
      FirebaseFirestore.instance.collection('assignedequipment');

  Future _viewItemDetails([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {

      _nameController.text = documentSnapshot['name'];
      _descriptionController.text = documentSnapshot['description'];
      _imageController.text = documentSnapshot['image'];
      _specificationController.text = documentSnapshot['specification'];
      _codeController.text = documentSnapshot['code'];

    }

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(documentSnapshot!['image']),
                TextField(
                  enabled: false,
                  controller: _codeController,
                  decoration: const InputDecoration(labelText: 'Code'),
                ),
                TextField(
                  enabled: false,
                  controller: _specificationController,
                  decoration: const InputDecoration(labelText: 'Specification'),
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
                ElevatedButton(
                  child: const Text( 'Request'),
                  onPressed: () async {
                    _request(documentSnapshot);
                  },
                )
              ],
            ),
          );
        },
      );
  }

    Future _request([DocumentSnapshot? documentSnapshot]) async {
      if (documentSnapshot != null) {

        _nameController.text = documentSnapshot['name'];
        _descriptionController.text = documentSnapshot['description'];
        _employeeNameController.text = documentSnapshot['employeeName'];
        _purposeController.text = documentSnapshot['purpose'];
        _imageController.text = documentSnapshot['image'];
        
      }

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
              children: [
                TextField(  
                  enabled: false,
                  controller: _nameController, 
                  decoration: const InputDecoration(labelText: 'Equipment Name'),
                ),
                TextField(
                  enabled: false,
                  controller: _descriptionController, 
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                TextField(
                  controller: _employeeNameController,
                  decoration: const InputDecoration(labelText: 'Requester Name'),
                ),
                TextField(
                  controller: _purposeController,
                  decoration: const InputDecoration(labelText: 'Purpose'),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  child: const Text( 'Submit'),
                  onPressed: () async {

                    final String name = _nameController.text;
                    final String description = _descriptionController.text;
                    final String employeeName = _employeeNameController.text;
                    final String purpose = _purposeController.text;
                    final String image = _imageController.text;

                    if (description != null) {
                      await _assignedequipment.add({"name": name, "description": description, "employeeName": employeeName, "purpose": purpose, "image": image});
                      _employeeNameController.text = '';
                      _purposeController.text = '';
                      Navigator.of(context).pop();
                    }
                  },
                )
              ],
            ),
                ),
          );
        },
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Center(
          child: Text('List of Equipments', style: TextStyle(
            color: Colors.black
            ),
          ),
        ),
      backgroundColor: Colors.blue[100],
      ),
      body: StreamBuilder(
        stream: _equipment.snapshots(),
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
                              icon: const Icon(Icons.edit),
                              onPressed: () =>
                                  _viewItemDetails(documentSnapshot)),
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