import 'package:batua/utils.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

CherryToast txnToast(
    {required from,
    required to,
    required address,
    required network,
    required value}) {
  return CherryToast(
    borderRadius: 12,
    animationType: AnimationType.fromBottom,
    toastPosition: Position.bottom,
    enableIconAnimation: false,
    iconColor: Colors.green,
    themeColor: Colors.green,
    icon: from == address
        ? FontAwesomeIcons.circleChevronUp
        : FontAwesomeIcons.circleChevronDown,
    title: Text(
      from == address ? "Sent" : "Recieved",
      style: TextStyle(
          fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
    ),
    description: Text.rich(
      TextSpan(
        children: [
          TextSpan(
              text: '$value ${symbols[network]}\n\n',
              style: TextStyle(
                  fontWeight: FontWeight.w500, color: Colors.grey.shade800)),
          TextSpan(
              text: from == address ? "To:$to" : "From:$from",
              style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    ),
  );
}
