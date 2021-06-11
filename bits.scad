wt = 2;

bowl_corner_r = 10;

box_inside_x = 171;
box_inside_y = 220;
box_inside_z = 48;
// This is the amount of vertical space available when the box contains
// the player boards, the main board and one copy of the manual.
box_inside_avilable_z = 29;

// Leave this much space between the outside of the lid and the inside of the box.
box_inside_clearance = 1;

bowls_x = 3;
bowls_y = 2;

bowl_xy = (box_inside_x-box_inside_clearance-2*wt-(bowls_x+1)*wt)/bowls_x;

table_tray_x = bowls_x*(bowl_xy+wt)+wt;
table_tray_y = bowls_y*(bowl_xy+wt)+wt;
table_tray_z = box_inside_avilable_z-wt-box_inside_clearance;
table_tray_corner_r = bowl_corner_r+wt;

lid_clearance = 0.2;
lid_z = 15;

if ((table_tray_x+2*wt+lid_clearance) > (box_inside_x-1)) {
    echo("BOX TOO BIG IN X OHNO");
    echo((box_inside_x-1)-(table_tray_x+2*wt+lid_clearance));
}
if ((table_tray_y+2*wt+lid_clearance) > (box_inside_y-1)) {
    echo("BOX TOO BIG IN Y OHNO");
    echo((box_inside_x-y)-(table_tray_y+2*wt+lid_clearance));
}

module bowl(y_scale=1) {
    offset_xy = bowl_xy/2-bowl_corner_r;
    offset_z = table_tray_z-bowl_corner_r-wt;
    hull() {
        translate([offset_xy, offset_xy*y_scale, -offset_z]) sphere(r=bowl_corner_r);
        translate([-offset_xy, offset_xy*y_scale, -offset_z]) sphere(r=bowl_corner_r);
        translate([offset_xy, -offset_xy*y_scale, -offset_z]) sphere(r=bowl_corner_r);
        translate([-offset_xy, -offset_xy*y_scale, -offset_z]) sphere(r=bowl_corner_r);

        translate([offset_xy, offset_xy*y_scale, 100]) sphere(r=bowl_corner_r);
        translate([-offset_xy, offset_xy*y_scale, 100]) sphere(r=bowl_corner_r);
        translate([offset_xy, -offset_xy*y_scale, 100]) sphere(r=bowl_corner_r);
        translate([-offset_xy, -offset_xy*y_scale, 100]) sphere(r=bowl_corner_r);
    }
}

module tray_hull(z=table_tray_z, extra=0) {
    hull() {
        translate([table_tray_corner_r,table_tray_corner_r,0]) cylinder(r=table_tray_corner_r+extra/2, h= z);
        translate([table_tray_x-table_tray_corner_r,table_tray_corner_r,0]) cylinder(r=table_tray_corner_r+extra/2, h= z);
        translate([table_tray_corner_r,table_tray_y-table_tray_corner_r,0]) cylinder(r=table_tray_corner_r+extra/2, h= z);
        translate([table_tray_x-table_tray_corner_r,table_tray_y-table_tray_corner_r,0]) cylinder(r=table_tray_corner_r+extra/2, h= z);
    }
}

module table_tray() {
    difference() {
        tray_hull();
        translate([wt+bowl_xy/2, wt+bowl_xy/2, table_tray_z]) {
            // Big bowls.
            for (x = [0:bowls_x-2]) {
                for (y = [0:bowls_y-1]) {
                    translate([x*(wt+bowl_xy), y*(wt+bowl_xy),0]) bowl();
                }
            }
            // Little bowls.
            for (x = [2:2]) {
                for (y = [0:bowls_y+1]) {
                    // Enjoy this magic 1/6, future reader. Best of luck.
                    translate([x*(wt+bowl_xy), (y*(wt+bowl_xy))/2-(wt+bowl_xy)/4,0]) bowl(1/6);
                }
            }
        }
    }
}

module table_tray_lid() {
    difference() {
        tray_hull(lid_z, lid_clearance+2*wt);
        translate([0,0,wt]) tray_hull(lid_z, lid_clearance);
    }
}

// table_tray();
translate([0, table_tray_y+10, 0]) table_tray_lid();