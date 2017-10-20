// iPhone 7 case w/stand

/*
TODO:
* tolerance of 1mm too much, so re-print arm/collar with dims + 0.5 (0.25 per joint) (adj. tol. as needed)
* make stand detent deeper/tighter
- make side grips
*/

include <_conf.scad>;
use <iPhone 7 case.scad>;

LANDSCAPE_ANGLE = 45;
// LIP_THICKNESS = printHeight(THICKNESS / 3);
LIP_THICKNESS = PRINT_LAYER * 2;
PORTRAIT_ANGLE = 70;
STAND_ELBOW_ANGLE = 80;
STAND_HOME_ANGLE = 53.5;
STAND_JOINT_POS = 35;
STAND_WIDTH = 10;

STAND_ARM_DETENT = 0.5;

detent_r = 1.5;
stand_hole_r = DIM[1] * 0.375;
// stand_hole_r = DIM[1] * 1/3;
stand_collar_r = stand_hole_r - 5;
stand_lip_r = stand_hole_r + 3;
stand_arm_elbow_len = max(STAND_JOINT_POS, stand_lip_r + STAND_WIDTH / 2);
stand_shoulder_angle = 90 - STAND_ELBOW_ANGLE;
stand_length = let(h = stand_arm_elbow_len + DIM[2] / 2 + TOLERANCE + THICKNESS / 2)
	DIM[0] / 2
	- sin(stand_shoulder_angle) * h
	- sin(90 - PORTRAIT_ANGLE) * cos(stand_shoulder_angle) * h
	;

module shape_arm_pivot() {
	square([stand_hole_r * 2 - TOLERANCE_XY * 2, THICKNESS], true);
}

module shape_arm_centre(inset = 0) {
	intersection() {
		circle_true(stand_collar_r);
		square([(stand_collar_r - STAND_ARM_DETENT - inset) * 2, stand_collar_r * 2], true);
	}
}

module shape_arm(middle = true) {

	// offset of pivot from centre of phone
	y = DIM[2] / 2 + TOLERANCE + THICKNESS / 2;

	// DEV - case profiles - to confirm position of cut offs
	translate([0, y]) {

		// landscape
		*#difference() {
			offset(r = TOLERANCE + THICKNESS)
			rounded_square([DIM[1], DIM[2]], DIM[2] / 2);

			offset(r = TOLERANCE)
			rounded_square([DIM[1], DIM[2]], DIM[2] / 2);
		}

		// portrait
		*#difference() {
			offset(r = TOLERANCE + THICKNESS)
			rounded_square([DIM[0], DIM[2]], DIM[2] / 2);

			offset(r = TOLERANCE)
			rounded_square([DIM[0], DIM[2]], DIM[2] / 2);
		}
	}

	difference() {
		smooth_acute(STAND_WIDTH * 0.2)
		difference() {
			union() {

				// upper
				hull() {
					circle(STAND_WIDTH / 2);

					rotate([0, 0, stand_shoulder_angle])
					translate([0, -stand_arm_elbow_len])
					circle(STAND_WIDTH / 2);
				}

				// forearm
				rotate([0, 0, stand_shoulder_angle])
				translate([0, -stand_arm_elbow_len])
				hull() {
					circle(STAND_WIDTH / 2);

					rotate([0, 0, STAND_ELBOW_ANGLE])
					translate([0, -stand_length, 0])
					rotate([0, 0, 30])
					circle(STAND_WIDTH / 2);
				}

				// if (middle)
				shape_arm_centre();
			}

			// cut off elbow
			translate([-(DIM[1] / 2 - DIM[2] / 2 - TOLERANCE), y])
			rotate([0, 0, 90 - LANDSCAPE_ANGLE])
			translate([-(DIM[0] / 2 + DIM[2] / 2 + TOLERANCE + THICKNESS), 0])
			square(DIM[0], true);

			// cut off foot
			translate([DIM[0] / 2 + TOLERANCE + THICKNESS, DIM[2] / 2])
			rotate([0, 0, -90 + PORTRAIT_ANGLE])
			translate([DIM[0] / 2, 0])
			square(DIM[0], true);
		}

		// cut off at centre
		translate([0, stand_hole_r])
		square(stand_hole_r * 2, true);
	}

	// pivot
	if (middle)
	shape_arm_pivot();
}

module pos_stand_arm() {
	translate([0, -cos(stand_shoulder_angle) * stand_arm_elbow_len])
	children();
}

module arm_detents(inset_length = 0, inset_y = 0) {

	l = 5;
	w = sin(45) * THICKNESS;

