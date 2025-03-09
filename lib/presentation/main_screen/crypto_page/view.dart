import 'package:currency_app/presentation/main_screen/crypto_page/event.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../items/crypto_item.dart';
import '../../items/show_case_template.dart';
import 'bloc.dart';
import 'state.dart';

class CryptoPage extends StatefulWidget {
  final NotificationListenerCallback<ScrollNotification> onScrollNotification;
  final VoidCallback addedToFavorite;

  const CryptoPage({super.key, required this.onScrollNotification, required this.addedToFavorite});

  @override
  State<CryptoPage> createState() => _CryptoPageState();
}

class _CryptoPageState extends State<CryptoPage> with TickerProviderStateMixin {
  var controller = TextEditingController();
  double _offset = 100;
  int currentPage = 1;
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey cryptoItem = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => CryptoPageBloc()..add(GetCryptoEvent(start: 0)),
      child: BlocListener<CryptoPageBloc, CryptoPageState>(
        listener: (context, state) {
          if (state.showCaseView != null && state.showCaseView == false) {
            ShowCaseWidget.of(context).startShowCase([cryptoItem]);
            context.read<CryptoPageBloc>().add(DoNotShowCaseViewEvent());
          }
        },
        child: Builder(builder: (context) => _buildPage(context)),
      ),
    );
  }

  Widget _buildPage(BuildContext context) {
    final bloc = BlocProvider.of<CryptoPageBloc>(context);
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        if (notification is UserScrollNotification) {
          widget.onScrollNotification;
          if (notification.direction == ScrollDirection.reverse) {
            setState(() => _offset = -100);
          } else if (notification.direction == ScrollDirection.forward) {
            setState(() => _offset = 100);
          }
        }
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(30))),
          backgroundColor: Color(0xFF673bb8),
          title: AnimatedCrossFade(
            duration: Duration(milliseconds: 300),
            crossFadeState: _isSearching ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            firstChild: Stack(
              alignment: Alignment.centerRight,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text("Crypto", key: ValueKey('title'), style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 20)),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    color: Colors.white,
                    icon: AnimatedSwitcher(
                      duration: Duration(milliseconds: 300),
                      child: _isSearching ? Icon(Icons.close, key: ValueKey('close')) : Icon(Icons.search, key: ValueKey('search')),
                    ),
                    onPressed: () {
                      _searchController.clear();
                      setState(() {
                        _isSearching = !_isSearching;
                        if (!_isSearching) {
                          _searchController.clear();
                        }
                      });
                    },
                  ),
                ),
              ],
            ),
            secondChild: Stack(
              alignment: Alignment.centerLeft,
              children: [
                TextField(
                  key: ValueKey('search'),
                  controller: _searchController,
                  autofocus: true,
                  cursorColor: Colors.white,
                  decoration: InputDecoration(hintText: 'Поиск...', border: InputBorder.none, hintStyle: TextStyle(color: Colors.white70)),
                  style: TextStyle(color: Colors.white),
                  onChanged: (value) {
                    if (value.isEmpty) {
                      bloc.add(SearchCryptoEvent(name: ""));
                    }
                    bloc.add(SearchCryptoEvent(name: value));
                  },
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    color: Colors.white,
                    icon: AnimatedSwitcher(
                      duration: Duration(milliseconds: 300),
                      child: _isSearching ? Icon(Icons.close, key: ValueKey('close')) : Icon(Icons.search, key: ValueKey('search')),
                    ),
                    onPressed: () {
                      bloc.add(SearchCryptoEvent(name: ''));
                      setState(() {
                        _isSearching = !_isSearching;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          centerTitle: true,
          titleTextStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 20),
        ),
        body: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: BlocBuilder<CryptoPageBloc, CryptoPageState>(
                    builder: (context, state) {
                      if (state.status == CryptoPageStatus.loading) {
                        return Center(child: CupertinoActivityIndicator(radius: 15));
                      } else if (state.status == CryptoPageStatus.success) {
                        if (state.list!.isEmpty) {
                          return CupertinoActivityIndicator(radius: 15);
                        } else {
                          return ListView.builder(
                            itemCount: state.list!.length,
                            itemBuilder: (context, index) {
                              return index == 0
                                  ? ShowCaseTemplate(
                                    total: 1,
                                    globalKey: cryptoItem,
                                    isFinished: true,
                                    height: 100,
                                    width: MediaQuery.of(context).size.width * 0.5,
                                    shape: RoundedRectangleBorder(),
                                    isTitleRequired: false,
                                    description: "If you double tap on a crypto, it will be added to your favorites.",
                                    currentShowCase: "1",
                                    child: CryptoItem(
                                      crypto: state.list![index],
                                      time: state.data!.info!.time!,
                                      onDoubleTap: () {
                                        widget.addedToFavorite();
                                        bloc.add(AddCryptoToFavoriteEvent(cryptoId: state.list![index].id!));
                                      },
                                    ),
                                  )
                                  : CryptoItem(
                                    crypto: state.list![index],
                                    time: state.data!.info!.time!,
                                    onDoubleTap: () {
                                      widget.addedToFavorite();
                                      bloc.add(AddCryptoToFavoriteEvent(cryptoId: state.list![index].id!));
                                    },
                                  );
                            },
                          );
                        }
                      } else if (state.status == CryptoPageStatus.fail) {
                        return Center(child: Text(state.errorMessage ?? 'Unknown Error'));
                      }
                      return Center();
                    },
                  ),
                ),
              ],
            ),
            AnimatedPositioned(
              duration: Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              bottom: _offset,
              left: 0,
              right: 0,
              child: _buildPaginationRow(bloc),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaginationRow(CryptoPageBloc bloc) {
    return Center(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade300, width: 1),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () {
                if (currentPage > 1) {
                  setState(() {
                    currentPage -= 1;
                  });
                  bloc.add(GetCryptoEvent(start: currentPage - 1));
                }
              },
              icon: Icon(Icons.arrow_back_ios_rounded, size: 20),
              color: currentPage > 1 ? Colors.blue.shade800 : Colors.grey.shade400,
              splashColor: Colors.blue.shade100,
              padding: const EdgeInsets.all(12),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: Text(
                '$currentPage',
                key: ValueKey<int>(currentPage),
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey.shade800),
              ),
            ),
            IconButton(
              onPressed: () {
                if (currentPage < 11) {
                  setState(() {
                    currentPage += 1;
                  });
                  bloc.add(GetCryptoEvent(start: currentPage + 1));
                }
              },
              icon: Icon(Icons.arrow_forward_ios_rounded, size: 20),
              color: currentPage < 11 ? Colors.blue.shade800 : Colors.grey.shade400,
              splashColor: Colors.blue.shade100,
              padding: const EdgeInsets.all(12),
            ),
          ],
        ),
      ),
    );
  }
}
