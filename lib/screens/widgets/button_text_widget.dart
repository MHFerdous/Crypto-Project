import 'package:flutter/material.dart';

class ButtonTextWidget extends StatelessWidget {
  const ButtonTextWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 24),
        Divider(),
        Text('🍀 Secure your message with style!'),
      ],
    );
  }
}
