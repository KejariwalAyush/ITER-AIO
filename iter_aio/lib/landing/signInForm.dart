import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:iteraio/Utilities/Theme.dart';
import 'package:iteraio/Utilities/global_var.dart';
import 'package:iteraio/landing/landingPage.dart';

class SignInForm extends StatefulWidget {
  final User user;
  SignInForm({Key key, this.user}) : super(key: key);

  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign in Form'),
        centerTitle: true,
        elevation: 15,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () async {
            await googleSignIn.signOut();
            setState(() {
              user = null;
            });
            Navigator.pop(context);
          },
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                // bottomLeft: Radius.circular(35),
                // bottomRight: Radius.circular(25)
                )),
      ),
      body: WillPopScope(
        onWillPop: () async {
          await googleSignIn.signOut();
          setState(() {
            user = null;
          });
          Navigator.pop(context);
          return;
        },
        child: Container(
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
                            icon: Icon(Icons.publish),
                            label: Text('Publish'),
                            onPressed: () {
                              if (_fbKey.currentState.saveAndValidate()) {
                                var x = _fbKey.currentState.value;
                                print(x);
                                googleUsers.doc(x['regdno']).set(x);
                                gUser = x;
                                Navigator.pop(context);
                              }
                            },
                            color: colorDark.withOpacity(1),
                          ),
                        ),
                      ),
                      // Expanded(
                      //   flex: 1,
                      //   child: Container(
                      //     margin: const EdgeInsets.all(4),
                      //     child: RaisedButton.icon(
                      //       icon: Icon(Icons.cancel),
                      //       label: Text('Reset'),
                      //       onPressed: () {
                      //         _fbKey.currentState.reset();
                      //       },
                      //       color: colorDark.withOpacity(0.1),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildFormFeilds() {
    return FormBuilder(
      key: _fbKey,
      initialValue: {
        'name': widget.user.displayName,
        'wphone': widget.user.phoneNumber,
        'email': widget.user.email,
        'imgUrl': widget.user.photoURL
      },
      child: SingleChildScrollView(
        child: Column(
          children: [
            FormBuilderTextField(
              attribute: 'email',
              enabled: false,
              readOnly: true,
              validators: [FormBuilderValidators.required()],
              decoration: InputDecoration(labelText: "Email"),
              autocorrect: true,
            ),
            FormBuilderTextField(
              attribute: 'imageUrl',
              // validators: [FormBuilderValidators.required()],
              decoration: InputDecoration(labelText: "Profile Image Url"),
              autocorrect: true,
            ),
            FormBuilderTextField(
              attribute: 'name',
              validators: [FormBuilderValidators.required()],
              decoration: InputDecoration(labelText: "Name"),
              autocorrect: true,
            ),
            FormBuilderTextField(
              attribute: 'regdno',
              decoration: InputDecoration(labelText: "Registration No."),
              validators: [
                FormBuilderValidators.required(),
                FormBuilderValidators.numeric()
              ],
            ),
            FormBuilderTextField(
              attribute: 'wphone',
              decoration: InputDecoration(labelText: "Whatsapp No."),
              validators: [
                FormBuilderValidators.required(),
                FormBuilderValidators.numeric()
              ],
            ),
            FormBuilderDropdown(
              attribute: "branch",
              decoration: InputDecoration(labelText: "Branch"),
              // initialValue: 'CODEX',
              hint: Text('Select Branch'),
              validators: [FormBuilderValidators.required()],
              items: branchList
                  .map((branch) =>
                      DropdownMenuItem(value: branch, child: Text("$branch")))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  List<String> branchList = [
    'Civil Engineering',
    'Computer Science & Engineering',
    'Computer Science & Information Technology',
    'Electrical Engineering',
    'Electrical & Electronics Engineering',
    'Electronics & Communication Engineering',
    'Mechanical Engineering'
  ];
}
