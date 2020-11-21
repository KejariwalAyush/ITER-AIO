import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:iteraio/Utilities/Theme.dart';
import 'package:iteraio/Utilities/global_var.dart';

// ignore: must_be_immutable
class ClubDetailsForm extends StatefulWidget {
  QueryDocumentSnapshot doc;
  ClubDetailsForm({this.doc, Key key}) : super(key: key);

  @override
  _ClubDetailsFormState createState() => _ClubDetailsFormState();
}

class _ClubDetailsFormState extends State<ClubDetailsForm> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Club Profile'),
        centerTitle: true,
        elevation: 15,
        automaticallyImplyLeading: true,
      ),
      body: Container(
        padding: EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: Column(
            children: [
              buildFormFeilds(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        margin: const EdgeInsets.all(4),
                        child: RaisedButton.icon(
                          icon: Icon(Icons.save),
                          label: Text('Save'),
                          onPressed: () {
                            if (_fbKey.currentState.saveAndValidate()) {
                              var x = _fbKey.currentState.value;
                              print(x);
                              try {
                                clubs.doc(widget.doc.id).update(x).then(
                                    (value) => print('Club Data Updated'));
                              } on Exception catch (e) {
                                print(e.toString());
                              }
                              Navigator.pop(context);
                            }
                          },
                          color: colorDark.withOpacity(1),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        margin: const EdgeInsets.all(4),
                        child: RaisedButton.icon(
                          icon: Icon(Icons.cancel),
                          label: Text('Cancel'),
                          onPressed: () {
                            _fbKey.currentState.reset();
                          },
                          color: colorDark.withOpacity(0.1),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildFormFeilds() {
    Future<List<QueryDocumentSnapshot>> docList =
        users.get().then((value) => value.docs);

    return FormBuilder(
      key: _fbKey,
      initialValue: {
        'name': widget.doc['name'],
        'desc': widget.doc['desc'],
        'coordinators': widget.doc['coordinators'],
        'howToJoin': widget.doc['howToJoin'],
        'benifits': widget.doc['benifits'],
        'activity': widget.doc['activity'],
        'instaLink': widget.doc['instaLink'],
        'otherLinks': widget.doc['otherLinks'],
        'logoUrl': widget.doc['logoUrl'],
      },
      child: SingleChildScrollView(
        child: Column(
          children: [
            FormBuilderTextField(
              attribute: 'name',
              decoration: InputDecoration(labelText: "Input Name"),
              validators: [
                FormBuilderValidators.required(),
              ],
            ),
            FormBuilderTextField(
              attribute: 'desc',
              decoration: InputDecoration(labelText: "Input Description"),
              validators: [
                FormBuilderValidators.required(),
              ],
            ),
            FormBuilderChipsInput(
              allowChipEditing: false,
              validators: [
                FormBuilderValidators.required(),
              ],
              initialValue: widget.doc['coordinators'],
              maxChips: 7,
              attribute: 'coordinators',
              chipBuilder: (context, state, title) {
                return InputChip(
                  key: ObjectKey(title),
                  label: Text(title),
                  onDeleted: () {
                    if (title != regdNo) state.deleteChip(title);
                  },
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                );
              },
              // validators: [FormBuilderValidators.pattern('')],
              decoration: InputDecoration(labelText: "Coordinators"),
              suggestionBuilder: (context, state, doc) {
                return ListTile(
                  key: ObjectKey(doc.id),
                  title: Text(doc.id),
                  onTap: () => state.selectSuggestion(doc.id),
                );
              },
              findSuggestions: (String query) {
                return docList.then((value) => value
                    .where((element) => element.id.contains(query))
                    .toList());
              },
            ),
            FormBuilderTextField(
              attribute: 'howToJoin',
              decoration: InputDecoration(labelText: "How to Join Clubs"),
              maxLines: 2,
              validators: [
                FormBuilderValidators.required(),
              ],
            ),
            FormBuilderTextField(
              attribute: 'benifits',
              maxLines: 2,
              decoration: InputDecoration(labelText: "Benifits of Club"),
            ),
            FormBuilderTextField(
              attribute: 'activity',
              decoration: InputDecoration(labelText: "Club Activities"),
              maxLines: 2,
            ),
            FormBuilderTextField(
              attribute: 'instaLink',
              decoration: InputDecoration(labelText: "Instagram Link"),
              validators: [
                FormBuilderValidators.url(),
              ],
            ),
            FormBuilderTextField(
              attribute: 'otherLinks',
              decoration: InputDecoration(labelText: "Other Links"),
            ),
            FormBuilderTextField(
              attribute: 'logoUrl',
              decoration: InputDecoration(labelText: "Logo Image Url"),
              validators: [
                FormBuilderValidators.url(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
