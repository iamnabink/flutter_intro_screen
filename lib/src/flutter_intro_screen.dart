library introduction_screen;

import 'dart:async';
import 'dart:math';

import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intro_screen/src/model/page_view_model.dart';
import 'package:flutter_intro_screen/src/ui/intro_button.dart';
import 'package:flutter_intro_screen/src/ui/intro_page.dart';

class IntroductionScreen extends StatefulWidget {
  /// All pages of the onboarding
  final List<PageViewModel> pages;

  /// Callback when Done button is pressed
  final VoidCallback onDone;

  /// Done button
  final Widget done;

  /// Callback when Skip button is pressed
  final VoidCallback? onSkip;

  /// Callback when page change
  final ValueChanged<int>? onChange;

  /// Skip button
  final Widget skip;

  /// Next button
  final Widget next;

  /// Is the Skip button should be display
  ///
  /// @Default `false`
  final bool showSkipButton;

  /// Is the Next button should be display
  ///
  /// @Default `true`
  final bool showNextButton;

  /// Is the progress indicator should be display
  ///
  /// @Default `true`
  final bool isProgress;

  /// Enable or not onTap feature on progress indicator
  ///
  /// @Default `true`
  final bool isProgressTap;

  /// Is the user is allow to change page
  ///
  /// @Default `false`
  final bool freeze;

  /// Global background color (only visible when a page has a transparent background color)
  final Color? globalBackgroundColor;

  /// Dots decorator to custom dots color, size and spacing
  final DotsDecorator dotsDecorator;

  /// Animation duration in millisecondes
  ///
  /// @Default `350`
  final int animationDuration;

  /// Index of the initial page
  ///
  /// @Default `0`
  final int initialPage;

  /// Flex ratio of the skip button
  ///
  /// @Default `1`
  final EdgeInsets skipPadding;

  /// Flex ratio of the progress indicator
  ///
  /// @Default `1`
  final EdgeInsets dotsPadding;

  /// Flex ratio of the next/done button
  ///
  /// @Default `1`
  final EdgeInsets nextPadding;

  /// Type of animation between pages
  ///
  /// @Default `Curves.easeIn`
  final Curve curve;

  const IntroductionScreen({
    Key? key,
    required this.pages,
    required this.onDone,
    required this.done,
    this.onSkip,
    this.onChange,
    required this.skip,
    required this.next,
    this.showSkipButton = false,
    this.showNextButton = true,
    this.isProgress = true,
    this.isProgressTap = true,
    this.freeze = false,
    this.globalBackgroundColor,
    this.dotsDecorator = const DotsDecorator(),
    this.animationDuration = 350,
    this.initialPage = 0,
    this.skipPadding = const EdgeInsets.all(4),
    this.dotsPadding = const EdgeInsets.all(4),
    this.nextPadding = const EdgeInsets.all(4),
    this.curve = Curves.easeIn,
  })  : assert(
          pages.length > 0,
          "You provide at least one page on introduction screen !",
        ),
        assert(showSkipButton || !showSkipButton),
        assert(initialPage >= 0),
        super(key: key);

  @override
  IntroductionScreenState createState() => IntroductionScreenState();
}

class IntroductionScreenState extends State<IntroductionScreen> {
  late PageController _pageController;
  double _currentPage = 0.0;
  bool _isSkipPressed = false;
  bool _isScrolling = false;

  PageController get controller => _pageController;

  @override
  void initState() {
    super.initState();
    final int initialPage = min(widget.initialPage, widget.pages.length - 1);
    _currentPage = initialPage.toDouble();
    _pageController = PageController(initialPage: initialPage);
  }

  void next() {
    animateScroll(min(_currentPage.round() + 1, widget.pages.length - 1));
  }

  void _onSkip() {
    if (widget.onSkip != null) return widget.onSkip!();
    skipToEnd();
  }

  Future<void> skipToEnd() async {
    setState(() => _isSkipPressed = true);
    await animateScroll(widget.pages.length - 1);
    if (mounted) {
      setState(() => _isSkipPressed = false);
    }
  }

  Future<void> animateScroll(int page) async {
    setState(() => _isScrolling = true);
    await _pageController.animateToPage(
      page,
      duration: Duration(milliseconds: widget.animationDuration),
      curve: widget.curve,
    );
    if (mounted) {
      setState(() => _isScrolling = false);
    }
  }

  bool _onScroll(ScrollNotification notification) {
    final metrics = notification.metrics;
    if (metrics is PageMetrics) {
      setState(() => _currentPage = metrics.page ?? 0.0);
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unnecessary_parenthesis
    final isLastPage = (_currentPage.round() == widget.pages.length - 1);
    // ignore: unnecessary_parenthesis
    final bool isSkipBtn =
        !_isSkipPressed && !isLastPage && widget.showSkipButton;

    final skipBtn = IntroButton(
      onPressed: isSkipBtn ? _onSkip : null,
      child: widget.skip,
    );

    final nextBtn = IntroButton(
      onPressed: widget.showNextButton && !_isScrolling ? next : null,
      child: widget.next,
    );

    final doneBtn = IntroButton(
      onPressed: widget.onDone,
      child: widget.done,
    );

    return Scaffold(
      backgroundColor: widget.globalBackgroundColor,
      body: Stack(
        children: [
          NotificationListener<ScrollNotification>(
            onNotification: _onScroll,
            child: PageView(
              controller: _pageController,
              physics: widget.freeze
                  ? const NeverScrollableScrollPhysics()
                  : const BouncingScrollPhysics(),
              onPageChanged: widget.onChange,
              children: widget.pages.map((p) => IntroPage(page: p)).toList(),
            ),
          ),
          Stack(
            children: [
              Container(
                padding: widget.skipPadding,
                alignment: Alignment.bottomLeft,
                child:
                    isSkipBtn ? skipBtn : Opacity(opacity: 0.0, child: skipBtn),
              ),
              Container(
                padding: widget.dotsPadding,
                alignment: Alignment.bottomCenter,
                child: widget.isProgress
                    ? DotsIndicator(
                        dotsCount: widget.pages.length,
                        position: _currentPage,
                        decorator: widget.dotsDecorator,
                        onTap: widget.isProgressTap && !widget.freeze
                            ? (pos) => animateScroll(pos.toInt())
                            : null,
                      )
                    : const SizedBox(),
              ),
              Container(
                padding: widget.nextPadding,
                alignment: Alignment.bottomRight,
                child: isLastPage
                    ? doneBtn
                    : widget.showNextButton
                        ? nextBtn
                        : Opacity(opacity: 0.0, child: nextBtn),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
