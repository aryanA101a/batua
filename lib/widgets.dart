import 'package:batua/utils.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:oktoast/oktoast.dart';

txnToast(
    {required String from,
    required String to,
    required String address,
    required Network network,
    required double value}) {
  showToastWidget(
    Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Material(
        elevation: 10,
        color: Colors.transparent,
        child: ListTile(
          contentPadding: EdgeInsets.all(8),
          tileColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          leading: Icon(
            from == address
                ? FontAwesomeIcons.circleChevronUp
                : FontAwesomeIcons.circleChevronDown,
            color: Colors.green,
          ),
          title: Text(
            from == address ? "Sent" : "Recieved",
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
          ),
          subtitle: Text.rich(TextSpan(children: [
            TextSpan(text: from == address ? "To:$to" : "From:$from"),
          ])),
          trailing: Text(value.toStringAsFixed(8)),
        ),
      ),
    ),
    duration: Duration(seconds: 5),
    position: ToastPosition.bottom,
    animationCurve: Curves.easeInOut,
  );
}
