import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:iteraio/Utilities/Theme.dart';
import 'package:iteraio/Utilities/global_var.dart';

class EventsForm extends StatefulWidget {
  @override
  _EventsFormState createState() => _EventsFormState();
}

class _EventsFormState extends State<EventsForm> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Events Editor'),
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
                          icon: Icon(Icons.publish),
                          label: Text('Publish'),
                          onPressed: () {
                            if (_fbKey.currentState.saveAndValidate()) {
                              var x = _fbKey.currentState.value;
                              print(x);
                              try {
                                events.add(x);
                                print('Event Added');
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
      initialValue: {
        'eventDate': DateTime.now(),
        'time': DateTime.now(),
      },
      child: SingleChildScrollView(
        child: Column(
          children: [
            FormBuilderTextField(
              attribute: 'title',
              validators: [FormBuilderValidators.required()],
              decoration: InputDecoration(labelText: "Title"),
              autocorrect: true,
            ),
            FormBuilderTextField(
              attribute: 'shortDesc',
              maxLines: 2,
              decoration: InputDecoration(labelText: "Short Description"),
              autocorrect: true,
            ),
            FormBuilderDropdown(
              attribute: "clubName",
              decoration: InputDecoration(labelText: "Club"),
              // initialValue: 'CODEX',
              hint: Text('Select Club'),
              validators: [FormBuilderValidators.required()],
              items: clubsName
                  .map((club) =>
                      DropdownMenuItem(value: club, child: Text("$club")))
                  .toList(),
            ),
            FormBuilderTouchSpin(
              decoration: InputDecoration(labelText: "No. of Days of Event"),
              attribute: "eventDays",
              validators: [FormBuilderValidators.required()],
              initialValue: 1,
              step: 1,
              max: 10,
              min: 1,
              iconActiveColor: Colors.orangeAccent,
            ),
            FormBuilderTextField(
              attribute: 'desc',
              validators: [FormBuilderValidators.required()],
              maxLines: 4,
              decoration: InputDecoration(labelText: "Detailed Description"),
              autocorrect: true,
            ),
            FormBuilderTextField(
              attribute: 'imgUrl',
              decoration: InputDecoration(labelText: "Image Url (Optional)"),
              validators: [
                FormBuilderValidators.url(),
              ],
              autocorrect: true,
            ),
            FormBuilderTextField(
              attribute: 'link',
              decoration:
                  InputDecoration(labelText: "Link to Form/Website (Optional)"),
              validators: [
                FormBuilderValidators.url(),
              ],
              autocorrect: true,
            ),
            FormBuilderDateTimePicker(
              attribute: "eventDate",
              validators: [FormBuilderValidators.required()],
              inputType: InputType.both,
              format: DateFormat("EEE, dd MMMM, hh:mm a"),
              decoration: InputDecoration(labelText: "Event Date"),
            ),
            FormBuilderChipsInput(
              allowChipEditing: true,
              initialValue: ['iteraio'], maxChips: 10,
              textCapitalization: TextCapitalization.words,
              attribute: 'hashtags',
              chipBuilder: (context, state, title) {
                return InputChip(
                  key: ObjectKey(title),
                  label: Text(title),
                  onDeleted: () => state.deleteChip(title),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                );
              },
              // validators: [FormBuilderValidators.pattern('')],
              decoration: InputDecoration(labelText: "HashTags"),
              suggestionBuilder: (context, state, title) {
                return ListTile(
                  key: ObjectKey(title),
                  title: Text(title),
                  onTap: () => state.selectSuggestion(title),
                );
              },
              findSuggestions: (String query) {
                return <String>[query];
              },
            ),

            /// non editable feilds
            Row(
              children: [
                Expanded(
                  child: FormBuilderTextField(
                    attribute: 'adminName',
                    readOnly: true,
                    validators: [FormBuilderValidators.required()],
                    decoration:
                        InputDecoration(labelText: "Admin Name (Non Editable)"),
                    initialValue: name,
                  ),
                ),
                Expanded(
                  child: FormBuilderTextField(
                    attribute: 'adminRegdNo',
                    readOnly: true,
                    validators: [FormBuilderValidators.required()],
                    decoration: InputDecoration(
                        labelText: "Admin Regd. No. (Non Editable)"),
                    initialValue: regdNo,
                  ),
                ),
              ],
            ),
            FormBuilderDateTimePicker(
              attribute: "time",
              readOnly: true,
              validators: [FormBuilderValidators.required()],
              format: DateFormat("EEE, dd MMMM"),
              decoration:
                  InputDecoration(labelText: "Publish Date (Non Editable)"),
            ),

            /// adding list of student refs
            Row(
              children: [
                Expanded(
                  child: FormBuilderChipsInput(
                    allowChipEditing: true, readOnly: true,
                    initialValue: [],
                    maxChips: 1,
                    // textCapitalization: TextCapitalization.words,
                    attribute: 'intrested',
                    chipBuilder: (context, state, title) {
                      return InputChip(
                        key: ObjectKey(title),
                        label: Text(title),
                        onDeleted: () => state.deleteChip(title),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      );
                    },
                    // validators: [FormBuilderValidators.pattern('')],
                    decoration: InputDecoration(labelText: "Intrested People"),
                    suggestionBuilder: (context, state, title) {
                      return ListTile(
                        key: ObjectKey(title),
                        title: Text(title),
                        onTap: () => state.selectSuggestion(title),
                      );
                    },
                    findSuggestions: (String query) {
                      return <String>[query];
                    },
                  ),
                ),
                Expanded(
                  child: FormBuilderChipsInput(
                    allowChipEditing: true, readOnly: true,
                    initialValue: [regdNo], maxChips: 1,
                    // textCapitalization: TextCapitalization.words,
                    attribute: 'views',
                    chipBuilder: (context, state, title) {
                      return InputChip(
                        key: ObjectKey(title),
                        label: Text(title),
                        onDeleted: () => state.deleteChip(title),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      );
                    },
                    // validators: [FormBuilderValidators.pattern('')],
                    decoration:
                        InputDecoration(labelText: "Views will be added"),
                    suggestionBuilder: (context, state, title) {
                      return ListTile(
                        key: ObjectKey(title),
                        title: Text(title),
                        onTap: () => state.selectSuggestion(title),
                      );
                    },
                    findSuggestions: (String query) {
                      return <String>[query];
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
