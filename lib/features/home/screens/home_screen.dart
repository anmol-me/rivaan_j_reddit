import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rivaan_j_reddit/main.dart';

import '../../auth/controller/auth_controller.dart';
import '../drawers/community_list_drawer.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // After successful Login
    final user = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('Home'),
        // leading: IconButton(
        //   onPressed: () {},
        //   icon: const Icon(Icons.menu),
        // ),
        actions: [
          TextButton(
            onPressed: () {
              ref.read(authControllerProvider.notifier).signOutGoogle();
              ref.read(userModelProvider.notifier).update((state) => null);
            },
            child: const Text('Out'),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {},
            icon: CircleAvatar(
              backgroundImage: NetworkImage(user?.profilePic ?? ''),
            ),
          ),
        ],
      ),
      drawer: const CommunityListDrawer(),
      body: Center(
        child: Text(user?.name ?? 'No Name'),
      ),
    );
  }
}
