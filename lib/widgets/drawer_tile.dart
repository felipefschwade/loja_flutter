import 'package:flutter/material.dart';

class DrawerTile extends StatelessWidget {

  final IconData icon;
  final String text;
  final PageController controller;
  final int page;

  DrawerTile(this.icon, this.text, this.controller, this.page);

  Color _getColor(BuildContext context) {
    if (controller.page.round() == page) return Theme.of(context).primaryColor;
    return Colors.grey[700];
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.of(context).pop();
          controller.jumpToPage(page);
        },
        child: Container(
          height: 60.0,
          child: Row(
            children: <Widget>[
              Icon(
                icon,
                size: 32.0,
                color: _getColor(context),
              ),
              SizedBox(width: 32.0),
              Text(text, style: TextStyle(color: _getColor(context))),
            ],
          ),
        ),
      ),
    );
  }
}