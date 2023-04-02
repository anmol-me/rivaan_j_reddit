import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rivaan_j_reddit/router.dart';
import 'package:rivaan_j_reddit/theme/palette.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:routemaster/routemaster.dart';
import 'core/common/app_loader.dart';
import 'core/common/error_text.dart';
import 'features/auth/controller/auth_controller.dart';
import 'firebase_options.dart';
import 'models/user_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

final userModelProvider = StateProvider<UserModel?>((ref) => null);

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void getUserData(
      WidgetRef ref,
      User fireUser,
    ) async {
      final userModel = await ref
          .read(authControllerProvider.notifier)
          .getUserData(fireUser.uid)
          .first;

      ref.read(userModelProvider.notifier).update((state) => userModel);
      ref.read(userProvider.notifier).update((state) => userModel);
    }

    return ref.watch(authStateChangesProvider).when(
          data: (fireUser) => MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'Reddit App',
            theme: Palette.darkModeAppTheme,
            // home: const LoginScreen(),
            routerDelegate: RoutemasterDelegate(
              routesBuilder: (BuildContext context) {
                if (fireUser != null) {
                  log('User Logged In');
                  getUserData(ref, fireUser);

                  if (ref.read(userModelProvider) != null) {
                    return loggedInRoute;
                  }
                } else {
                  log('User Logged Out');
                  return loggedOutRoute;
                }
                return loggedOutRoute;
              },
            ),
            routeInformationParser: const RoutemasterParser(),
          ),
          error: (error, s) => ErrorText(error: '$error'),
          loading: () => const AppLoader(),
        );
  }
}

// class MyApp extends ConsumerStatefulWidget {
//   const MyApp({super.key});
//
//   @override
//   ConsumerState createState() => _MyAppState();
// }
//
// class _MyAppState extends ConsumerState<MyApp> {
//   UserModel? userModel;
//
//   void getUserData(User data) async {
//     userModel = await ref
//         .read(authControllerProvider.notifier)
//         .getUserData(data.uid)
//         .first;
//
//     ref.read(userProvider.notifier).update((state) => userModel);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     return ref.watch(authStateChangesProvider).when(
//           data: (fireUser) => MaterialApp.router(
//             debugShowCheckedModeBanner: false,
//             title: 'Reddit App',
//             theme: Palette.darkModeAppTheme,
//             // home: const LoginScreen(),
//             routerDelegate: RoutemasterDelegate(
//               routesBuilder: (BuildContext context) {
//                 // 1
//                 if (fireUser != null) {
//                   getUserData(
//                     fireUser,
//                     // userModelController,
//                   );
//
//                   // 2
//                   if (userModel != null) {
//                     return loggedInRoute;
//                   }
//                 }
//                 return loggedOutRoute;
//               },
//             ),
//             routeInformationParser: const RoutemasterParser(),
//           ),
//           error: (error, s) => ErrorText(error: '$error'),
//           loading: () => const AppLoader(),
//         );
//   }
// }
