import 'dart:developer';

import 'package:batua/di/locator.dart';
import 'package:batua/exceptions/transaction_history_exception.dart';
import 'package:batua/models/transaction.dart';
import 'package:batua/services/transaction_history_service.dart';
import 'package:batua/ui_helper/homePageUiHelper.dart';
import 'package:batua/ui_helper/transaction_history_page_ui_helper.dart';
import 'package:batua/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TransactionHistoryPage extends StatelessWidget {
  static const route = "/transactionHistory";
  const TransactionHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    var isLoading = context.select<TransactionHistoryPageUiHelper, bool>(
      (value) => value.isLoading,
    );
    return Scaffold(
      body: SafeArea(
          child: Container(
        margin: EdgeInsets.all(8),
        child: Column(
          children: [
            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.only(
                bottom: 20,
                top: 12,
              ),
              child: Text(
                "Transaction History",
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Colors.grey.shade900,
                    fontSize: 32),
              ),
            ),
            Expanded(
                child: isLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : TransactionListWidget(
                        transactions: context.select<
                                TransactionHistoryPageUiHelper,
                                List<Transaction>?>(
                            (value) => value.allTransactions),
                      )),
          ],
        ),
      )),
    );
  }
}

class TransactionListWidget extends StatelessWidget {
  const TransactionListWidget({super.key, required this.transactions});
  final List<Transaction>? transactions;
  @override
  Widget build(BuildContext context) {
    log("transactionListWidget");
    var exception = context.select<TransactionHistoryPageUiHelper,
        TransactionHistoryException?>((value) => value.exception);
    if (exception != null &&
        exception.eType != TransactionHistoryEType.fininshed) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              "images/noTransactions.png",
              scale: 2.5,
            ),
            Container(
              margin: EdgeInsets.only(top: 16),
              child: Text(
                exception.message,
                style: TextStyle(
                    fontSize: 30,
                    color: Color.fromARGB(255, 117, 0, 137),
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      );
    }
    return Container(
      // margin: EdgeInsets.all(8),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: Colors.grey.shade200, borderRadius: BorderRadius.circular(12)),
      child: ListView.separated(
        controller:
            context.read<TransactionHistoryPageUiHelper>().scrollController,
        itemCount: transactions!.length + 1,
        itemBuilder: (context, index) {
          if (index < transactions!.length) {
            var transaction = transactions![index];
            return ListTile(
              leading: Icon(
                transaction.from == getIt<HomePageUiHelper>().address
                    ? FontAwesomeIcons.circleChevronUp
                    : FontAwesomeIcons.circleChevronDown,
              ),
              title: Container(
                margin: EdgeInsets.all(2),
                child: Text(transaction.tokenName == null
                    ? "Ethereum (ETH)"
                    : "${transaction.tokenName!} (${transaction.tokenSymbol!})"),
              ),
              subtitle: Text.rich(TextSpan(children: [
                TextSpan(
                    text: transaction.from == getIt<HomePageUiHelper>().address
                        ? "To:${transaction.to}"
                        : "From:${transaction.from}"),
                TextSpan(
                    style: TextStyle(color: Colors.greenAccent.shade700),
                    text:
                        "\n\n${DateFormat('MMM dd, yyyy').format(transaction.timeStamp)}")
              ])),
              trailing: Text(transaction.value.toStringAsFixed(8)),
            );
          } else {
            if (exception != null &&
                exception.eType == TransactionHistoryEType.fininshed) {
              return Container(
                margin: EdgeInsets.all(8.0),
                child: Center(child: Text(exception.message)),
              );
            }

            if (transactions != null && transactions!.length > 8) {
              return Container(
                margin: EdgeInsets.all(8.0),
                child: const Center(child: CircularProgressIndicator()),
              );
            }
            return Container();
          }
        },
        separatorBuilder: (context, index) => Divider(
          indent: 5,
        ),
      ),
    );
  }
}
