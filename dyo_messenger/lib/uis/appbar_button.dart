import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AppbarButton extends StatefulWidget {
  IconData icon;
  Function onPressed;
  AppbarButton({Key key, @required this.icon, @required this.onPressed})
      : super(key: key);
  @override
  _AppbarButtonState createState() => _AppbarButtonState();
}

class _AppbarButtonState extends State<AppbarButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ButtonTheme(
        minWidth: 5,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: CircleBorder(),
        padding: EdgeInsets.all(4),
        child: FlatButton(
          color: Colors.grey[200],
          onPressed: widget.onPressed,
          child: Icon(widget.icon),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class MyPopupMenuButton extends StatefulWidget {
  List<PopupMenuEntry> menuItems;
  MyPopupMenuButton({Key key, this.menuItems}) : super(key: key);

  @override
  _MyPopupMenuButtonState createState() => _MyPopupMenuButtonState();
}

class _MyPopupMenuButtonState extends State<MyPopupMenuButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
        ),
        child: PopupMenuButton(
          elevation: 3,
          color: Colors.white,
          enabled: true,
          icon: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[200],
            ),
            padding: EdgeInsets.all(4),
            child: Icon(
              Icons.more_horiz,
              color: Colors.black,
              size: 24,
            ),
          ),
          itemBuilder: (context) => widget.menuItems,
        ),
      ),
    );
  }
}
