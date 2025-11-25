import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';

class FormModel {
  String? name;
  String? description;
  int? formId;
  bool? isClientRequired;
  int? entriesCount;
  List<FormFieldModel>? formFields;

  FormModel(
      {this.name,
      this.description,
      this.formId,
      this.isClientRequired,
      this.entriesCount,
      this.formFields});

  FormModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    description = json['description'];
    formId = json['formId'];
    isClientRequired = json['isClientRequired'];
    entriesCount = json['entriesCount'];
    if (json['formFields'] != null) {
      formFields = <FormFieldModel>[];
      json['formFields'].forEach((v) {
        formFields!.add(FormFieldModel.fromJson(v));
      });
    }
  }
}

class FormFieldModel {
  int? id;
  String? label;
  String? placeholder;
  String? type;
  List<dynamic>? values;
  bool? isRequired;
  @observable
  TextEditingController? controller = TextEditingController();
  bool switchValue = false;
  MultiSelectController<dynamic>? multiSelectController =
      MultiSelectController();

  FormFieldModel(
      {this.id,
      this.label,
      this.placeholder,
      this.type,
      this.values,
      this.isRequired,
      this.controller,
      this.switchValue = false,
      this.multiSelectController});

  FormFieldModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    label = json['label'];
    placeholder = json['placeholder'];
    type = json['type'];
    if (json['values'] != null) {
      values = <dynamic>[];

      json['values'].forEach((v) {
        values!.add(v);
      });
    }
    isRequired = json['isRequired'];
  }
}
