import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rivaan_j_reddit/core/common/app_loader.dart';
import 'package:routemaster/routemaster.dart';

import '../../../core/common/error_text.dart';
import '../../community/controller/community_controller.dart';

class CommunityListDrawer extends ConsumerWidget {
  const CommunityListDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void navigateToCreateCommunity(BuildContext context) {
      Routemaster.of(context).push('/create-community');
    }

    void navigateToCommunity(BuildContext context, String name) {
      Routemaster.of(context).push('/r/$name');
    }

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            ListTile(
              title: const Text('Create a community'),
              leading: const Icon(Icons.add),
              onTap: () => navigateToCreateCommunity(context),
            ),
            ref.watch(userCommunitiesProvider).when(
                  data: (communities) => Expanded(
                    child: ListView.builder(
                      itemCount: communities.length,
                      itemBuilder: (BuildContext context, int index) {
                        final community = communities[index];

                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(community.avatar),
                          ),
                          title: Text('r/${community.name}'),
                          onTap: () => navigateToCommunity(context, community.name),
                        );
                      },
                    ),
                  ),
                  error: (e, s) => ErrorText(error: '${e}'),
                  loading: () => const AppLoader(),
                ),
          ],
        ),
      ),
    );
  }
}
