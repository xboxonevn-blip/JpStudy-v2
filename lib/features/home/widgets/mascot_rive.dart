import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/language_provider.dart';
import '../../../../core/app_language.dart';

class MascotRive extends StatefulWidget {
  final Offset nodePos;
  final VoidCallback? onTap;

  const MascotRive({super.key, required this.nodePos, this.onTap});

  @override
  State<MascotRive> createState() => MascotRiveState();
}

class MascotRiveState extends State<MascotRive>
    with SingleTickerProviderStateMixin {
  late AnimationController _jumpController;
  // SMIInput<bool>? _successTrigger;
  // SMIInput<bool>? _failTrigger;
  // SMIInput<bool>? _hoverInput;
  // StateMachineController? _controller;

  @override
  void initState() {
    super.initState();
    _jumpController = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _jumpController.dispose();
    super.dispose();
  }

  void playSuccess() {
    // _successTrigger?.value = true;
    _jumpController.forward(from: 0); // Trigger Code-Driven Animation
  }

  void playFail() {
    // _failTrigger?.value = true;
  }

  void setHover(bool isHovering) {
    // _hoverInput?.value = isHovering;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isRightSide = widget.nodePos.dx > width / 2;

    // Mascot Position
    final mascotX = isRightSide
        ? widget.nodePos.dx - 130
        : widget.nodePos.dx + 60;
    final mascotY = widget.nodePos.dy - 30;

    return Positioned(
      left: mascotX,
      top: mascotY,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          SizedBox(
            width: 120,
            height: 120,
            child: GestureDetector(
              onTap: () {
                playSuccess();
                widget.onTap?.call();
              },
              // FALLBACK: Using Image because Rive package imports are failing in analysis.
              // We apply flutter_animate here to replicate the "Alive" feel.
              child:
                  Image.asset(
                        'assets/images/mascot_fox_transparent.png',
                        fit: BoxFit.contain,
                      )
                      // Idle Loop (Organic Breathing + Floating)
                      .animate(onPlay: (c) => c.repeat(reverse: true))
                      .moveY(
                        begin: 0,
                        end: -4,
                        duration: 1800.ms,
                        curve: Curves.easeInOutSine,
                      ) // Gentle Float
                      .scaleXY(
                        begin: 1.0,
                        end: 1.02,
                        duration: 2400.ms,
                        curve: Curves.easeInOutSine,
                      ) // Breathing
                      .rotate(
                        begin: -0.02,
                        end: 0.02,
                        duration: 3200.ms,
                        curve: Curves.easeInOutSine,
                      ) // Subtle Sway
                      // Interactive Jump (Connected to Controller)
                      .animate(controller: _jumpController, autoPlay: false)
                      .scaleXY(
                        begin: 1.0,
                        end: 0.9,
                        duration: 100.ms,
                        curve: Curves.easeOut,
                      ) // Anticipation
                      .then()
                      .moveY(
                        begin: 0,
                        end: -25,
                        duration: 300.ms,
                        curve: Curves.easeOut,
                      ) // Jump
                      .scaleXY(
                        begin: 0.9,
                        end: 1.1,
                        duration: 300.ms,
                      ) // Stretch
                      .then()
                      .moveY(
                        begin: -25,
                        end: 0,
                        duration: 400.ms,
                        curve: Curves.bounceOut,
                      ) // Land
                      .scaleXY(
                        begin: 1.1,
                        end: 1.0,
                        duration: 200.ms,
                      ), // Recover
              /*
              child: RiveAnimation.asset(
                'assets/mascot.riv',
                stateMachines: const ['MascotSM'],
                fit: BoxFit.contain,
                onInit: (artboard) {
                  // Controller logic...
                },
              ),
              */
            ),
          ),
          // Speech Bubble
          Positioned(
            bottom: 130, // Clear the face (increased from 110)
            left: isRightSide ? -20 : 0,
            right: isRightSide ? 0 : -20,
            child: _MascotSpeechBubble(isRightSide: isRightSide),
          ),
        ],
      ),
    );
  }
}

// ... (MascotRive imports)

class _MascotSpeechBubble extends ConsumerStatefulWidget {
  final bool isRightSide;
  const _MascotSpeechBubble({required this.isRightSide});

  @override
  ConsumerState<_MascotSpeechBubble> createState() =>
      _MascotSpeechBubbleState();
}

class _MascotSpeechBubbleState extends ConsumerState<_MascotSpeechBubble> {
  int _index = 0;
  // Removed hardcoded _messages list

  @override
  void initState() {
    super.initState();
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 5));
      if (mounted) {
        final messages = ref.read(appLanguageProvider).mascotEncouragement;
        setState(() {
          _index = (_index + 1) % messages.length;
        });
      }
      return mounted;
    });
  }

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(appLanguageProvider);
    final messages = language.mascotEncouragement;
    // Safety check for index out of bounds if language changes
    final safeIndex = _index % messages.length;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        transitionBuilder: (child, anim) =>
            FadeTransition(opacity: anim, child: child),
        child: Text(
          messages[safeIndex],
          key: ValueKey(safeIndex),
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1F2937),
            fontFamily: 'Outfit',
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
