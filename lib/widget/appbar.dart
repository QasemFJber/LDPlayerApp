import 'package:flutter/material.dart';

class MyAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final Function onBackButtonPressed;

  const MyAppBar({
    Key? key,
    required this.title,
    this.showBackButton = false,
    required this.onBackButtonPressed,
  }) : super(key: key);

  @override
  _MyAppBarState createState() => _MyAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _MyAppBarState extends State<MyAppBar> {
  bool _searchVisible = false;
  TextEditingController _searchController = TextEditingController();

  void _toggleSearch() {
    setState(() {
      _searchVisible = !_searchVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: _searchVisible
          ? TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'ابحث هنا',
        ),
        onSubmitted: (value) {
          // اتخاذ إجراء عند النقر على زر "تم" في حقل البحث
          // يمكنك استخدام القيمة المدخلة في البحث هنا
        },
      )
          : Text(widget.title),
      leading: widget.showBackButton
          ? IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          if (widget.onBackButtonPressed != null) {
            widget.onBackButtonPressed();
          } else {
            Navigator.pop(context);
          }
        },
      )
          : null,
      actions: <Widget>[
        IconButton(
          icon: _searchVisible ? Icon(Icons.close) : Icon(Icons.search),
          onPressed: () {
            if (_searchVisible) {
              _toggleSearch();
            } else {
              _toggleSearch();
              FocusScope.of(context).requestFocus(FocusNode());
            }
          },
        ),
      ],
    );
  }
}
