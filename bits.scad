wt = 2;

bowl_xy = 53;
bowl_corner_r = 10;

box_inside_x = 171;
box_inside_y = 220;
box_inside_z = 48;
box_inside_avilable_z = 30;

bowls_x = 3;
bowls_y = 2;

table_tray_x = bowls_x*(bowl_xy+wt)+wt;
table_tray_y = bowls_y*(bowl_xy+wt)+wt;
// table_tray_z = bowl_xy/2+wt;
table_tray_z = box_inside_avilable_z-wt;
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

module bowl() {
    //sphere(r=bowl_xy/2);
    offset_xy = bowl_xy/2-bowl_corner_r;
    offset_z = table_tray_z-bowl_corner_r-wt;
    hull() {
        translate([offset_xy, offset_xy, -offset_z]) sphere(r=bowl_corner_r);
        translate([-offset_xy, offset_xy, -offset_z]) sphere(r=bowl_corner_r);
        translate([offset_xy, -offset_xy, -offset_z]) sphere(r=bowl_corner_r);
        translate([-offset_xy, -offset_xy, -offset_z]) sphere(r=bowl_corner_r);

        translate([offset_xy, offset_xy, 100]) sphere(r=bowl_corner_r);
        translate([-offset_xy, offset_xy, 100]) sphere(r=bowl_corner_r);
        translate([offset_xy, -offset_xy, 100]) sphere(r=bowl_corner_r);
        translate([-offset_xy, -offset_xy, 100]) sphere(r=bowl_corner_r);
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
            for (x = [0:bowls_x-1]) {
                for (y = [0:bowls_y-1]) {
                    translate([x*(wt+bowl_xy), y*(wt+bowl_xy),0]) bowl();
                }
            }
            // for (x = [2:2]) {
            //     for (y = [0:bowls_y+1]) {
            //         translate([x*(wt+bowl_xy), (y*(wt+bowl_xy))/2-(wt+bowl_xy)/4,0]) scale([1,0.5,1]) #bowl();
            //     }
            // }
        }
    }
}

module table_tray_lid() {
    difference() {
        tray_hull(lid_z, lid_clearance+2*wt);
        translate([0,0,wt]) tray_hull(lid_z, lid_clearance);
    }
}

difference() {

    table_tray();
    // translate([20,0,0]) cube([100,100,100]);
}
// translate([0, table_tray_y+10, 0]) table_tray_lid();

// %cube([box_inside_x,box_inside_y,box_inside_z]);