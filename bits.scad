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

if (table_tray_x > (box_inside_x-1)) echo("BOX TOO BIG OHNO");
if (table_tray_y > (box_inside_y-1)) echo("BOX TOO BIG OHNO");

module table_tray() {
    difference() {
        cube([table_tray_x, table_tray_y, table_tray_z]);
        translate([wt+bowl_r, wt+bowl_r, table_tray_z])
            for (x = [0:bowls_x]) {
                for (y = [0:bowls_y]) {
                    translate([x*(wt+bowl_r*2), y*(wt+bowl_r*2),0]) sphere(r=bowl_r);
                }
            }
    }
}

module table_tray_lid() {
    difference() {
        cube([table_tray_x+wt*2, table_tray_y+wt*2, table_tray_z]);
        translate([wt,wt,wt]) cube([table_tray_x, table_tray_y, table_tray_z]);
    }
}

table_tray();

translate([table_tray_x+10, 0, 0]) table_tray_lid();