import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:rivaan_j_reddit/core/common/app_loader.dart';

import '../controller/community_controller.dart';

class CreateCommunityScreen extends HookConsumerWidget {
  const CreateCommunityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final communityController = useTextEditingController();

    void createCommunity(WidgetRef ref) {
      ref.read(communityControllerProvider.notifier).createCommunity(
            communityController.text.trim(),
            context,
          );
    }

    final isLoading = ref.watch(communityControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create a community'),
      ),
      body: isLoading
          ? const AppLoader()
          : Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Text('Community Name'),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: communityController,
                    maxLength: 21,
                    decoration: const InputDecoration(
                      hintText: 'r/Community_name',
                      contentPadding: EdgeInsets.all(18),
                      filled: true,
                      border: InputBorder.none,
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () => createCommunity(ref),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      'Create community',
                      style: TextStyle(
                        fontSize: 17,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
