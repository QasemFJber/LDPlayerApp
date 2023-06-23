import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_tv/model/subscription.dart';

class SubscriptionItemWidget extends StatefulWidget {
  bool isFocused = false;
  Subscription subscription;



  SubscriptionItemWidget({required this. subscription, required this.isFocused});

  @override
  _SubscriptionItemWidgetState createState() => _SubscriptionItemWidgetState();
}

class _SubscriptionItemWidgetState extends State<SubscriptionItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.all(0.0),
            child:   Container(
              padding: EdgeInsets.all(5),
              child: Center(
                child: Text(
                 widget.subscription.price,
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w900
                  ),
                ),
              ),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5)
              ),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.subscription.pack,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 11,
                  ),
                ),
                SizedBox(height:3),
                Text(
                  widget.subscription.date,
                  style: TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.normal,
                      fontSize: 9
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Text(
              widget.subscription.expired,
              style: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.normal,
                  fontSize: 9
              ),
            ),
          ),
          SizedBox(width: 10),
          Container(
            padding: EdgeInsets.all(5),
            child: Text(
                widget.subscription.state,
                style: TextStyle(
                  fontWeight: FontWeight.w900
                ),
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5)
            ),
          )
        ],
      ),
      decoration: BoxDecoration(
        color:  (widget.isFocused)?Colors.black.withOpacity(0.5):Colors.white.withOpacity(0),
      ),
    );
  }
}
