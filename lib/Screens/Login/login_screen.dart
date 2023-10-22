import 'package:flutter/material.dart';
import 'package:unipay/responsive.dart';
import '../../components/background.dart';
import '../../constants.dart';
import '../Signup/components/socal_sign_up.dart';
import 'components/login_form.dart';
import 'components/login_screen_top_image.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Background(
      child: SingleChildScrollView(
        child: Responsive(
          mobile: MobileLoginScreen(),
          desktop: Row(
            children: [
              const Expanded(
                child: LoginScreenTopImage(),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 450,
                      child: LoginForm(),
                    ),
                    SizedBox(height: defaultPadding / 2,
                        child: SocalSignUp()
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}


class MobileLoginScreen extends StatelessWidget {
  const MobileLoginScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        LoginScreenTopImage(),
        Row(
          children: [
            Spacer(),
            Expanded(
              flex: 8,
              child: LoginForm(),
            ),
            Spacer(),
          ],
        ),
        SocalSignUp()
      ],
    );
  }
}
