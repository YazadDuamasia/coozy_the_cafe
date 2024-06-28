import 'dart:async';

import 'package:coozy_the_cafe/utlis/utlis.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostTimeTextWidget extends StatefulWidget {
  final String creationDate;
  final String localizedCode;

  const PostTimeTextWidget(
      {super.key, required this.creationDate, required this.localizedCode});

  @override
  _PostTimeTextWidgetState createState() => _PostTimeTextWidgetState();
}

class _PostTimeTextWidgetState extends State<PostTimeTextWidget> {
  late StreamController<String> _postTimeController;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _postTimeController = StreamController<String>.broadcast();
    _updatePostTime(); // Initial update
    int secondsUntilNextMinute = 60 - DateTime.now().toLocal().second;

    _timer = Timer(Duration(seconds: secondsUntilNextMinute), () {
      Constants.debugLog(PostTimeTextWidget, "_timer:First Initial Trigger.");
      Constants.debugLog(
          PostTimeTextWidget, "_timer triggered at: ${DateTime.now()}");
      _timer = Timer.periodic(const Duration(seconds: 60), (timer) {
        Constants.debugLog(PostTimeTextWidget, "_timer:Started");
        Constants.debugLog(
            PostTimeTextWidget, "_timer triggered at: ${DateTime.now()}");
        _updatePostTime();
      });
    });
  }

  @override
  void didUpdateWidget(covariant PostTimeTextWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Check if the widget properties have changed and update accordingly
    if (widget.creationDate != oldWidget.creationDate ||
        widget.localizedCode != oldWidget.localizedCode) {
      _updatePostTime();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Move the dependency-related logic here if needed
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
      stream: _postTimeController.stream,
      initialData: Constants.getTextTimeAgo(
          dateStr: widget.creationDate,
          localizedCode: widget.localizedCode,
          allowFromNow: false),
      builder: (context, snapshot) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Text(snapshot.data ?? ""),
            ),
          ],
        );
      },
    );
  }

  void _updatePostTime() {
    Constants.debugLog(
        PostTimeTextWidget, "localizedCode:${widget.localizedCode}");
    if (widget.creationDate.isNotEmpty) {
      // String date =
      //     "${DateUtil.localFormat(widget.creationDate ?? "", DateUtil.DATE_FORMAT4)}";
      DateTime? dateTime = DateTime.tryParse(widget.creationDate)?.toLocal();
      DateTime? now = DateTime.now().toLocal();
      DateTime? creationDate =
          DateTime.tryParse(widget.creationDate)?.toLocal();
      Duration? duration = now.difference(creationDate!);
      DateTime? res = now.subtract(duration).toLocal();

      _postTimeController
          .add(timeago.format(res, locale: widget.localizedCode));
    } else {
      _postTimeController.add("");
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    _postTimeController.close();
    super.dispose();
  }
}
