import 'package:flutter/material.dart';

class CaesarCipherWidget extends StatefulWidget {
  CaesarCipherWidget({super.key, required this.shift});

  late int shift;

  @override
  State<CaesarCipherWidget> createState() => _CaesarCipherWidgetState();
}

class _CaesarCipherWidgetState extends State<CaesarCipherWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Shift Amount:', style: TextStyle(fontWeight: FontWeight.bold)),
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.remove),
              onPressed: () {
                if (widget.shift > 1) setState(() => widget.shift--);
              },
            ),
            Text('${widget.shift}'),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                if (widget.shift < 25) setState(() => widget.shift++);
              },
            ),
          ],
        ),
      ],
    );
  }
}
