// iPhone 7
// https://img-new.cgtrader.com/items/649605/c9446c80b3/iphone-7-original-dimensions-3d-model-obj-stl-ige-igs-iges-stp.png

PRINT_LAYER = 0.2;
PRINT_NOZZLE = 0.5;


// LAST PRINTED WITH:
TOLERANCE = PRINT_LAYER; // close fit (case)
TOLERANCE_XY = 0.5; // clearance fit (moving parts)
// TOLERANCE_Z = TOLERANCE;

// SHOULD BE:
// TOLERANCE ~ 0.3;

DIM = [138.29, 67.12, 7.1];

BTN_HOLE_RAD = DIM[2] / 2;
BTN_HOLE_RAD2 = BTN_HOLE_RAD;// * 2; // meh

CAM_DEPTH = 0.93;
CAM_HOLE_RAD = 12.14 / 2;
CAM_INSET = [10.17, 10.37];

CORNER_RAD = 9.08;

GLASS_INSET = (DIM[0] - 134.97) / 2; // only need one dim
GLASS_RAD = CORNER_RAD - GLASS_INSET;

LED_HOLE_RAD = 9.7 / 2;
LED_INSET = [10.17, 22.76];

POWER_BTN_INSET = 34.56;
POWER_BTN_AREA = 10.62;

SPEAKER_AREA = 46.76;

VOLUME_BTN_AREA = 34.92;

THICKNESS = PRINT_LAYER * 7;

echo(str("Camera protection = ", THICKNESS - CAM_DEPTH, "mm"));
