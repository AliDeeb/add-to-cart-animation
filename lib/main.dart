import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'add_to_cart_button.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await vg.loadPicture(const SvgAssetLoader("assets/cart_icon.svg"), null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Add To Cart Animation',
      home: Scaffold(
        body: Center(
          child: AddToCartButton(
            duration: const Duration(milliseconds: 2500),
            width: MediaQuery.of(context).size.width * 0.6,
            height: 70,
            onEnd: () {},
          ),
        ),
      ),
    );
  }
}
