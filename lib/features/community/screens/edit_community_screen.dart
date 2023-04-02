import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rivaan_j_reddit/core/common/error_text.dart';

import '../../../core/common/app_loader.dart';
import '../../../core/constants/constants.dart';
import '../../../core/utils.dart';
import '../../../models/community_model.dart';
import '../controller/community_controller.dart';

final bannerFileProvider = StateProvider<File?>((ref) => null);
final profileFileProvider = StateProvider<File?>((ref) => null);
final bannerWebFileProvider = StateProvider<Uint8List?>((ref) => null);
final profileWebFileProvider = StateProvider<Uint8List?>((ref) => null);

class EditCommunityScreen extends HookConsumerWidget {
  final String name;

  const EditCommunityScreen({
    super.key,
    required this.name,
  });

  void selectProfileImage(WidgetRef ref) async {
    final res = await pickImage();

    if (res != null) {
      if (kIsWeb) {
        ref.read(profileWebFileProvider.notifier).update(
              (state) => res.files.first.bytes,
            );
      } else {
        ref.read(profileFileProvider.notifier).update(
              (state) => File(
                res.files.first.path!,
              ),
            );
      }
    }
  }

  void selectBannerImage(WidgetRef ref) async {
    final res = await pickImage();

    if (res != null) {
      if (kIsWeb) {
        ref.read(bannerWebFileProvider.notifier).update(
              (state) => res.files.first.bytes,
            );
      } else {
        ref.read(bannerFileProvider.notifier).update(
              (state) => File(
                res.files.first.path!,
              ),
            );
      }
    }
  }

  void save(
    Community community,
    WidgetRef ref,
    BuildContext context,
    File? bannerFile,
    File? profileFile,
    Uint8List? bannerWebFile,
    Uint8List? profileWebFile,
  ) {
    ref.read(communityControllerProvider.notifier).editCommunity(
          profileFile: profileFile,
          bannerFile: bannerFile,
          context: context,
          community: community,
          profileWebFile: profileWebFile,
          bannerWebFile: bannerWebFile,
        );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(communityControllerProvider);
    // final currentTheme = ref.watch(themeNotifierProvider);

    final bannerFile = ref.watch(bannerFileProvider);
    final profileFile = ref.watch(profileFileProvider);
    final bannerWebFile = ref.watch(bannerWebFileProvider);
    final profileWebFile = ref.watch(profileWebFileProvider);

    return ref.watch(getCommunityByNameProvider(name)).when(
          data: (community) => Scaffold(
            // backgroundColor: currentTheme.backgroundColor,
            appBar: AppBar(
              title: const Text('Edit Community'),
              centerTitle: false,
              actions: [
                TextButton(
                  onPressed: () => save(
                    community,
                    ref,
                    context,
                    bannerFile,
                    profileFile,
                    bannerWebFile,
                    profileWebFile,
                  ),
                  child: const Text('Save'),
                ),
              ],
            ),
            body: isLoading
                ? const AppLoader()
                : Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 200,
                          child: Stack(
                            children: [
                              GestureDetector(
                                onTap: () => selectBannerImage(ref),
                                child: DottedBorder(
                                  borderType: BorderType.RRect,
                                  radius: const Radius.circular(10),
                                  dashPattern: const [10, 4],
                                  strokeCap: StrokeCap.round,
                                  color: Colors.white,
                                  child: Container(
                                    width: double.infinity,
                                    height: 150,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: bannerWebFile != null
                                        ? Image.memory(bannerWebFile)
                                        : bannerFile != null
                                            ? Image.file(bannerFile)
                                            : community.banner.isEmpty ||
                                                    community.banner ==
                                                        Constants.bannerDefault
                                                ? const Center(
                                                    child: Icon(
                                                      Icons.camera_alt_outlined,
                                                      size: 40,
                                                    ),
                                                  )
                                                : Image.network(
                                                    community.banner),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 20,
                                left: 20,
                                child: GestureDetector(
                                  onTap: () => selectProfileImage(ref),
                                  child: profileWebFile != null
                                      ? CircleAvatar(
                                          backgroundImage:
                                              MemoryImage(profileWebFile),
                                          radius: 32,
                                        )
                                      : profileFile != null
                                          ? CircleAvatar(
                                              backgroundImage:
                                                  FileImage(profileFile),
                                              radius: 32,
                                            )
                                          : CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                community.avatar,
                                              ),
                                              radius: 32,
                                            ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
          error: (e, s) => ErrorText(error: '$e'),
          loading: () => const AppLoader(),
        );
  }
}
