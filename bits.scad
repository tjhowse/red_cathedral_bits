wt = 2;

bowl_r = 30;

box_inside_x = 171;
box_inside_y = 220;

box_inside_z = 220;

bowls_x = 4;
bowls_y = 2;

table_tray_x = bowls_x*(bowl_r*2+wt)+wt;
table_tray_y = bowls_y*(bowl_r*2+wt)+wt;
table_tray_z = bowl_r+wt;
table_tray_corner_r = 10;

lid_clearance = 0.2;

if ((table_tray_x+2*wt+lid_clearance) > (box_inside_x-1)) echo("BOX TOO BIG OHNO");
if ((table_tray_y+2*wt+lid_clearance) > (box_inside_y-1)) echo("BOX TOO BIG OHNO");

module bowl() {
    sphere(r=bowl_r);
}

module tray_hull(extra=0) {
    hull() {
        translate([table_tray_corner_r,table_tray_corner_r,0]) cylinder(r=table_tray_corner_r, h= table_tray_z);
        translate([table_tray_x-table_tray_corner_r,table_tray_corner_r,0]) cylinder(r=table_tray_corner_r, h= table_tray_z);
        translate([table_tray_corner_r,table_tray_y-table_tray_corner_r,0]) cylinder(r=table_tray_corner_r, h= table_tray_z);
        translate([table_tray_x-table_tray_corner_r,table_tray_y-table_tray_corner_r,0]) cylinder(r=table_tray_corner_r, h= table_tray_z);
    }
}

module table_tray() {
    difference() {
//        cube([table_tray_x, table_tray_y, table_tray_z]);
        tray_hull();
        translate([wt+bowl_r, wt+bowl_r, table_tray_z])
            for (x = [0:bowls_x]) {
                for (y = [0:bowls_y]) {
                    translate([x*(wt+bowl_r*2), y*(wt+bowl_r*2),0]) bowl();
                }
            }
    }
}

module table_tray_lid() {
    difference() {
        cube([table_tray_x+wt*2+lid_clearance, table_tray_y+wt*2+lid_clearance, table_tray_z]);
        translate([wt+lid_clearance/2,wt+lid_clearance/2,wt]) cube([table_tray_x+lid_clearance, table_tray_y+lid_clearance, table_tray_z]);
    }
}

table_tray();

// translate([table_tray_x+10, 0, 0]) table_tray_lid();