	outset = l * 2;

	translate([stand_length * 2/3, 0])
	pos_stand_arm()
	for (x = [-1, 1], y = [-1, 1])
		scale([x, y])
		translate([outset, STAND_WIDTH / 2 - inset_y])
		rotate([45, 0])
		cube([l - inset_length * 2, w, w], true);
}

module arm() {

	hole_r = stand_collar_r - STAND_WIDTH / 2;

	difference() {
		linear_extrude(THICKNESS, convexity = 2)
		shape_arm();

		// middle cutout
		translate([0, 0, -0.1])
		minkowski() {

			linear_extrude(0.001, convexity = 2)
			smooth_acute(THICKNESS)
			{
				difference() {
					circle(stand_collar_r * 0.5);

					translate([0, stand_collar_r + THICKNESS * 2, 0])
					square(stand_collar_r * 2, true);
				}

				difference() {
					circle(stand_collar_r - THICKNESS * 2);

					translate([0, -stand_collar_r + THICKNESS / 2, 0])
					square(stand_collar_r * 2, true);
				}
			}

			cylinder(h = THICKNESS + 0.2, r1 = THICKNESS, r2 = 0);
		}

		translate([0, 0, THICKNESS / 2])
		scale([1, 1, 0.75])
		arm_detents();//inset_y = TOLERANCE_XY);

		// slot (add flex for keeper detents)
		translate([stand_length * 2/3, 0, -0.1])
		pos_stand_arm()
		hull()
		for (x = [-1, 1])
			scale([x, 1])
			translate([stand_length * 1/3, 0])
			cylinder(h = THICKNESS + 0.2, r1 = THICKNESS * 1.5, r2 = THICKNESS / 2);
	}
}

module shape_collar_centre(inset = 0) {
	offset(r = TOLERANCE_XY)
	shape_arm_centre(inset);
}

module shape_collar() {
	difference() {
		rotate([0, 0, STAND_HOME_ANGLE])
		smooth(detent_r)
		difference() {

			circle(stand_lip_r);

			// cardinal detents
			for (i = [0 : 3])
				rotate([0, 0, 90 * i])
				translate([stand_lip_r, 0])
				circle_true(detent_r + TOLERANCE_XY);

			// home detent
			rotate([0, 0, STAND_HOME_ANGLE])
			translate([stand_lip_r, 0])
			circle(detent_r + TOLERANCE_XY);

			rotate([0, 0, -STAND_HOME_ANGLE])
			scale([1, -1])
			offset(r = TOLERANCE_XY)
			shape_arm(false);
		}

		shape_collar_centre();

		scale([1, -1]) {
			offset(r = TOLERANCE_XY)
			shape_arm(false);

			// offset(r = TOLERANCE * 2) // extra clearance for pivot
			offset(r = TOLERANCE_XY)
			shape_arm_pivot();
		}
	}
}

module collar() {
	difference() {
		linear_extrude(THICKNESS, convexity = 2)
		shape_collar();

		// create lip
		translate([0, 0, THICKNESS - LIP_THICKNESS])
		difference() {
			cylinder_true(h = THICKNESS, r = stand_lip_r + detent_r + 0.1);

			translate([0, 0, -0.1])
			cylinder(h = THICKNESS + 0.2, r = stand_hole_r);
		}

		// chamfer inner
		translate([0, 0, -0.1])
		minkowski() {

			linear_extrude(0.001)
			smooth(THICKNESS) {

				difference() {
					circle(stand_collar_r + TOLERANCE_XY);

					translate([0, stand_collar_r - THICKNESS * 3, 0])
					square(stand_collar_r * 2, true);
				}
			}

			cylinder(h = THICKNESS + 0.2, r1 = 0, r2 = THICKNESS);
		}
	}

	// hinge
	translate([0, 0, THICKNESS / 2])
	difference() {
		difference() {
			intersection() {
				scale([1, 1, 0.5])
				// rotate([0, 90])
				// capsule(h = (stand_hole_r + TOLERANCE) * 2, r = THICKNESS * 3, center = true);
				for(x = [-1, 1])
				scale([x, 1])
				translate([stand_collar_r + THICKNESS, 0, 0])
				sphere(THICKNESS * 3);

				translate([0, 0, -THICKNESS * 0.5])
				cylinder(h = THICKNESS * 3, r = stand_hole_r);
			}

			difference() {

				// stand arm detents
				w = (THICKNESS * 3 - THICKNESS - TOLERANCE * 2);

				linear_extrude(THICKNESS * 3 + 0.2, center = true, convexity = 2)
				smooth_acute(STAND_ARM_DETENT) {
					difference() {
						square([(stand_collar_r + STAND_ARM_DETENT) * 2, stand_collar_r * 2], true);

						for (x = [-1, 1], y = [-1, 1])
						scale([x, y])
						translate([stand_collar_r * 1.5 - STAND_ARM_DETENT - TOLERANCE, w / 2 + (THICKNESS + TOLERANCE_XY * 2) / 2])
						square([stand_collar_r, w], true);
					}
				}
			}
		}

		show_half(t = [0, -(THICKNESS + TOLERANCE_XY) / 2])
		linear_extrude(THICKNESS, center = true, convexity = 2) {
			shape_collar_centre();
			offset(r = TOLERANCE_XY)
			shape_arm_pivot();
		}
	}
}

