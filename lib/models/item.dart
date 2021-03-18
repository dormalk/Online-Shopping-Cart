import 'package:flutter/material.dart';

class Item {
  String name;
  bool isCheked;
  String comment;
  String img;

  Item({@required this.name, this.isCheked = false, this.comment, this.img});

  Map<String, Object> toJSON() {
    return {
      'name': this.name,
      'isCheked': this.isCheked,
      'comment': this.comment,
      'img': this.img,
    };
  }

  Item fromJSON(Map<String, dynamic> json) {
    this.name = json['name'];
    this.isCheked = json['isCheked'];
    this.comment = json['comment'];
    this.img = json['img'];
    return this;
  }
}
