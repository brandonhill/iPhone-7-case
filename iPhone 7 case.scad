/******************************************************************************
 * iPhone 7 case (basic)
 */

include <../BH-Lib/all.scad>;
include <_conf.scad>;

module iphone_7(offset = 0) {
	hull()
	reflect()
	translate([DIM[0] / 2 - CORNER_RAD, DIM[1] / 2 - CORNER_RAD, 0])
	torus_true(CORNER_RAD - DIM[2] / 2, DIM[2] / 2 + offset);
}

module iphone_7_case() {

	difference() {

		iphone_7(THICKNESS + TOLERANCE);

		iphone_7(TOLERANCE);

		// back cutouts
		translate([0, 0, -(DIM[2] / 2 + TOLERANCE)]) {

			// cam/led
			scale([1, -1])
			translate([DIM[0] / 2, DIM[1] / 2, -THICKNESS / 2])
			hull() {
				translate(-CAM_INSET)
				cylinder(h = THICKNESS + 0.2, r1 = CAM_HOLE_RAD + THICKNESS * 0, // tweak to keep away from edge
					r2 = CAM_HOLE_RAD, center = true);

				translate(-LED_INSET)
				cylinder(h = THICKNESS + 0.2, r1 = LED_HOLE_RAD + THICKNESS, r2 = LED_HOLE_RAD, center = true);
			}
		}

		// side cutouts
		translate([DIM[0] / 2 - POWER_BTN_INSET, 0]) {

			// volume
			translate([0, DIM[1] / 2 - DIM[2] / 2, 0])
			rotate([-90, 0])
			linear_extrude(DIM[2], convexity = 2)
			smooth_acute(DIM[2] / 2)
			translate() {
				offset(r = TOLERANCE)
				square([VOLUME_BTN_AREA + DIM[2], DIM[2]], true);

				translate([0, -(DIM[2] + THICKNESS)])
				square([VOLUME_BTN_AREA + DIM[2] * 4, DIM[2]], true);
			}

			// power
			translate([0, -(DIM[1] / 2 - DIM[2] / 2), 0])
			rotate([90, 0])
			linear_extrude(DIM[2], convexity = 2)
			smooth_acute(DIM[2] / 2)
			translate() {
				offset(r = TOLERANCE)
				square([POWER_BTN_AREA + DIM[2], DIM[2]], true);

				translate([0, (DIM[2] + THICKNESS)])
				square([POWER_BTN_AREA + DIM[2] * 4, DIM[2]], true);
			}
		}

		// bottom
		translate([-(DIM[0] / 2 - DIM[2] / 2), 0])
		rotate([0, -90])
		linear_extrude(DIM[2], convexity = 2)
		smooth_acute(DIM[2] / 2)
		translate() {
			offset(r = TOLERANCE)
			square([DIM[2], SPEAKER_AREA + DIM[2] / 2], true);

			translate([(DIM[2] + THICKNESS), 0])
			square([DIM[2], SPEAKER_AREA + DIM[2]], true);
		}

		// glass
		translate([0, 0, DIM[2] / 2 + TOLERANCE])
		hull()
		reflect()
		translate([DIM[0] / 2 - GLASS_INSET - GLASS_RAD, DIM[1] / 2 - GLASS_INSET - GLASS_RAD])
		cylinder(h = THICKNESS * 2 + 0.2, r1 = GLASS_RAD - THICKNESS, r2 = GLASS_RAD + THICKNESS / 2, center = true);
	}
}

// $fs = 0.1;

*
%
iphone_7();

iphone_7_case();
