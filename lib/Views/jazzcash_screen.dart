import 'package:flutter/material.dart';
import 'package:jazzcash_flutter/jazzcash_flutter.dart';


class JazzCashScreen extends StatefulWidget {
  final String productPrice;
  final String productName;
  const JazzCashScreen({Key? key,required this.productPrice,required this.productName}) : super(key: key);

  @override
  State<JazzCashScreen> createState() => _JazzCashScreenState();
}

class _JazzCashScreenState extends State<JazzCashScreen> {
  String paymentStatus = "pending";
 // ProductModel productModel = ProductModel("Product 1", "100");
  String integritySalt= "yutez0uw01";
  String merchantID= "MC57762";
  String merchantPassword = "4zc318v04w";
  String transactionUrl= "https://sandbox.jazzcash.com.pk/ApplicationAPI/API/Payment/DoTransaction";
  // String transactionUrl= "jazzcashtest://payment-response";


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Product Name : ${widget.productName}"),
            Text("Product Price : ${widget.productPrice}"),
            ElevatedButton(onPressed: () {
              _payViaJazzCash( context);

            }, child: const Text("Confirm to Purchase Now !"))
          ],
        ),
      ),
    );
  }


  Future _payViaJazzCash(BuildContext c) async {
    //print("clicked on Product ${element.productName}");

    try {
      JazzCashFlutter jazzCashFlutter = JazzCashFlutter(
        merchantId: merchantID,
        merchantPassword: merchantPassword,
        integritySalt: integritySalt,
        isSandbox: true,

      );

      DateTime date = DateTime.now();

      JazzCashPaymentDataModelV1 paymentDataModelV1 = JazzCashPaymentDataModelV1(
        ppAmount: '${widget.productPrice}',
        ppBillReference:'refbill${date.year}${date.month}${date.day}${date.hour}${date.millisecond}',
        ppDescription: 'Product details  ${widget.productName} - ${widget.productPrice}',
        ppMerchantID: merchantID,
        ppPassword:  merchantPassword,
        ppReturnURL: transactionUrl,
      );

      jazzCashFlutter.startPayment(paymentDataModelV1: paymentDataModelV1, context: context).then((_response) {
        print("response from jazzcash $_response");

        setState(() {});
        Navigator.pop(context);
      });
    } catch (err) {
      print("Error in payment $err");
      // CommonFunctions.CommonToast(
      //   message: "Error in payment $err",
      // );
      return false;
    }
  }

}

// class ProductModel {
//   String? productName;
//   String? productPrice;
//
//   ProductModel(this.productName, this.productPrice);
// }



