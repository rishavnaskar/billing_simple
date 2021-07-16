import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:pareezblling/components/utils.dart';

bool _isLoading = false;

class AddCustomer extends StatefulWidget {
  @override
  _AddCustomerState createState() => _AddCustomerState();
}

class _AddCustomerState extends State<AddCustomer> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  TextEditingController _nameTextEditingController;
  TextEditingController _phoneTextEditingController;
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
                HeadingRow(),
                Flexible(child: SizedBox(height: height * 0.1)),
                EnterData(
                    textEditingController: _nameTextEditingController,
                    label: "Customer Name"),
                Flexible(child: SizedBox(height: height * 0.14)),
                EnterData(
                    textEditingController: _phoneTextEditingController,
                    label: "Phone Number without +91"),
                Flexible(child: SizedBox(height: height * 0.4)),
                AddCustomerButton(
                  nameTextEditingController: _nameTextEditingController,
                  phoneTextEditingController: _phoneTextEditingController,
                  refresh: refresh,
                  scaffoldKey: _scaffoldKey,
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
    _nameTextEditingController = TextEditingController();
    _phoneTextEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _nameTextEditingController?.dispose();
    _phoneTextEditingController?.dispose();
    super.dispose();
  }
}

class HeadingRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(Icons.arrow_back),
          color: utils.kPink,
          padding: EdgeInsets.zero,
          constraints: BoxConstraints(),
          onPressed: () => Navigator.pop(context),
        ),
        Text(
          "Add a Customer",
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
      keyboardType: label == "Phone Number without +91"
          ? TextInputType.phone
          : TextInputType.name,
      controller: textEditingController,
      maxLength: label == "Phone Number without +91" ? 10 : null,
      maxLengthEnforced: label == "Phone Number without +91" ? true : false,
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

class AddCustomerButton extends StatelessWidget {
  const AddCustomerButton({
    @required this.nameTextEditingController,
    @required this.phoneTextEditingController,
    @required this.refresh,
    @required this.scaffoldKey,
  });
  final TextEditingController nameTextEditingController;
  final TextEditingController phoneTextEditingController;
  final Function refresh;
  final GlobalKey<ScaffoldState> scaffoldKey;

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
              "Add Customer",
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
    if (nameTextEditingController.text.isEmpty) {
      scaffoldKey.currentState
          .showSnackBar(utils.kSnackBar("Please enter customer name"));
      return refresh(() => _isLoading = false);
    } else if (phoneTextEditingController.text.isEmpty ||
        phoneTextEditingController.text.length < 10) {
      scaffoldKey.currentState
          .showSnackBar(utils.kSnackBar("Please enter customer phone number"));
      return refresh(() => _isLoading = false);
    } else
      return true;
  }

  uploadToDatabase() {
    try {
      Firestore.instance.collection("customers").add({
        "name": nameTextEditingController.text,
        "phone": "+91${phoneTextEditingController.text}",
      }).whenComplete(() {
        refresh(() => _isLoading = false);
        scaffoldKey.currentState
            .showSnackBar(utils.kSnackBar("Customer added successfully!"));
      });
    } catch (e) {
      print(e);
      refresh(() => _isLoading = false);
      scaffoldKey.currentState
          .showSnackBar(utils.kSnackBar("Failed to add customer"));
    }
  }
}
