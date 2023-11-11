import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:note_taking_app/addnote.dart';

class homepage extends StatefulWidget {
  const homepage({super.key});

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {

  final TextEditingController _nameController = TextEditingController();


  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void deleteUser(String title) {
    FirebaseFirestore.instance
        .collection('Notes')
        .doc(title)
        .delete()
        .then((value) => print('note deleted successfully'))
        .catchError((error) => print('Failed to delete : $error'));
  }

  void updateUser( String newtiltle,String newcontent,String newdate,) {
    FirebaseFirestore.instance
        .collection('Notes')
        .doc(newtiltle)
        .update({
      'note_title': newtiltle,
      'note_content': newcontent,
      'note_time': newdate,

        })
        .then((value) => print('note updated successfully'))
        .catchError((error) => print('Failed to update : $error'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
appBar: AppBar(
  title: Text("Note Pad"),
),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Text("Recent Notes",style: TextStyle(fontSize: 22,fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 20),

            StreamBuilder<QuerySnapshot>(
              stream:
              FirebaseFirestore.instance.collection('Notes').snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Failed to fetch users');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                List<Widget> noteList = List<Widget>.from(
                  snapshot.data!.docs.map((DocumentSnapshot doc) {

                    String title =
                        (doc.data() as Map<String, dynamic>)['note_title'] as String? ?? '';
                    String content =
                        (doc.data() as Map<String, dynamic>)['note_content'] as String? ?? '';
                    String time =
                        (doc.data() as Map<String, dynamic>)['note_time'] as String? ?? '';
                    return ListTile(
                        title: Text('$title'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('$content'),
                            Text('$time'),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Edit note'),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text('New Title:'),
                                          TextFormField(
                                            controller:
                                            TextEditingController(text: title),
                                            onChanged: (value) {
                                              title = value;
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ).then((value) {
                                  if (title != null && title.isNotEmpty) {
                                    updateUser(title,content,time);
                                  }
                                });
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Confirm Deletion'),
                                      content: Text(
                                          'Are you sure you want to delete this note?'),
                                      actions: [
                                        TextButton(
                                          child: Text('Cancel'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        TextButton(
                                          child: Text('Delete'),
                                          onPressed: () {
                                           // deleteUser(userId);
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ));
                  }),);
                return Column(
                  children: noteList,
                );
              },
            ),
            Column(children: <Widget>[
              Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => newnote()),);
                    },
                    child: Text("New Note"),))
            ]),
          ],
        ),
      ),
    );
  }
}
