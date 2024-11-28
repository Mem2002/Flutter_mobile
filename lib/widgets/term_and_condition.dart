// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// class TermAndCondition extends StatefulWidget {
//   const TermAndCondition({super.key});

//   @override
//   State<TermAndCondition> createState() => _TermAndConditionState();
// }

// class _TermAndConditionState extends State<TermAndCondition> {
//   WebViewController controller = WebViewController()
//     ..setJavaScriptMode(JavaScriptMode.unrestricted)
//     ..setBackgroundColor(const Color(0x00000000))
//     ..setNavigationDelegate(
//       NavigationDelegate(
//         onProgress: (int progress) {
//           // Update loading bar.
//         },
//         onPageStarted: (String url) {},
//         onPageFinished: (String url) {},
//         onWebResourceError: (WebResourceError error) {},
//         onNavigationRequest: (NavigationRequest request) {
//           if (request.url ==
//               'https://docs.google.com/document/d/e/2PACX-1vRfZ2iHPLLDAdHFG6SJPB360klqBvM1rxpSXyeYyjc-A1uv2BNJApenTFHhazyaSbzr6356sSWR-g08/pub') {
//             return NavigationDecision.prevent;
//           }
//           return NavigationDecision.navigate;
//         },
//       ),
//     )
//     ..loadRequest(Uri.parse(
//         'https://docs.google.com/document/d/e/2PACX-1vRfZ2iHPLLDAdHFG6SJPB360klqBvM1rxpSXyeYyjc-A1uv2BNJApenTFHhazyaSbzr6356sSWR-g08/pub'));

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.transparent,
//       body: Column(
//         children: [
//           Expanded(
//             child: WebViewWidget(controller: controller),
//           ),
//           Container(
//             margin: const EdgeInsets.all(12),
//             height: 48,
//             alignment: Alignment.center,
//             child: ElevatedButton(
//               onPressed: () => Navigator.of(context).pop(true),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.deepPurple[600],
//               ),
//               child: const Text(
//                 'Đồng ý',
//                 style: TextStyle(
//                   fontSize: 15,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
