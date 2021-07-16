import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pareezblling/components/utils.dart';
import 'package:pareezblling/screens/addOrder.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

class CustomerProfile extends StatefulWidget {
  CustomerProfile({@required this.doc});
  final DocumentSnapshot doc;
  @override
  _CustomerProfileState createState() => _CustomerProfileState();
}

class _CustomerProfileState extends State<CustomerProfile> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: utils.kBlack,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: height * 0.04),
              HeadingRow(doc: widget.doc),
              SizedBox(height: height * 0.04),
              OrdersRow(doc: widget.doc),
              SizedBox(height: height * 0.02),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: widget.doc.reference
                      .collection("orders")
                      .orderBy("timestamp")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting)
                      return utils.kCircularProgressIndicator;
                    else if (snapshot.hasError)
                      return utils.kErrorWidget;
                    else if (snapshot.hasData) {
                      final List<DocumentSnapshot> docs =
                          snapshot.data.documents;
                      if (docs.isEmpty)
                        return Center(
                            child: Text(
                          "No order history found",
                          style: utils.kTextStyle,
                        ));
                      else
                        return ListView.separated(
                          itemBuilder: (context, index) {
                            if (docs[index]["timestamp"] != null) {
                              final DateTime date = DateTime.parse(
                                  docs[index]["timestamp"].toDate().toString());
                              return ListTile(
                                leading: Text("${index + 1}",
                                    style: utils.kTextStyle),
                                title: Text(
                                  docs[index]["description"],
                                  maxLines: 2,
                                  style: utils.kTextStyle,
                                ),
                                trailing: Text(
                                  "Rs. ${docs[index]["price"]}",
                                  maxLines: 1,
                                  style: utils.kTextStyle,
                                ),
                                subtitle: Text(
                                  "${date.day}th ${getMonth(date.month)} ${date.year}",
                                  style: utils.kTextStyle.copyWith(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                              );
                            }
                            return Container();
                          },
                          separatorBuilder: (context, index) =>
                              Divider(color: Colors.grey),
                          itemCount: docs.length,
                        );
                    } else
                      return Container();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String getMonth(int month) {
    String res = "";
    switch (month) {
      case 1:
        res = "Jan";
        break;
      case 2:
        res = "Feb";
        break;
      case 3:
        res = "March";
        break;
      case 4:
        res = "April";
        break;
      case 5:
        res = "May";
        break;
      case 6:
        res = "June";
        break;
      case 7:
        res = "July";
        break;
      case 8:
        res = "Aug";
        break;
      case 9:
        res = "Sept";
        break;
      case 10:
        res = "Oct";
        break;
      case 11:
        res = "Nov";
        break;
      case 12:
        res = "Dec";
        break;
    }
    return res;
  }
}

class OrdersRow extends StatelessWidget {
  OrdersRow({@required this.doc});
  final DocumentSnapshot doc;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Order History",
          style: utils.kTextStyle.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        IconButton(
          icon: Icon(Icons.add_circle_outline_rounded),
          color: utils.kPink,
          iconSize: 22,
          padding: EdgeInsets.zero,
          constraints: BoxConstraints(),
          onPressed: () => Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => AddOrder(doc: doc),
            ),
          ),
        ),
      ],
    );
  }
}

class HeadingRow extends StatelessWidget {
  HeadingRow({@required this.doc});
  final DocumentSnapshot doc;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(Icons.arrow_back),
          color: utils.kPink,
          iconSize: 22,
          padding: EdgeInsets.zero,
          constraints: BoxConstraints(),
          onPressed: () => Navigator.pop(context),
        ),
        Row(
          children: [
            Text(
              doc["name"],
              style: utils.kTextStyle.copyWith(
                fontSize: 18,
              ),
            ),
            SizedBox(width: 20),
            IconButton(
              icon: Icon(Icons.phone),
              color: utils.kPink,
              iconSize: 22,
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(),
              onPressed: () => UrlLauncher.launch("tel://${doc["phone"]}"),
            ),
          ],
        ),
      ],
    );
  }
}
