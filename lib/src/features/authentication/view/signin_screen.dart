import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_color.dart';
import '../../../../core/constants/app_string.dart';
import '../../../../core/constants/text_size.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/widgets/solid_button.dart';
import '../../../../core/widgets/text_field_widget.dart';
import '../provider/authentication_provider.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

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
            // key: authProvider.signInFormKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: size.height * .02),
                const Center(
                    child: Hero(
                        tag: 'splashToSignIn',
                        child: Text(AppString.appName,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: AppColor.primaryColor, fontSize: 32,fontWeight: FontWeight.bold)),)),
                SizedBox(height: size.height * .01),
                const Text('Welcome to ${AppString.appName}! 👏',
                    style: TextStyle(
                        fontSize: TextSize.titleText,
                        fontWeight: FontWeight.bold)),
                SizedBox(height: size.height * .01),
                const Text(
                    'Please sign-in to your account and start the\nadventure',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColor.secondaryTextColor)),
                SizedBox(height: size.height * .05),
                TextFormFieldWidget(
                  controller: authProvider.emailController,
                  labelText: 'Email Address',
                  hintText: 'Enter your email',
                  required: true,
                  textInputType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),
                TextFormFieldWidget(
                  controller: authProvider.passwordController,
                  obscure: true,
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  required: true,
                ),

                ///Remember Me
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                        child: CheckboxListTile(
                            contentPadding: EdgeInsets.zero,
                            dense: true,
                            controlAffinity: ListTileControlAffinity.leading,
                            title: const Text('Remember Me',
                                style: TextStyle(fontSize: TextSize.bodyText)),
                            value: authProvider.rememberMe,
                            onChanged: (bool? newValue) {
                              authProvider.rememberMeOnChange(newValue!);
                            })),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                              context, AppRouter.forgotPassword);
                        },
                        child: const Text(
                          'FORGOT PASSWORD?',
                          style: TextStyle(
                              color: AppColor.primaryColor,
                              fontWeight: FontWeight.w500),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                ///Login Button
                SolidButton(
                    onTap: () async {
                      await authProvider.signInButtonOnTap();
                    },
                    child: authProvider.loading
                        ? const LoadingWidget(color: Colors.white)
                        : const Text(
                            'LOGIN',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: TextSize.buttonText,
                                fontWeight: FontWeight.bold),
                          )),
                const SizedBox(height: 24),

                ///Create Account
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                        color: AppColor.textColor, fontSize: TextSize.bodyText),
                    children: [
                      const TextSpan(text: 'New on our platform? '),
                      TextSpan(
                        text: 'CREATE AN ACCOUNT',
                        style: const TextStyle(color: AppColor.primaryColor),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            authProvider.clearPassword();
                            Navigator.pushNamed(context, AppRouter.signup);
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
                    onTap: () async{
                      await authProvider.signInWithGoogle();
                    },
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
                        Expanded(
                          child: authProvider.googleLoading
                              ? const Center(child: LoadingWidget(color: Colors.white))
                              : const Text(
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
                    onTap: () async{

                    },
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
