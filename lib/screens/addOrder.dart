import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:pareezblling/components/utils.dart';

bool _isLoading = false;

class AddOrder extends StatefulWidget {
  const AddOrder({@required this.doc});
  final DocumentSnapshot doc;

  @override
  _AddOrderState createState() => _AddOrderState();
}

class _AddOrderState extends State<AddOrder> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  TextEditingController _descTextEditingController;
  TextEditingController _amtTextEditingController;
  Function refresh;

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    refresh = setState;
    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      progressIndicator: utils.kCircularProgressIndicator,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: utils.kBlack,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(child: SizedBox(height: height * 0.04)),
                HeaderRow(),
                Flexible(child: SizedBox(height: height * 0.1)),
                EnterData(
                    textEditingController: _descTextEditingController,
                    label: "Enter Order Description"),
                Flexible(child: SizedBox(height: height * 0.14)),
                EnterData(
                  textEditingController: _amtTextEditingController,
                  label: "Enter Price in Rs.",
                ),
                Flexible(child: SizedBox(height: height * 0.4)),
                AddOrderButton(
                  descTextEditingController: _descTextEditingController,
                  priceTextEditingController: _amtTextEditingController,
                  refresh: refresh,
                  scaffoldKey: _scaffoldKey,
                  doc: widget.doc,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    _descTextEditingController = TextEditingController();
    _amtTextEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _descTextEditingController?.dispose();
    _amtTextEditingController?.dispose();
    super.dispose();
  }
}

class HeaderRow extends StatelessWidget {
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
        Text(
          "Add an order",
          style: utils.kTextStyle.copyWith(
            fontSize: 20,
          ),
        ),
      ],
    );
  }
}

class EnterData extends StatelessWidget {
  const EnterData({@required this.textEditingController, @required this.label});
  final TextEditingController textEditingController;
  final String label;

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: utils.kTextStyle,
      keyboardType: label == "Enter Price in Rs."
          ? TextInputType.number
          : TextInputType.text,
      controller: textEditingController,
      maxLines: label == "Enter Price in Rs." ? 1 : null,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(left: 20),
        counterStyle: utils.kTextStyle,
        labelText: label,
        labelStyle: utils.kTextStyle,
        prefixStyle: utils.kTextStyle,
        prefixIconConstraints: BoxConstraints(minWidth: 50, maxWidth: 100),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

class AddOrderButton extends StatelessWidget {
  const AddOrderButton({
    @required this.descTextEditingController,
    @required this.priceTextEditingController,
    @required this.refresh,
    @required this.scaffoldKey,
    @required this.doc,
  });
  final TextEditingController descTextEditingController;
  final TextEditingController priceTextEditingController;
  final Function refresh;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final DocumentSnapshot doc;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: RaisedButton(
        color: utils.kGrey,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        onPressed: () {
          refresh(() => _isLoading = true);
          if (checkTextControllers(context) == true) uploadToDatabase();
        },
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Add this order",
              style: utils.kTextStyle.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool checkTextControllers(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
    if (descTextEditingController.text.isEmpty) {
      scaffoldKey.currentState
          .showSnackBar(utils.kSnackBar("Please enter order description"));
      return refresh(() => _isLoading = false);
    } else if (priceTextEditingController.text.isEmpty) {
      scaffoldKey.currentState
          .showSnackBar(utils.kSnackBar("Please enter price"));
      return refresh(() => _isLoading = false);
    } else
      return true;
  }

  uploadToDatabase() {
    try {
      doc.reference.collection("orders").add({
        "description": descTextEditingController.text,
        "price": priceTextEditingController.text,
        "timestamp": FieldValue.serverTimestamp(),
      }).whenComplete(() {
        refresh(() => _isLoading = false);
        scaffoldKey.currentState.showSnackBar(
          utils.kSnackBar("Order added successfully!"),
        );
      });
    } catch (e) {
      print(e);
      refresh(() => _isLoading = false);
      scaffoldKey.currentState
          .showSnackBar(utils.kSnackBar("Failed to add order"));
    }
  }
}
