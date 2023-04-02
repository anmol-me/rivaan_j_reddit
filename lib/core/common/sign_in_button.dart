import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rivaan_j_reddit/theme/palette.dart';

import '../../features/auth/controller/auth_controller.dart';
import '../constants/constants.dart';

class SignInButton extends ConsumerWidget {
  final BuildContext loginContext;

  const SignInButton({
    super.key,
    required this.loginContext,
  });

  void signInWithGoogle(WidgetRef ref, BuildContext loginContext) {
    ref.read(authControllerProvider.notifier).signInWithGoogle(loginContext);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: ElevatedButton.icon(
        onPressed: () => signInWithGoogle(ref, loginContext),
        icon: Image.asset(
          Constants.googlePath,
          width: 35,
        ),
        label: const Text(
          'Continue with google',
          style: TextStyle(fontSize: 18),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Palette.greyColor,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}
