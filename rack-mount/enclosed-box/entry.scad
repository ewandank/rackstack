include <../../rack/sharedVariables.scad>
include <../common.scad>
include <./helper.scad>

use <./sideRail.scad>
use <./frontBoxHolder.scad>

/*
  Enclosed box mounting system:
  Helper file to use semi-enclosed side rails and a front plate to mount a box.
  This system does not require any mounting holes on the enclosed box.

  !!! Please also make sure that the correct rack frame preset is set in rackFrame.scad !!!
*/
module enclosedBoxSystem (

/** begin default config */

// Does not affect any part dimensions. Set this to true to visualize how a box would be mounted.
visualize = false,
zOrientation = "middle", // ["middle" | "bottom"]
// recessSideRail = true,

// boxWidth = 170,
// boxHeight = 27,
// boxDepth = 100,

railDefaultThickness = 1.5,
railSideThickness = 3,

frontPlateThickness = 3,
frontPlateCutoutYSpace = 3,
frontPlateCutoutXSpace = 5,
/** end default config */


/** begin NBN HFC (Arris CM8200) */
// boxWidth = 132,
// boxHeight = 44,
// boxDepth = 132,
// recessSideRail = false,
/** end NBN HFC (Arris CM8200) */

/** begin HP EliteDesk 800 G2 Mini */
// boxWidth = 178,
// boxHeight = 34,
// boxDepth = 175,
// recessSideRail = true,
/** end HP EliteDesk 800 G2 Mini */


/** begin HP EliteDesk 800 G5 Mini */
// boxWidth = 177,
// boxHeight = 34,
// boxDepth = 175,
// recessSideRail = true,
/** end HP EliteDesk 800 G5 Mini */

/** Begin Chinese Router (I need to validate with calipers) */
boxWidth = 140,
boxHeight = 40,
boxDepth = 130,
recessSideRail = false,
/** end Chinese Router */






) {
  leftRailTrans = identity;
  rightRailTrans = visualize
    ? translate(v = [boxWidth, 0, 0])*mirror(v = [1, 0, 0])
    : translate(v = [sideRailBaseWidth*2, 0, 0])*mirror(v = [1, 0, 0]);

  u = findU(boxHeight, railDefaultThickness);
  railBottomThickness = railBottomThickness(u, boxHeight, railDefaultThickness, zOrientation);
  frontBoxHolderTrans = visualize
    ? translate(v = [railSideThickness-(railSupportsDx-boxWidth)/2, 0, sideRailLowerMountPointToBottom-
      railBottomThickness])*mirror(v = [0, 1, 0])*rotate(a = [90, 0, 0])
    : mirror(v = [0, 1, 0])*translate(v = [0, uDiff, frontPlateThickness-railBottomThickness]);

  if (visualize) {
    %cube(size = [boxWidth, boxDepth, boxHeight]);
  }

  multmatrix(leftRailTrans)
    sideSupportRailBase(top = true, recess = recessSideRail, defaultThickness = railDefaultThickness, supportedZ =
    boxHeight, supportedY = boxDepth, supportedX = boxWidth, zOrientation = zOrientation, railSideThickness =
    railSideThickness);

  multmatrix(rightRailTrans)
    sideSupportRailBase(top = true, recess = recessSideRail, defaultThickness = railDefaultThickness, supportedZ =
    boxHeight, supportedY = boxDepth, supportedX = boxWidth, zOrientation = zOrientation, railSideThickness =
    railSideThickness);

  multmatrix(frontBoxHolderTrans)
    frontBoxHolder(
    cutoutOffsetX = (rackMountScrewWidth-(boxWidth-2*frontPlateCutoutXSpace))/2, cutoutOffsetY = railBottomThickness+
      frontPlateCutoutYSpace,
    cutoutX = boxWidth-2*frontPlateCutoutXSpace, cutoutY = boxHeight-2*frontPlateCutoutYSpace,
    zOrientation = zOrientation, supportedZ = boxHeight, supportWidth = max(10, boxWidth-(sideRailBaseWidth+10)),
    supportRailDefaultThickness = railDefaultThickness, plateThickness = frontPlateThickness
    );
}

enclosedBoxSystem();