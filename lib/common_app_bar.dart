import 'package:flutter/material.dart';
import 'package:sudoku_app/services/bgm_service.dart';

enum BgmAction { bgm1, bgm2, bgm3, bgm4, disable }

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback onToggleTheme;
  final ThemeMode themeMode;
  final List<Widget>? actions;
  final bool showBack;

  const CommonAppBar({
    super.key,
    required this.title,
    required this.onToggleTheme,
    required this.themeMode,
    this.actions,
    this.showBack = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final canGoBack = Navigator.of(context).canPop();
    return AppBar(
      title: Text(title),
      automaticallyImplyLeading: showBack && canGoBack,
      actions: [
        if (actions != null) ...actions!,
        ValueListenableBuilder<bool>(
          valueListenable: BgmService.instance.isPlaying,
          builder: (_, isPlaying, _) {
            return PopupMenuButton(
              icon: Icon(isPlaying ? Icons.music_note : Icons.music_off),
              onSelected: (value) async {
                switch (value) {
                  case BgmAction.bgm1:
                    await BgmService.instance.selectAndPlay(0);
                    break;
                  case BgmAction.bgm2:
                    await BgmService.instance.selectAndPlay(1);
                    break;
                  case BgmAction.bgm3:
                    await BgmService.instance.selectAndPlay(2);
                    break;
                  case BgmAction.bgm4:
                    await BgmService.instance.selectAndPlay(3);
                    break;
                  case BgmAction.disable:
                    await BgmService.instance.stop();
                    break;
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(value: BgmAction.bgm1, child: Text("Music 1")),
                const PopupMenuItem(value: BgmAction.bgm2, child: Text("Music 2")),
                const PopupMenuItem(value: BgmAction.bgm3, child: Text("Music 3")),
                const PopupMenuItem(value: BgmAction.bgm4, child: Text("Music 4")),
                const PopupMenuItem(value: BgmAction.disable, child: Text("Disable BGM")),
              ],
            );
          },
        ),
        IconButton(
          onPressed: onToggleTheme,
          icon: Icon(themeMode == ThemeMode.light ? Icons.dark_mode : Icons.light_mode),
        ),
      ],
    );
  }
}
