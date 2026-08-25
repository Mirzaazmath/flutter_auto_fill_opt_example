import 'package:flutter/material.dart';
import 'package:sms_autofill/sms_autofill.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> with CodeAutoFill {
  String otp = '';
  String appSignature = '';

  @override
  void initState() {
    super.initState();

    _initializeSmsAutoFill();
  }

  Future<void> _initializeSmsAutoFill() async {
    // Get the SMS Retriever app hash
    final signature = await SmsAutoFill().getAppSignature;

    debugPrint('================================');
    debugPrint('SMS APP SIGNATURE: $signature');
    debugPrint('================================');

    if (mounted) {
      setState(() {
        appSignature = signature;
      });
    }

    // Start listening for OTP
    listenForCode();
  }

  @override
  void codeUpdated() {
    debugPrint('OTP RECEIVED: $code');

    if (code != null && code!.isNotEmpty) {
      setState(() {
        otp = code!;
      });
    }
  }

  @override
  void dispose() {
    cancel();
    SmsAutoFill().unregisterListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OTP Verification'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter OTP',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            PinFieldAutoFill(
              codeLength: 4,
              currentCode: otp,
              onCodeChanged: (value) {
                if (value != null) {
                  setState(() {
                    otp = value;
                  });
                }
              },
            ),

            const SizedBox(height: 30),

            const Text(
              'App Signature:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            SelectableText(
              appSignature.isEmpty
                  ? 'Getting signature...'
                  : appSignature,
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: otp.length == 4
                  ? () {
                debugPrint('VERIFY OTP: $otp');
              }
                  : null,
              child: const Text('Verify OTP'),
            ),
          ],
        ),
      ),
    );
  }
}