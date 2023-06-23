import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_tv/model/category.dart';
import 'package:flutter_app_tv/ui/home/home.dart';
import 'package:flutter_app_tv/ui/channel/category_widget.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class CategoriesDialog extends StatelessWidget {
  List<Category> categoriesList = [];
  bool visibile;
  int focused_category;
  int selected_category;
  ItemScrollController categoriesScrollController = ItemScrollController();

  Function close;
  Function select;
  CategoriesDialog({required this.categoriesList, required this.visibile, required this.focused_category, required this.selected_category, required this.categoriesScrollController, required this. close,required this.select});

  @override
  Widget build(BuildContext context) {
    return   AnimatedPositioned(
      left: 0,
      right: 0,
      bottom: 0,
      top: 0,
      duration: Duration(milliseconds: 250),
      child: Visibility(
        visible: visibile,
        child: Container(
          color: Colors.black87,
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: GestureDetector(
                  onTap: (){
                    close();
                  },
                  child: Container(
                    color: Colors.transparent,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      boxShadow: [
                        BoxShadow(
                            color:Colors.black,
                            offset: Offset(0,0),
                            blurRadius: 5
                        ),
                      ],
                    ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black45,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 80.0,left: 10,bottom: 10),
                          child: Row(
                            children: [
                              Icon(Icons.category_rounded,color: Colors.white70,size: 35),
                              SizedBox(width: 10),
                              Text(
                                "Select Category",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white70
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(child:
                      Container(
                        color: Colors.black.withOpacity(0.7),
                        child:  ScrollConfiguration(
                          behavior: MyBehavior(),   // From this behaviour you can change the behaviour
                          child: ScrollablePositionedList.builder(
                            itemCount: categoriesList.length,
                            itemScrollController: categoriesScrollController,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) {
                              return  GestureDetector(
                                  onTap: (){
                                    select(index);
                                  },
                                  child: CategoryWidget(isFocused: (focused_category == index),selected_category:selected_category,index : index,category: categoriesList[index])
                              );
                            },
                          ),
                        ),
                      ))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
