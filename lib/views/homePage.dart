import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController amountController = new TextEditingController();
  TextEditingController nameController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();
  TextEditingController mobileController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  late Razorpay razorpay;

  @override
  void initState() {
    super.initState();
    razorpay = new Razorpay();
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlerPaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlerErrorFailure);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handlerExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    razorpay.clear();
  }

  void openCheckout() {
    var options = {
      "key": "rzp_test_CHtxQgfKIZiCef",
      "amount": num.parse(amountController.text) * 100,
      "name": nameController.text,
      "description": descriptionController.text,
      "prefill": {
        "contact": mobileController.text,
        "email": emailController.text,
      },
      "external": {
        "wallets": ["paytm"]
      }
    };
    try {
      razorpay.open(options);
    } catch (e) {
      print(e.toString());
    }
  }

  void handlerPaymentSuccess() {
    Fluttertoast.showToast(
      msg: "Payment successful!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
    );
  }

  void handlerErrorFailure() {
    Fluttertoast.showToast(
      msg: "Payment error!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
    );
  }

  void handlerExternalWallet() {
    Fluttertoast.showToast(
      msg: "External wallet!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0XFF012652).withOpacity(0.8),
        title: Text(
          "Razorpay",
          style: GoogleFonts.lato(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 73),
            textField(nameController, "Enter name", TextInputType.text,
                Icons.people_alt),
            textField(
                mobileController, "Phone", TextInputType.number, Icons.phone),
            textField(emailController, "Enter email",
                TextInputType.emailAddress, Icons.email),
            textField(amountController, "Enter amount", TextInputType.number,
                Icons.money),
            textField(descriptionController, "Enter description",
                TextInputType.text, Icons.description),
            SizedBox(height: 60),
            SizedBox(
              width: 322,
              height: 60,
              child: ElevatedButton(
                child: Text(
                  'Pay',
                  style: GoogleFonts.lato(
                    fontSize: 25,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Color(0XFF012652).withOpacity(0.8),
                ),
                onPressed: () {
                  openCheckout();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container textField(controller, labelText, textInputType, prefixIcon) {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 7, 20, 7),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: Icon(prefixIcon),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0XFF012652).withOpacity(0.8),
            ),
          ),
          labelText: labelText,
          labelStyle: GoogleFonts.lato(),
        ),
        keyboardType: textInputType,
      ),
    );
  }
}
