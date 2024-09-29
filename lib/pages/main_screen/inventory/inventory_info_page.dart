import 'package:flutter/material.dart';

class InventoryInfoPage extends StatefulWidget {
  const InventoryInfoPage({super.key});

  @override
  State<InventoryInfoPage> createState() => _InventoryInfoPageState();
}

class _InventoryInfoPageState extends State<InventoryInfoPage>
    with TickerProviderStateMixin {
  late final ScrollController scrollController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // BlocProvider.of<ReviewScheduleSimultaneousModeBloc>(context)
      //     .add(InitialLoadReviewScheduleSimultaneousModeEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: onWillPop,
        child: Scaffold(
          key: _scaffoldKey,
          resizeToAvoidBottomInset: true,
          body: Scrollbar(
            controller: scrollController,
            interactive: true,
            child: NestedScrollView(
              controller: scrollController,
              physics: const ClampingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverResizingHeader(
                    child: SliverAppBar(
                      pinned: true,
                      backgroundColor: Colors.white,
                      centerTitle: false,
                      leading: IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          onWillPop();
                        },
                        tooltip:
                            MaterialLocalizations.of(context).backButtonTooltip,
                      ),
                      title: Text(
                        'Inventory ',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.w700, color: Colors.black),
                      ),
                    ),
                  ),
                ];
              },
              body: CustomScrollView(
                
              )
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  Future<bool> onWillPop() async {
    return true;
  }
}
