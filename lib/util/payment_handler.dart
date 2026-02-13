import 'package:flutter_ecommerce_project/util/extentions/string_extentions.dart';
import 'package:flutter_ecommerce_project/util/url_handler.dart';
import 'package:uni_links/uni_links.dart';
import 'package:zarinpal/zarinpal.dart';

abstract class PaymentHandler {
  Future<void> initPaymentRequest(int finalPrice);
  Future<void> sendPaymentRequest();
  Future<void> verifyPaymentRequest();
}

class ZarinPalPaymentHandler extends PaymentHandler {
  final PaymentRequest _paymentRequest = PaymentRequest();
  String? _authority;
  String? _status;
  UrlHandler urlHandler;
  ZarinPalPaymentHandler(this.urlHandler);

  @override
  Future<void> initPaymentRequest(int finalPrice) async {
    _paymentRequest.setIsSandBox(true);
    _paymentRequest.setAmount(finalPrice);
    _paymentRequest.setDescription('testing');
    // _paymentRequest.setMerchantID('afe026fd-7f48-4ad1-8048-5d978266ff75');
    _paymentRequest.setMerchantID('d645fba8-1b29-11ea-be59-000c295eb8fc');
    _paymentRequest.setCallbackURL('expertflutter://shop');

    linkStream.listen((deepLink) {
      if (deepLink!.toLowerCase().contains('authority')) {
        _authority = deepLink.extractValueFromQuery('Authority');
        _status = deepLink.extractValueFromQuery('Status');

        // print(authority);
        // print(status);

        verifyPaymentRequest();
      }
    });
  }

  @override
  Future<void> sendPaymentRequest() async {
    ZarinPal().startPayment(_paymentRequest, (status, paymentGateWayUri) {
      if (status == 100) {
        urlHandler.openUrl(paymentGateWayUri!);
      } else {
        print('did not send');
      }
    });
  }

  @override
  Future<void> verifyPaymentRequest() async {
    ZarinPal().verificationPayment(_status!, _authority!, _paymentRequest,
        (isPaymentSuccess, refID, paymentRequest) {
      if (isPaymentSuccess) {
        print(refID);
      } else {
        print('error');
      }
    });
  }
}
