import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_color.dart';
import '../../../../core/constants/text_size.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/widgets/normal_card.dart';
import '../../../../core/widgets/solid_button.dart';
import '../../../../core/widgets/text_field_widget.dart';
import '../provider/authentication_provider.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final AuthenticationProvider authProvider = Provider.of(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColor.cardColor,
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            // key: authProvider.resetPasswordFormKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: size.height * .02),
                Center(child: Image.asset('assets/images/splash_logo.png')),
                const SizedBox(height: 24),
                const Text('Forgot Password?',
                    style: TextStyle(
                        fontSize: TextSize.titleText,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Text('Get password reset link',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColor.secondaryTextColor)),
                const SizedBox(height: 24),

                ///Email text field
                TextFormFieldWidget(
                  controller: authProvider.emailController,
                  labelText: 'Email Address',
                  hintText: 'Enter your email',
                  required: true,
                  textInputType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),

                ///Login Button
                SolidButton(
                    onTap: () async {
                      await authProvider.resetPasswordButtonOnTap();
                    },
                    child: authProvider.loading
                        ? const LoadingWidget(color: Colors.white)
                        : const Text(
                            'SEND RESET LINK',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: TextSize.buttonText,
                                fontWeight: FontWeight.bold),
                          )),
                const SizedBox(height: 24),

                ///Divider
                const Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                        child: Divider(
                            height: 0.0,
                            color: AppColor.secondaryTextColor,
                            thickness: 0.3)),
                    Text(' or ',
                        style: TextStyle(
                            color: AppColor.secondaryTextColor,
                            fontSize: TextSize.bodyText)),
                    Expanded(
                        child: Divider(
                            height: 0.0,
                            color: AppColor.secondaryTextColor,
                            thickness: 0.3)),
                  ],
                ),
                const SizedBox(height: 8),

                ///Back to login
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('BACK TO LOGIN',
                        style: TextStyle(fontSize: TextSize.buttonText))),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
