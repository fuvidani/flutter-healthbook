import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:healthbook/model/models.dart';
import 'package:healthbook/util/constants.dart';
import 'package:healthbook/util/keys.dart';
import 'package:healthbook/util/typedefs.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  final ScrollController _scrollController = new ScrollController();
  final MedicalInfoAdder infoAdder;
  Future<File> _imageFileFuture;
  File _imageFile;
  bool _isLoading = false;

  _AddMedicalInfoPageState({@required this.infoAdder});

  void _onImageButtonPressed(ImageSource source) {
    setState(() {
      _imageFileFuture = ImagePicker.pickImage(source: source);
    });
  }

  void _onSavePressed(BuildContext context) {
    FocusScope.of(context).requestFocus(new FocusNode());
    final form = formKey.currentState;
    if (form.validate()) {
      setState(() {
        _isLoading = true;
      });
      _scrollToBottom();
      _saveMedicalInfo(
          titleKey.currentState.value,
          descriptionKey.currentState.value,
          tagsKey.currentState.value).then((bool isSuccess) {
        if (isSuccess) {
          Navigator.pop(context);
        } else {
          setState(() {
            _isLoading = false;
          });
          final snackBar = new SnackBar(
            content: new Text('Could not persist new medical information'),
            duration: Duration(seconds: 3),
          );
          _scaffoldKey.currentState.showSnackBar(snackBar);
        }
      });
    }
  }

  Future<bool> _saveMedicalInfo(
      String title, String description, String tagString) async {
    List<String> tags = new List();
    tagString.split(",").forEach((tag) {
      tags.add(tag.trim());
    });
    String image = "";
    if (_imageFile != null) {
      List<int> bytes = await _imageFile.readAsBytes();
      image = await imageToBase64(bytes);
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString(USER_ID_KEY);
    return infoAdder(
        MedicalInformation(null, userId, title, description, image, tags));
  }

  Future<String> imageToBase64(List<int> bytes) async {
    return Base64Encoder().convert(bytes);
  }

  /// Veto "back" action if there is an ongoing operation
  Future<bool> _willPopCallback() async {
    if (_isLoading) {
      return false;
    }
    return true;
  }

  _scrollToBottom() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text("Add New Medical Info"),
          ),
          body: Padding(
            padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
            child: Form(
              key: formKey,
              autovalidate: false,
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 0.0),
                child: new Column(
                  children: <Widget>[
                    _imageChooserSection(),
                    _titleInput(),
                    _descriptionInput(),
                    _tagsInput(),
                    Container(
                      padding: EdgeInsets.all(16.0),
                      child: _isLoading
                          ? CircularProgressIndicator()
                          : Container(),
                    ),
                  ],
                ),
              ),
            ),
          ),
          floatingActionButton: _isLoading
              ? null
              : FloatingActionButton(
                  tooltip: 'Save medical information',
                  child: Icon(Icons.check),
                  backgroundColor: Colors.pinkAccent,
                  onPressed: () => _onSavePressed(context)),
        ),
        onWillPop: _willPopCallback);
  }

  Widget _imageChooserSection() {
    return Center(
      child: new FutureBuilder<File>(
        future: _imageFileFuture,
        builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data != null) {
            if (snapshot.data.statSync().size > 5000000) {
              _imageFileFuture = null;
              _showImageTooLargeSnackbar();
              return _imageChooserButton();
            } else {
              _imageFile = snapshot.data;
              return new Image.file(snapshot.data);
            }
          } else {
            return _imageChooserButton();
          }
        },
      ),
    );
  }

  _showImageTooLargeSnackbar() async {
    final snackBar = new SnackBar(
      content: new Text('Image larger than 5MB. Please choose a new one'),
      duration: Duration(seconds: 3),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  TextFormField _titleInput() {
    return TextFormField(
      initialValue: '',
      key: titleKey,
      autofocus: true,
      style: Theme.of(context).textTheme.title,
      decoration: InputDecoration(labelText: 'Title of the record *'),
      validator: (val) => val.trim().isEmpty ? 'Title cannot be empty' : null,
      enabled: !_isLoading,
    );
  }

  TextFormField _descriptionInput() {
    return TextFormField(
      initialValue: '',
      key: descriptionKey,
      maxLines: 5,
      style: Theme.of(context).textTheme.subhead,
      decoration: InputDecoration(
        labelText: 'Describe your health data...',
      ),
      validator: (val) => val.trim().isEmpty && _imageFile == null
          ? 'Either an image or a description is required'
          : null,
      enabled: !_isLoading,
    );
  }

  TextFormField _tagsInput() {
    return TextFormField(
      initialValue: '',
      key: tagsKey,
      maxLines: 2,
      style: Theme.of(context).textTheme.subhead,
      decoration: InputDecoration(
        labelText: 'Add tags separated by commas *',
      ),
      validator: (val) =>
          val.trim().isEmpty ? 'At least one tag is required' : null,
      enabled: !_isLoading,
    );
  }

  Widget _imageChooserButton() {
    return new RaisedButton(
      onPressed: () =>
          _isLoading ? null : _onImageButtonPressed(ImageSource.gallery),
      child: Text('Choose image', style: new TextStyle(color: Colors.white)),
      color: Colors.pinkAccent,
    );
  }
}
