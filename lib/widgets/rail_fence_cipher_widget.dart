import 'package:flutter/material.dart';

class RailFenceCipherWidget extends StatefulWidget {
  RailFenceCipherWidget({super.key, required this.rails});

  late int rails;


  @override
  State<RailFenceCipherWidget> createState() => _RailFenceCipherWidgetState();
}

class _RailFenceCipherWidgetState extends State<RailFenceCipherWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Number of Rails:', style: TextStyle(fontWeight: FontWeight.bold)),
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.remove),
              onPressed: () {
                if (widget.rails > 2) setState(() => widget.rails--);
              },
            ),
            Text('${widget.rails}'),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                if (widget.rails < 10) setState(() => widget.rails++);
              },
            ),
          ],
        ),
      ],
    );
  }
}
