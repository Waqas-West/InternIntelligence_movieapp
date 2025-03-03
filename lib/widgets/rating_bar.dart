import 'package:flutter/material.dart';

class RatingBarWidget extends StatefulWidget {
  final double initialRating;
  final ValueChanged<double> onRatingUpdate;

  const RatingBarWidget({
    Key? key,
    required this.initialRating,
    required this.onRatingUpdate,
  }) : super(key: key);

  @override
  _RatingBarWidgetState createState() => _RatingBarWidgetState();
}

class _RatingBarWidgetState extends State<RatingBarWidget> {
  late double _currentRating;

  @override
  void initState() {
    super.initState();
    _currentRating = widget.initialRating;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              _currentRating = index + 1.0;
            });
            widget.onRatingUpdate(_currentRating);
          },
          child: Icon(
            index < _currentRating ? Icons.star : Icons.star_border,
            color: Colors.amber,
            size: 30,
          ),
        );
      }),
    );
  }
}
