// iPhone 7 case - bumper (just the edges)

include <../BH-Lib/all.scad>;
include <_conf.scad>;
use <iPhone 7 case.scad>;

STRAP_WIDTH = 3;

module iphone_7_case_bumper() {

	a = atan((DIM[1] / 2 + THICKNESS - CORNER_RAD) / (DIM[0] / 2 + THICKNESS - CORNER_RAD));

	difference() {

		iphone_7_case();

		translate([0, 0, -(DIM[2] - TOLERANCE - THICKNESS - 0.2)])
		minkowski() {

			linear_extrude(0.2)
			smooth(CORNER_RAD - DIM[2])
			offset(r = -DIM[2])
			difference() {
				hull()
				reflect()
				translate([DIM[0] / 2 - CORNER_RAD, DIM[1] / 2 - CORNER_RAD, 0])
				circle(CORNER_RAD);

				scale([1, -1])
				translate([DIM[0] / 2, DIM[1] / 2, -THICKNESS / 2])
				hull() {
					translate(-CAM_INSET)
					circle(CAM_HOLE_RAD);

					translate(-LED_INSET)
					circle(LED_HOLE_RAD);
				}
			}

			cylinder(h = THICKNESS, r1 = THICKNESS, r2 = 0);
		}
	}
}

*
%
iphone_7();

iphone_7_case_bumper();
