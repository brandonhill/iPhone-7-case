/******************************************************************************
 * iPhone 7 case - minimal
 */

include <_conf.scad>;
use <iPhone 7 case.scad>;

module iphone_7_case_minimal(
		strap_width,
	) {

	a = atan((DIM[1] / 2 + THICKNESS - CORNER_RAD) / (DIM[0] / 2 + THICKNESS - CORNER_RAD));

	intersection() {

		iphone_7_case();

		union() {

			// cam/LED surround
			scale([1, -1])
			translate([DIM[0] / 2, DIM[1] / 2, -DIM[2] / 2])
			hull() {
				translate(-CAM_INSET)
				cylinder(h = DIM[2], r = CAM_HOLE_RAD + strap_width, center = true);

				translate(-LED_INSET)
				cylinder(h = DIM[2], r = LED_HOLE_RAD + strap_width, center = true);
			}

			// ends
			for (x = [-1, 1])
				scale([x, 1])
				translate([DIM[0] / 2, 0])
				cube([CORNER_RAD * 2, DIM[1] * 2, CORNER_RAD * 2], true);

			// straps
			for (y = [-1, 1])
				rotate([0, 0, a * y])
				cube([DIM[0], strap_width, DIM[2] * 2], true);
		}
	}
}

%
iphone_7();

iphone_7_case_minimal(strap_width = 10);
