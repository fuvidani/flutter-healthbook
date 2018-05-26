import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:healthbook/model/models.dart';
import 'package:healthbook/util/keys.dart';

class MedicalInfoDetailsPage extends StatelessWidget {
  final MedicalInformation medicalInformation;

  MedicalInfoDetailsPage({
    @required this.medicalInformation,
  }) : super(key: HealthBookKeys.medicalInfoDetailsScreen);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Entry Details"),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
        child: ListView(
          children: [
            _imageSection(),
            _titleSection(context),
            _descriptionSection(context),
            _tagSection(),
          ],
        ),
      ),
    );
  }

  Widget _imageSection() {
    if (medicalInformation.image == null || medicalInformation.image.isEmpty) {
      return Container();
    }
    return new Container(
      padding: EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 0.0),
      child: Image.memory(
        Base64Decoder().convert(_getImageBase64String()),
        fit: BoxFit.fitWidth,
      ),
    );
  }
  
  String _getImageBase64String() {
    if(medicalInformation.image.contains('data:image')) {
      return medicalInformation.image.split(',')[1];
    }
    return medicalInformation.image;
  }

  Widget _titleSection(BuildContext context) {
    return new Container(
      padding: const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 0.0),
      child: new Row(
        children: [
          new Expanded(
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionTitle('Title'),
                Hero(
                  tag: HealthBookKeys
                      .medicalInfoItemTitleHeroTag(medicalInformation.id),
                  child: new Text(
                    medicalInformation.title,
                    style: Theme.of(context).textTheme.title,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _descriptionSection(BuildContext context) {
    return new Container(
      padding: const EdgeInsets.fromLTRB(0.0, 24.0, 0.0, 0.0),
      child: new Row(
        children: [
          new Expanded(
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionTitle('Description'),
                medicalInformation.description.trim().isEmpty
                    ? new Text(
                        'No description provided.',
                        style: TextStyle(fontStyle: FontStyle.italic),
                        softWrap: true,
                      )
                    : new Text(
                        medicalInformation.description,
                        style: Theme.of(context).textTheme.body1,
                        softWrap: true,
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tagSection() {
    return new Container(
      padding: const EdgeInsets.fromLTRB(0.0, 24.0, 0.0, 16.0),
      child: new Row(
        children: [
          new Expanded(
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionTitle('Tags'),
                new Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  direction: Axis.horizontal,
                  children: _getChips(),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _getChips() {
    List<Widget> tiles = [];
    medicalInformation.tags.forEach((tag) {
      tiles.add(Chip(
        label: Text(tag),
      ));
    });
    return tiles;
  }

  Widget _sectionTitle(String title) {
    return new Container(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: new Text(
        title,
        style: new TextStyle(
          color: Colors.grey[500],
        ),
      ),
    );
  }
}
