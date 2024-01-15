import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:order_online_app/core/router/app_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_color.dart';
import '../../../../core/constants/app_string.dart';
import '../../../../core/constants/text_size.dart';
import '../../../../core/constants/web_endpoint.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/widgets/solid_button.dart';
import '../../../../core/widgets/text_field_widget.dart';
import '../provider/authentication_provider.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

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
            key: authProvider.signupFormKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: size.height * .02),
                const Center(
                  child: Text(AppString.appName,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: AppColor.primaryColor,
                          fontSize: 32,
                          fontWeight: FontWeight.bold)),
                ),
                SizedBox(height: size.height * .01),
                const Text('Welcome to ${AppString.appName}! 👏',
                    style: TextStyle(
                        fontSize: TextSize.titleText,
                        fontWeight: FontWeight.bold)),
                SizedBox(height: size.height * .01),
                const Text('Please sign-up and start the\nadventure',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColor.secondaryTextColor)),
                SizedBox(height: size.height * .05),
                TextFormFieldWidget(
                  controller: authProvider.nameController,
                  labelText: 'Full Name',
                  hintText: 'Enter your full name',
                  required: true,
                  textInputType: TextInputType.name,
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: 20),
                TextFormFieldWidget(
                  controller: authProvider.emailController,
                  labelText: 'Email Address',
                  hintText: 'Enter your email',
                  required: true,
                  textInputType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),
                TextFormFieldWidget(
                  controller: authProvider.phoneController,
                  labelText: 'Phone Number',
                  hintText: 'Enter your phone number',
                  required: true,
                  textInputType: TextInputType.phone,
                ),
                const SizedBox(height: 20),
                TextFormFieldWidget(
                  controller: authProvider.passwordController,
                  obscure: true,
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  required: true,
                ),
                const SizedBox(height: 20),
                TextFormFieldWidget(
                  controller: authProvider.confirmPasswordController,
                  obscure: true,
                  labelText: 'Confirm Password',
                  hintText: 'Enter your confirm password',
                  required: true,
                ),

                ///Privacy Policy
                Row(
                  children: [
                    Checkbox(
                        value: authProvider.privacyPolicyUrl,
                        onChanged: (bool? newValue) {
                          authProvider.privacyPolicyUrlOnChange(newValue!);
                        }),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                              color: AppColor.textColor,
                              fontSize: TextSize.bodyText),
                          children: [
                            const TextSpan(text: 'I agree to '),
                            TextSpan(
                              text: 'privacy policy',
                              style:
                                  const TextStyle(color: AppColor.primaryColor),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () async {
                                  Navigator.pushNamed(
                                      context, AppRouter.privacyTerms,
                                      arguments:
                                          '${WebEndpoint.baseUrl}${WebEndpoint.privacyPolicyUrl}');
                                },
                            ),
                            const TextSpan(text: ' & '),
                            TextSpan(
                              text: 'terms',
                              style:
                                  const TextStyle(color: AppColor.primaryColor),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () async {
                                  Navigator.pushNamed(
                                      context, AppRouter.privacyTerms,
                                      arguments:
                                          '${WebEndpoint.baseUrl}${WebEndpoint.termsAndConditionUrl}');
                                },
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10),

                ///Signup Button
                SolidButton(
                    onTap: () async {
                      await authProvider.signupButtonOnTap();
                    },
                    child: authProvider.loading
                        ? const LoadingWidget(color: Colors.white)
                        : const Text(
                            'SIGN UP',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: TextSize.buttonText,
                                fontWeight: FontWeight.bold),
                          )),
                const SizedBox(height: 24),

                ///Already have an account
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                        color: AppColor.textColor, fontSize: TextSize.bodyText),
                    children: [
                      const TextSpan(text: 'Already have an account? '),
                      TextSpan(
                        text: 'SIGN IN',
                        style: const TextStyle(color: AppColor.primaryColor),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            authProvider.clearPassword();
                            Navigator.pop(context);
                          },
                      ),
                    ],
                  ),
                ),
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
                const SizedBox(height: 24),

                ///Google Login Button
                SolidButton(
                    onTap: () {},
                    backgroundColor: AppColor.googleButtonColor,
                    child: Row(
                      children: [
                        Container(
                          width: 60,
                          height: double.infinity,
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border:
                                  Border.all(color: AppColor.googleButtonColor),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(5),
                                bottomLeft: Radius.circular(5),
                              )),
                          child: Image.asset('assets/images/google_logo.png'),
                        ),
                        const Expanded(
                          child: Text(
                            'SIGN IN WITH GOOGLE',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: TextSize.buttonText,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    )),
                const SizedBox(height: 24),

                ///Facebook Login Button
                SolidButton(
                    onTap: () {},
                    backgroundColor: AppColor.facebookButtonColor,
                    child: Row(
                      children: [
                        Container(
                          width: 60,
                          height: double.infinity,
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  color: AppColor.facebookButtonColor),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(5),
                                bottomLeft: Radius.circular(5),
                              )),
                          child: Image.asset('assets/images/facebook_logo.png'),
                        ),
                        const Expanded(
                          child: Text(
                            'SIGN IN WITH FACEBOOK',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: TextSize.buttonText,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    )),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
