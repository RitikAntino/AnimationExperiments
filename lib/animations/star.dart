import 'dart:math';
import 'package:flutter/material.dart';

class NinjaStars extends StatefulWidget {
  const NinjaStars({super.key});

  @override
  NinjaStarsState createState() => NinjaStarsState();
}

final List<StarData> stars = [];
int index = 0;

class StarData {
  final Offset offset;
  final Key key;
  StarData({required this.offset, required this.key});
}

class NinjaStarsState extends State<NinjaStars> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: GestureDetector(
            onTapDown: (TapDownDetails details) {
              index = ++index;
              setState(() {
                stars.add(
                  StarData(
                    offset: details.localPosition,
                    key: Key(index.toString()),
                  ),
                );
              });
            },
            child: Stack(
              children: [
                Container(color: Colors.white),
                ...stars.map((star) {
                  return Positioned(
                    key: star.key,
                    left: star.offset.dx,
                    top: star.offset.dy,
                    child: NinjaStar(key: star.key),
                  );
                }).toList(),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  if (multiplier != 5) setState(() => multiplier += 1);
                },
                child: const Icon(
                  Icons.add,
                  size: 40,
                ),
              ),
              const SizedBox(width: 20),
              Text(
                "Distance: $multiplier",
                textScaleFactor: 2,
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  if (multiplier != 1) setState(() => multiplier -= 1);
                },
                child: const Icon(
                  Icons.remove,
                  size: 40,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

int multiplier = 1;

class NinjaStar extends StatefulWidget {
  const NinjaStar({super.key});

  @override
  NinjaStarState createState() => NinjaStarState();
}

class NinjaStarState extends State<NinjaStar>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  late Animation<Offset> _animation;
  late Animation<double> _opacity;
  late final AnimationController movementControl = AnimationController(
    duration: Duration(seconds: multiplier),
    vsync: this,
  );
  late final AnimationController rotationControl =
      AnimationController(vsync: this, duration: const Duration(seconds: 1))
        ..repeat();

  late final AnimationController opacityControl = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  );
  late final Color starColor;
  @override
  void initState() {
    super.initState();
    starColor = randomColor();
    _opacity = Tween<double>(
      begin: 1,
      end: 0,
    ).animate(opacityControl);
    _animation = Tween<Offset>(
      begin: const Offset(-0.5, 0),
      end: Offset(-0.5, (-3.5 * multiplier).toDouble()),
    ).animate(movementControl);
    movementControl.forward();
    movementControl.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        removeStar();
      }
    });
  }

  removeStar() {
    movementControl.dispose();
    rotationControl.dispose();
    opacityControl.forward();
    opacityControl.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        opacityControl.dispose();
        stars.removeWhere((element) => element.key == widget.key);
        setState(() => stars);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SlideTransition(
      position: _animation,
      child: RotationTransition(
        turns: rotationControl,
        child: FadeTransition(
          opacity: _opacity,
          child: Icon(
            Icons.star,
            color: starColor,
            size: 50,
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

Color randomColor() {
  Random rand = Random();
  return Color.fromRGBO(
    rand.nextInt(255),
    rand.nextInt(255),
    rand.nextInt(255),
    1,
  );
}
