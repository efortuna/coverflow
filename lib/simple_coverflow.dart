import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Function that is called when a widget has been dismissed
typedef void OnDismissedCallback(
    int dismissedItem, DismissDirection direction);

/// Widget that animates scanning through a list of other widgets, like
/// the iOS Cover Flow animation.
class CoverFlow extends StatefulWidget {

  /// Called to build a widget that will be animated to loop through.
  final IndexedWidgetBuilder itemBuilder;

  /// Called when an item has been dismissed.
  final OnDismissedCallback dismissedCallback;

  /// The fraction of the
  /// [viewport](https://docs.flutter.io/flutter/widgets/Viewport-class.html)
  /// that the animated items should cover.
  final double viewportFraction;

  /// The height in pixels of the largest possible size an animated item will be.
  final int height;

  /// The width in pixels of the largest possible size an animated item will be.
  final int width;

  /// If true, widgets in the list can be
  /// [dismissed](https://docs.flutter.io/flutter/widgets/Dismissible-class.html).
  /// If this is true, dismissedCallback must be specified to clean up any
  /// state that your itemBuilder, otherwise, you will likely get errors thrown about.
  final bool dismissibleItems;

  /// The number of items in this coverflow list. If specified, the CoverFlow
  /// view is a finite list that scrolls only to the last list. If this value is
  /// *not* specified, then CoverFlow is an infinite list that rebuilds the
  /// cards one the user scrolls past the last one.
  final int itemCount;

  /// The index of the first item to show. If specified, the CoverFlow will
  /// initially display the item at this index.
  final int startIndex;

  const CoverFlow({@required this.itemBuilder, this.dismissibleItems: true,
    this.dismissedCallback, this.viewportFraction: .85, this.height: 525,
    this.width: 700, this.itemCount: null, this.startIndex: null})
      : assert(itemBuilder != null);

  @override
  _CoverFlowState createState() => new _CoverFlowState();
}

class _CoverFlowState extends State<CoverFlow> {
  PageController controller;
  int currentPage;
  bool _pageHasChanged = false;

  @override
  initState() {
    super.initState();
    currentPage = widget.startIndex ?? 0;
    controller = new PageController(
      viewportFraction: widget.viewportFraction,
      initialPage: currentPage,
    );
  }

  @override
  dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new PageView.builder(
        onPageChanged: (value) {
          setState(() {
            _pageHasChanged = true;
            currentPage = value;
          });
        },
        controller: controller,
        itemCount: widget.itemCount,
        itemBuilder: (context, index) => builder(index));
  }

  Widget builder(int index) {
    return new AnimatedBuilder(
        animation: controller,
        builder: (context, Widget child) {
          double result = _pageHasChanged ? controller.page : currentPage * 1.0;
          double value = result - index;

          value = (1 - (value.abs() * .5)).clamp(0.0, 1.0);

          var actualWidget = new Center(
            child: new SizedBox(
              height: Curves.easeOut.transform(value) * widget.height,
              width: Curves.easeOut.transform(value) * widget.width,
              child: child,
            ),
          );
          if (!widget.dismissibleItems) return actualWidget;

          return new Dismissible(
            key: ObjectKey(child),
            direction: DismissDirection.vertical,
            child: actualWidget,
            onDismissed: (direction) {
              setState(() {
                widget.dismissedCallback(index, direction);
                controller.animateToPage(currentPage,
                    duration: new Duration(seconds: 2), curve: Curves.easeOut);
              });
            },
          );
        },
        child: widget.itemBuilder(context, index));
  }
}
