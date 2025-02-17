import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DiscoverTabPage extends StatelessWidget {
  const DiscoverTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const DiscoverTabPageView();
  }
}

class DiscoverTabPageView extends StatefulWidget {
  const DiscoverTabPageView({super.key});

  @override
  State<DiscoverTabPageView> createState() => _DiscoverTabPageViewState();
}

class _DiscoverTabPageViewState extends State<DiscoverTabPageView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 3);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BasePage(
      scrollView: false,
      padding: EdgeInsets.zero,
      backgroundColor: Theme.of(context).colorScheme.transparent,
      body: BlocBuilder<HomeTabbarCubit, int>(
        builder: (context, tabState) {
          _tabController.index = tabState;
          return Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: Sizes.spaceSmall),
                child: TabBar(
                  controller: _tabController,
                  padding: const EdgeInsets.symmetric(
                    horizontal: Sizes.space2XSmall,
                  ),
                  indicatorPadding: EdgeInsets.zero,
                  labelPadding: const EdgeInsets.symmetric(
                    horizontal: Sizes.space2XSmall,
                  ),
                  indicatorWeight: 0.0000001,
                  indicator: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.zero,
                    border: Border.all(
                      color: Colors.transparent,
                      width: 0,
                    ),
                  ),
                  indicatorSize: TabBarIndicatorSize.label,
                  tabs: [
                    MyTab(
                      text: l10n.cards,
                      icon: tabState == 0
                          ? IconStrings.cards
                          : IconStrings.cardsBlur,
                      isSelected: tabState == 0,
                      onPressed: () {
                        _tabController.animateTo(0);
                        context.read<HomeTabbarCubit>().setIndex(0);
                      },
                    ),
                    MyTab(
                      text: l10n.nfts,
                      icon: tabState == 1
                          ? IconStrings.ghost
                          : IconStrings.ghostBlur,
                      isSelected: tabState == 1,
                      onPressed: () {
                        _tabController.animateTo(1);
                        context.read<HomeTabbarCubit>().setIndex(1);
                      },
                    ),
                    MyTab(
                      text: l10n.coins,
                      icon: tabState == 2
                          ? IconStrings.health
                          : IconStrings.healthBlur,
                      isSelected: tabState == 2,
                      onPressed: () {
                        _tabController.animateTo(2);
                        context.read<HomeTabbarCubit>().setIndex(2);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: Sizes.spaceSmall),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: TabBarView(
                    controller: _tabController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      const DiscoverPage(),
                      MWebViewPage(
                        url: Urls.discoverNftsWebView,
                        onNavigationRequest: (request) async {
                          if (!request.url.startsWith(
                            Urls.discoverCoinsWebView,
                          )) {
                            await LaunchUrl.launch(request.url);
                            return NavigationDecision.prevent;
                          } else {
                            return NavigationDecision.navigate;
                          }
                        },
                      ),
                      MWebViewPage(
                        url: Urls.discoverCoinsWebView,
                        onNavigationRequest: (request) async {
                          if (!request.url
                              .startsWith(Urls.discoverCoinsWebView)) {
                            /// if a link has a different base URL than the
                            /// current webpage, it should be opened in an
                            /// external browser because of dynamic links
                            await LaunchUrl.launch(request.url);
                            return NavigationDecision.prevent;
                          } else {
                            return NavigationDecision.navigate;
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
