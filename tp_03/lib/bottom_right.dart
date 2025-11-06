import 'package:flutter/widgets.dart';
import 'package:flutter/rendering.dart';

class BottomRight extends SingleChildRenderObjectWidget {
  const BottomRight({super.key, Widget? child}) : super(child: child);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderBottomRight();
  }
}

class RenderBottomRight extends RenderBox
    with RenderObjectWithChildMixin<RenderBox> {
  @override
  void performLayout() {
    if (child != null) {
      // 1) donner les contraintes maximales à l’enfant
      child!.layout(constraints.loosen(), parentUsesSize: true);
      // 2) déterminer la taille de ce RenderBox :
      //    ici on prend la taille max possible (contraintes) ou la taille enfant si plus petit
      final childSize = child!.size;
      final width = constraints.maxWidth.isFinite
          ? constraints.maxWidth
          : childSize.width;
      final height = constraints.maxHeight.isFinite
          ? constraints.maxHeight
          : childSize.height;
      size = Size(width, height);

      // 3) positionner l’enfant, via parentData
      final BoxParentData childParentData = child!.parentData as BoxParentData;
      childParentData.offset = Offset(
        width - childSize.width,
        height - childSize.height,
      );
    } else {
      // Aucun enfant : on prend taille min
      size = constraints.smallest;
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child != null) {
      final BoxParentData childParentData = child!.parentData as BoxParentData;
      context.paintChild(child!, offset + childParentData.offset);
    }
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    if (child != null) {
      final BoxParentData childParentData = child!.parentData as BoxParentData;
      return result.addWithPaintOffset(
        offset: childParentData.offset,
        position: position,
        hitTest: (BoxHitTestResult result2, Offset transformed) {
          return child!.hitTest(result2, position: transformed);
        },
      );
    }
    return false;
  }
}