module iphone_7_case_w_stand() {

	difference() {

		iphone_7_case();

		// back cutouts
		translate([0, 0, -(DIM[2] / 2 + TOLERANCE)]) {

			// collar (inner)
			*translate([0, 0, -THICKNESS / 2])
			cylinder_true(h = THICKNESS + 0.2, r = stand_hole_r + TOLERANCE_XY, center = true);

			translate([0, 0, -THICKNESS + LIP_THICKNESS])
			linear_extrude(THICKNESS)
			smooth_acute(detent_r)
			difference() {

				// lip (outer)
				circle_true(stand_lip_r + TOLERANCE_XY);

				// detent
				rotate([0, 0, -STAND_HOME_ANGLE])
				translate([stand_lip_r + TOLERANCE_XY, 0])
				circle_true(detent_r);
			}

			// arm hole
			translate([0, 0, -THICKNESS / 2])
			rotate([0, 0, STAND_HOME_ANGLE])
			linear_extrude(THICKNESS + 0.2, center = true, convexity = 4)
			smooth_acute(THICKNESS)
			offset(r = TOLERANCE_XY) {
				shape_arm(false);
				circle_true(stand_hole_r);
			}

			// access hole
			translate([0, 0, -THICKNESS / 2])
			rotate([0, 0, STAND_HOME_ANGLE])
			pos_stand_arm()
			translate([stand_length * 2/3, STAND_WIDTH / 2])
			cylinder(h = THICKNESS + 0.2, r1 = STAND_WIDTH / 2 + THICKNESS, r2 = STAND_WIDTH / 2, center = true);
		}
	}

	// stand arm dentents
	translate([0, 0, -(DIM[2] / 2 + TOLERANCE + THICKNESS / 2)])
	rotate([0, 0, STAND_HOME_ANGLE])
	arm_detents(TOLERANCE_XY, -TOLERANCE_XY);
}

module iphone_7_case_w_stand_mock(stand = false) {

	landscape = stand == "landscape";

	module mock() {
		rotate([0, 0, stand ? (landscape ? 90 : 180) - STAND_HOME_ANGLE : 0])
		translate([0, 0, -DIM[2] / 2 - TOLERANCE - THICKNESS])
		rotate([0, 0, STAND_HOME_ANGLE]) {

			color("gray")
			translate([0, 0, THICKNESS])
			rotate([180, 0])
			collar();

			%
			translate([0, 0, THICKNESS / 2])
			rotate([stand ? 90 : 0, 0])
			translate([0, 0, -THICKNESS / 2])
			arm();
		}

		color("gray")
		iphone_7_case_w_stand();

		*
// 		%
		color([0.25, 0.25, 0.25])
		iphone_7();
	}

	if (stand)
		translate([0, 0, DIM[2] / 2 + TOLERANCE + THICKNESS])
		if (landscape) {
			rotate([LANDSCAPE_ANGLE, 0])
			translate([0, DIM[1] / 2 - DIM[2] / 2])
			mock();
		} else {
			rotate([0, -PORTRAIT_ANGLE, 90])
			translate([DIM[0] / 2 - DIM[2] / 2, 0])
			mock();
		}
	else
		rotate([0, 0, 90])
		mock();
}

// MOCKS
*
union() {

	$fs = 0.5;

	*
	translate([-(DIM[1] + 20), 0])
	rotate([0, 180])
	iphone_7_case_w_stand_mock();

	iphone_7_case_w_stand_mock();

	*
	translate([DIM[1] + 20, 0]) {
		iphone_7_case_w_stand_mock("portrait");

		translate([DIM[1] / 2 + 20 + DIM[0] / 2, 0])
		iphone_7_case_w_stand_mock("landscape");
	}
}

arm();

// collar();

// iphone_7_case_w_stand();
