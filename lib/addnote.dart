import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class newnote extends StatefulWidget {
  const newnote({super.key});

  @override
  State<newnote> createState() => _newnoteState();
}
class _newnoteState extends State<newnote> {

  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override

  void addUser() {
    if (_formKey.currentState!.validate()) {
      String name = titleController.text;
      String content=contentController.text;
      String date=contentController.text;

      FirebaseFirestore.instance
          .collection('Notes')
          .add({
          'note_title': name,
          'note_content' :content,
          'note_time' :date,
      })
          .then((value) => print('User added successfully'))
          .catchError((error) => print('Failed to add user: $error'));

      // titleController.clear();
      // contentController.clear();
      // dateController.clear();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Note'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [

                  TextFormField(
                    controller: titleController,
                    decoration: InputDecoration(
                      labelText: 'Title',
                    ),

                  ),
                  TextFormField(
                    controller: contentController,
                    decoration: InputDecoration(
                      labelText: 'Content',
                    ),
                  ),
            TextFormField(
              controller: dateController,
              decoration: InputDecoration(
                labelText: 'Date',
              ),
            ),


            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: (){
                addUser();
              },
              child: Text('Add'),
            ),
            // StreamBuilder<QuerySnapshot>(
            //   stream:
            //   FirebaseFirestore.instance.collection('users').snapshots(),
            //   builder: (BuildContext context,
            //       AsyncSnapshot<QuerySnapshot> snapshot) {
            //     if (snapshot.hasError) {
            //       return Text('Failed to fetch users');
            //     }
            //
            //     if (snapshot.connectionState == ConnectionState.waiting) {
            //       return CircularProgressIndicator();
            //     }
            //
            //     List<Widget> userList = List<Widget>.from(
            //       snapshot.data!.docs.map((DocumentSnapshot doc) {
            //         String userId = doc.id;
            //         String name =
            //             (doc.data() as Map<String, dynamic>)['name'] as String? ??
            //                 '';
            //         return ListTile(
            //             title: Text(name),
            //             subtitle: Text('ID: $userId'),
            //             trailing: Row(
            //               mainAxisSize: MainAxisSize.min,
            //               children: [
            //                 IconButton(
            //                   icon: Icon(Icons.edit),
            //                   onPressed: () {
            //                     showDialog(
            //                       context: context,
            //                       builder: (BuildContext context) {
            //                         return AlertDialog(
            //                           title: Text('Edit User'),
            //                           content: Column(
            //                             mainAxisSize: MainAxisSize.min,
            //                             children: [
            //                               Text('New Name:'),
            //                               TextFormField(
            //                                 controller:
            //                                 TextEditingController(text: name),
            //                                 onChanged: (value) {
            //                                   name = value;
            //                                 },
            //                               ),
            //                             ],
            //                           ),
            //                         );
            //                       },
            //                     ).then((value) {
            //                       if (name != null && name.isNotEmpty) {
            //                        // updateUser(userId, name);
            //                       }
            //                     });
            //                   },
            //                 ),
            //                 IconButton(
            //                   icon: Icon(Icons.delete),
            //                   onPressed: () {
            //                     showDialog(
            //                       context: context,
            //                       builder: (BuildContext context) {
            //                         return AlertDialog(
            //                           title: Text('Confirm Deletion'),
            //                           content: Text(
            //                               'Are you sure you want to delete this user?'),
            //                           actions: [
            //                             TextButton(
            //                               child: Text('Cancel'),
            //                               onPressed: () {
            //                                 Navigator.of(context).pop();
            //                               },
            //                             ),
            //                             TextButton(
            //                               child: Text('Delete'),
            //                               onPressed: () {
            //                                // deleteUser(userId);
            //                                 Navigator.of(context).pop();
            //                               },
            //                             ),
            //                           ],
            //                         );
            //                       },
            //                     );
            //                   },
            //                 ),
            //               ],
            //             ));
            //       }),);
            //     return Column(
            //       children: userList,
            //     );
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
