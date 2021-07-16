import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pareezblling/components/utils.dart';
import 'package:pareezblling/screens/addCustomer.dart';
import 'package:pareezblling/screens/customerProfile.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
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
              HeadingRow(),
              SizedBox(height: height * 0.04),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream:
                      Firestore.instance.collection("customers").snapshots(),
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
                          "No customers found!",
                          style: utils.kTextStyle,
                        ));
                      return ListView.separated(
                        itemBuilder: (context, index) => ListTile(
                          enabled: true,
                          onTap: () => Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) =>
                                  CustomerProfile(doc: docs[index]),
                            ),
                          ),
                          leading: Text(
                            "${index + 1}",
                            style: utils.kTextStyle,
                          ),
                          title: Text(
                            docs[index]["name"],
                            maxLines: 2,
                            style: utils.kTextStyle,
                          ),
                          trailing: Text(
                            docs[index]["phone"],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: utils.kTextStyle,
                          ),
                        ),
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
}

class HeadingRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Customers",
          style: utils.kTextStyle.copyWith(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        IconButton(
          icon: Icon(Icons.add_circle_outline_rounded),
          color: utils.kPink,
          padding: EdgeInsets.zero,
          constraints: BoxConstraints(),
          onPressed: () => Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => AddCustomer(),
            ),
          ),
        ),
      ],
    );
  }
}
