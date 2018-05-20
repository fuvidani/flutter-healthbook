import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:healthbook/util/keys.dart';
import 'package:healthbook/util/typedefs.dart';
import 'package:image_picker/image_picker.dart';

class AddMedicalInfoPage extends StatefulWidget {
  final MedicalInfoAdder infoAdder;

  AddMedicalInfoPage({
    Key key,
    @required this.infoAdder,
  }) : super(key: key ?? HealthBookKeys.addMedicalInfoScreen);

  @override
  _AddMedicalInfoPageState createState() =>
      _AddMedicalInfoPageState(infoAdder: this.infoAdder);
}

class _AddMedicalInfoPageState extends State<AddMedicalInfoPage> {
  static final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  static final GlobalKey<FormFieldState<String>> titleKey =
      GlobalKey<FormFieldState<String>>();
  static final GlobalKey<FormFieldState<String>> descriptionKey =
      GlobalKey<FormFieldState<String>>();
  static final GlobalKey<FormFieldState<String>> tagsKey =
      GlobalKey<FormFieldState<String>>();

  final MedicalInfoAdder infoAdder;
  Future<File> _imageFile;
  String _title;
  String _description;
  String _tags;

  _AddMedicalInfoPageState({@required this.infoAdder});

  void _onImageButtonPressed(ImageSource source) {
    setState(() {
      _imageFile = ImagePicker.pickImage(source: source);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add New Medical Info"),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
        child: Form(
          key: formKey,
          autovalidate: false,
          onWillPop: () {
            return Future(() => true);
          },
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
            child: new Column(
              children: <Widget>[
                TextFormField(
                  initialValue: '',
                  key: titleKey,
                  autofocus: true,
                  style: Theme.of(context).textTheme.title,
                  decoration: InputDecoration(hintText: 'Title of the record'),
                  validator: (val) =>
                      val.trim().isEmpty ? 'Title cannot be empty' : null,
                  onSaved: (val) => _title = val,
                ),
                TextFormField(
                  initialValue: '',
                  key: descriptionKey,
                  maxLines: 5,
                  style: Theme.of(context).textTheme.subhead,
                  decoration: InputDecoration(
                    hintText: 'Describe your health data...',
                  ),
                  onSaved: (val) => _description = val,
                ),
                TextFormField(
                  initialValue: '',
                  key: tagsKey,
                  maxLines: 2,
                  style: Theme.of(context).textTheme.subhead,
                  decoration: InputDecoration(
                    hintText: 'Add tags separated by commas',
                  ),
                  validator: (val) => val.trim().isEmpty
                      ? 'At least one tag is required'
                      : null,
                  onSaved: (val) => _tags = val,
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          tooltip: 'Save medical information',
          child: Icon(Icons.check),
          backgroundColor: Colors.pinkAccent,
          onPressed: () {
            FocusScope.of(context).requestFocus(new FocusNode());
            final form = formKey.currentState;
            if (form.validate()) {
              final title = titleKey.currentState.value;
              final description = descriptionKey.currentState.value;
              final tagsString = tagsKey.currentState.value;

              Navigator.pop(context);
            }
          }),
    );
  }

/**
 * child: ListView(
    children: [
    TextFormField(
    initialValue: _title != null ? _title : '',
    key: titleKey,
    autofocus: true,
    style: Theme.of(context).textTheme.headline,
    decoration: InputDecoration(
    hintText: 'Title of the record'),
    validator: (val) => val.trim().isEmpty
    ? 'Title cannot be empty'
    : null,
    onSaved: (val) => _title = val,
    ),
    TextFormField(
    initialValue: '',
    key: descriptionKey,
    maxLines: 10,
    style: Theme.of(context).textTheme.subhead,
    decoration: InputDecoration(
    hintText: 'Describe your health data...',
    ),
    onSaved: (val) => _description = val,
    )
    ],
    ),
 */
}
