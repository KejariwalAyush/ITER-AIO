import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:iteraio/Utilities/Theme.dart';
import 'package:iteraio/Utilities/global_var.dart';

class ProfileForm extends StatefulWidget {
  final profileImg;

  const ProfileForm({Key key, this.profileImg}) : super(key: key);

  @override
  _EventsFormState createState() => _EventsFormState();
}

class _EventsFormState extends State<ProfileForm> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Editor'),
        centerTitle: true,
        elevation: 15,
        automaticallyImplyLeading: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                // bottomLeft: Radius.circular(35),
                // bottomRight: Radius.circular(25)
                )),
      ),
      body: Container(
        padding: EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                setState(() {
                                  emailId = x['emailId'];
                                });
                                users.doc(regdNo).update(x);
                                print('Profile info Added');
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
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildFormFeilds() {
    return FormBuilder(
      key: _fbKey,
      initialValue: {'emailId': emailId, 'imgUrl': widget.profileImg},
      child: SingleChildScrollView(
        child: Column(
          children: [
            FormBuilderTextField(
              attribute: 'emailId',
              decoration: InputDecoration(labelText: "Input Email"),
              validators: [
                FormBuilderValidators.email(),
                FormBuilderValidators.required(),
              ],
            ),
            FormBuilderTextField(
              attribute: 'imgUrl',
              decoration: InputDecoration(labelText: "Profile Image Url"),
              validators: [
                FormBuilderValidators.url(),
              ],
              autocorrect: true,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                  'Note: Changes here will not make any change to college site info'),
            )
          ],
        ),
      ),
    );
  }
}
