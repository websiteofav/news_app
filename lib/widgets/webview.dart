import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:newzzy/utils/colors.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CommonWebview extends StatefulWidget {
  final String? articleUrl;

  const CommonWebview({Key? key, this.articleUrl}) : super(key: key);

  @override
  State<CommonWebview> createState() => _CommonWebviewState();
}

class _CommonWebviewState extends State<CommonWebview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(55),
        child: AppBar(
          backgroundColor: appBarColor,
          title: Text(
            'News in detail',
            style: TextStyle(
                color: white, fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: WebView(
        initialUrl: widget.articleUrl,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
