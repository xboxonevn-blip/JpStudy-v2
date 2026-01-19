enum SwipeAction {
  know,           // Right swipe - user knows this term
  needPractice,   // Left swipe - needs more practice
  star,           // Up swipe - bookmark/favorite
  skip,           // Down swipe - skip for now
}

enum SwipeDirection {
  left,
  right,
  up,
  down,
}

extension SwipeActionExtension on SwipeAction {
  String get label {
    switch (this) {
      case SwipeAction.know:
        return 'Know it!';
      case SwipeAction.needPractice:
        return 'Need Practice';
      case SwipeAction.star:
        return 'Star';
      case SwipeAction.skip:
        return 'Skip';
    }
  }

  String get emoji {
    switch (this) {
      case SwipeAction.know:
        return '✅';
      case SwipeAction.needPractice:
        return '🔄';
      case SwipeAction.star:
        return '⭐';
      case SwipeAction.skip:
        return '⏭️';
    }
  }
}
