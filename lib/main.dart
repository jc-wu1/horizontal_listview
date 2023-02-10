import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

void main() {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ScrollConfiguration(
        behavior: DisableGlow(),
        child: ListView(
          children: [
            FadedHorizontalList(
              backgroundColor: Colors.greenAccent,
              blankSpaceWidth: 200,
              imageWidget: Image.asset("assets/img1.png"),
              itemCount: 10,
              items: (context, index) {
                return const ProductCard();
              },
            ),
            FadedHorizontalList(
              blankSpaceWidth: 200,
              backgroundColor: Colors.blueAccent,
              imageWidget: Image.asset("assets/img2.png"),
              itemCount: 10,
              items: (context, index) {
                return const ProductCard();
              },
            ),
            FadedHorizontalList(
              blankSpaceWidth: 200,
              backgroundColor: Colors.amberAccent,
              imageWidget: Image.asset("assets/img3.png"),
              itemCount: 10,
              items: (context, index) {
                return const ProductCard();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  const ProductCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => print('OK'),
        child: Container(
          width: 175,
          height: 285,
          margin: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  child: Banner(
                    message: '1688',
                    location: BannerLocation.topEnd,
                    color: Colors.red,
                    child: Image.network(
                      'https://gweb-research-imagen.web.app/compositional/An%20oil%20painting%20of%20a%20British%20Shorthair%20cat%20wearing%20a%20cowboy%20hat%20and%20red%20shirt%20skateboarding%20on%20a%20beach./1_.jpeg',
                      fit: BoxFit.contain,
                      cacheWidth: 405,
                      cacheHeight: 426,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              const SizedBox(
                child: Text(
                  'TEstingggg',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(
                height: 6,
              ),
              const SizedBox(
                child: Text(
                  'Rp. 10.000',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Color(0xffFF8C00),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class FadedHorizontalList extends StatefulWidget {
  const FadedHorizontalList({
    super.key,
    required this.imageWidget,
    required this.blankSpaceWidth,
    required this.backgroundColor,
    required this.itemCount,
    required this.items,
  });

  final Widget imageWidget;
  final Color? backgroundColor;
  final double blankSpaceWidth;
  final int itemCount;
  final Widget Function(BuildContext context, int index) items;

  @override
  State<FadedHorizontalList> createState() => _FadedHorizontalListState();
}

class _FadedHorizontalListState extends State<FadedHorizontalList> {
  late ScrollController _scrollController;
  final GlobalKey _globalKey = GlobalKey();
  ValueNotifier<double> height = ValueNotifier<double>(0.0);
  ValueNotifier<double> scrollPosition = ValueNotifier<double>(0.0);

  @override
  void initState() {
    super.initState();

    dynamic dynamicInstance = SchedulerBinding.instance;

    dynamicInstance.addPostFrameCallback((timeStamp) {
      height.value = _globalKey.currentContext!.size!.height;
    });

    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  _scrollListener() {
    if (_scrollController.position.pixels <= widget.blankSpaceWidth) {
      scrollPosition.value = _scrollController.position.pixels < 0
          ? 0
          : _scrollController.position.pixels;
    }
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollEndNotification>(
      child: Container(
        decoration: BoxDecoration(
          color: widget.backgroundColor,
        ),
        key: _globalKey,
        child: Stack(
          children: [
            ValueListenableBuilder<double>(
              valueListenable: height,
              builder: (context, double data, child) {
                return SizedBox(
                  height: data,
                  child: ValueListenableBuilder<double>(
                    valueListenable: scrollPosition,
                    builder: (context, double data, child) {
                      return Opacity(
                        opacity: (data < widget.blankSpaceWidth
                            ? ((widget.blankSpaceWidth - data) /
                                        widget.blankSpaceWidth) <=
                                    0.2
                                ? 0.2
                                : ((widget.blankSpaceWidth - data) /
                                    widget.blankSpaceWidth)
                            : 0.2),
                        child: widget.imageWidget,
                      );
                    },
                  ),
                );
              },
            ),
            ScrollConfiguration(
              behavior: DisableGlow(),
              // child: SingleChildScrollView(
              //   controller: _scrollController,
              //   scrollDirection: Axis.horizontal,
              //   child: Padding(
              //     padding: EdgeInsetsDirectional.only(
              //       start: widget.blankSpaceWidth,
              //       top: 10,
              //       bottom: 10,
              //       end: 10,
              //     ),
              //     child: Row(
              //       children: widget.children,
              //     ),
              //   ),
              // ),
              child: SizedBox(
                height: 285,
                child: ListView.builder(
                  padding: EdgeInsetsDirectional.only(
                    start: widget.blankSpaceWidth,
                    top: 10,
                    bottom: 10,
                    end: 10,
                  ),
                  itemCount: widget.itemCount,
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: widget.items,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DisableGlow extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }
}
