import 'package:currency_app/presentation/main_screen/profile_page/state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc.dart';

class ProfilePage extends StatelessWidget {
  final NotificationListenerCallback<ScrollNotification> onScrollNotification;

  const ProfilePage({required this.onScrollNotification});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ProfilePageBloc(),
      child: BlocListener<ProfilePageBloc, ProfilePageState>(
        listener: (context, state) {},
        child: Builder(builder: (context) => _buildPage(context)),
      ),
    );
  }

  Widget _buildPage(BuildContext context) {
    final bloc = BlocProvider.of<ProfilePageBloc>(context);
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemBackground,
      navigationBar: CupertinoNavigationBar(
        middle: Text('Profile', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: CupertinoColors.label)),
        backgroundColor: CupertinoColors.systemGrey6,
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Переключатель темы
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: CupertinoColors.systemGrey6,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: CupertinoColors.systemGrey.withOpacity(0.1), blurRadius: 8, offset: Offset(0, 2))],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Тема', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: CupertinoColors.label)),
                    Row(
                      children: [
                        Icon(CupertinoIcons.sun_max, color: CupertinoColors.systemYellow),
                        SizedBox(width: 8),
                        Transform.scale(
                          scale: 0.8,
                          child: CupertinoSwitch(
                            // value: bloc.isDarkTheme,
                            value: false,
                            onChanged: (value) {
                              // bloc.add(ToggleThemeEvent(value));
                            },
                            activeColor: CupertinoColors.systemGreen,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(CupertinoIcons.moon, color: CupertinoColors.systemBlue),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Кнопка "Оценить приложение"
              _buildListTile(
                icon: CupertinoIcons.star,
                iconColor: CupertinoColors.systemYellow,
                title: 'Оценить приложение',
                onTap: () {
                  // _launchAppStore();
                },
              ),
              SizedBox(height: 16),

              // Кнопка "Отправить отзыв"
              _buildListTile(
                icon: CupertinoIcons.chat_bubble,
                iconColor: CupertinoColors.systemGreen,
                title: 'Отправить отзыв',
                onTap: () {
                  // _openFeedbackForm(context);
                },
              ),
              SizedBox(height: 16),

              // Кнопка "Поделиться"
              _buildListTile(
                icon: CupertinoIcons.share,
                iconColor: CupertinoColors.systemBlue,
                title: 'Поделиться',
                onTap: () {
                  // _shareApp(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Кастомный виджет для ListTile
  Widget _buildListTile({required IconData icon, required Color iconColor, required String title, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: CupertinoColors.systemGrey6,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: CupertinoColors.systemGrey.withOpacity(0.1), blurRadius: 8, offset: Offset(0, 2))],
        ),
        child: Row(
          children: [
            Icon(icon, color: iconColor),
            SizedBox(width: 16),
            Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: CupertinoColors.label)),
            Spacer(),
            Icon(CupertinoIcons.chevron_right, color: CupertinoColors.systemGrey),
          ],
        ),
      ),
    );
  }

  // void _launchAppStore() async {
  //   String appStoreUrl;
  //   if (Platform.isAndroid) {
  //     appStoreUrl = 'https://play.google.com/store/apps/details?id=com.example.app';
  //   } else if (Platform.isIOS) {
  //     appStoreUrl = 'https://apps.apple.com/app/id123456789';
  //   } else {
  //     throw 'Unsupported platform';
  //   }
  //
  //   if (await canLaunchUrl(Uri.parse(appStoreUrl))) {
  //     await launchUrl(Uri.parse(appStoreUrl));
  //   } else {
  //     throw 'Could not launch $appStoreUrl';
  //   }
  // }

  // void _openFeedbackForm(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: Text('Отправить отзыв'),
  //         content: Column(mainAxisSize: MainAxisSize.min, children: [TextField(decoration: InputDecoration(hintText: 'Ваш отзыв'), maxLines: 3)]),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.pop(context);
  //             },
  //             child: Text('Отмена'),
  //           ),
  //           TextButton(
  //             onPressed: () {
  //               Navigator.pop(context);
  //               ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Спасибо за ваш отзыв!')));
  //             },
  //             child: Text('Отправить'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  // void _shareApp(BuildContext context) async {
  //   final box = context.findRenderObject() as RenderBox?;
  //   const text = 'Попробуйте это приложение!';
  //   const url = 'https://play.google.com/store/apps/details?id=com.example.app';
  //   await Share.share('$text\n$url', sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
  // }
}
