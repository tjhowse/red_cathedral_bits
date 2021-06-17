// This design evolved quite a lot over the course of this project. It should be rewritten.

wt = 2;
zff = 0.001;
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

box_tray_insert_corner_r = table_tray_corner_r;

lid_clearance = 0.2;
lid_z = 15;

// All cardboard parts are from the same punchboard, this thick.
token_z = 2.1;

workshop_tile_xy = 22.4;
workshop_tile_n = 28;

resource_disc_r = 24.4/2;
resource_disc_n = 8;

dice_xyz = 15.82;
dice_n = 5;

card_x = 44.1;
card_y = 68.16;
card_z = 0.33;

// This is the total thickness of all cards
cards_all_z = 21.1;

// The top, middle and bottom cards of the cathedral
cards_top_z = 3.18; // 10
cards_middle_z = 6.37; // 20
cards_bottom_z = cards_top_z; // 10

box_tray_x = table_tray_x;
box_tray_y = box_inside_y - table_tray_y - box_inside_clearance;
box_tray_z = table_tray_z;

if ((table_tray_x+2*wt+lid_clearance) > (box_inside_x-1)) {
    echo("BOX TOO BIG IN X OHNO");
    echo((box_inside_x-1)-(table_tray_x+2*wt+lid_clearance));
}
if ((table_tray_y+2*wt+lid_clearance) > (box_inside_y-1)) {
    echo("BOX TOO BIG IN Y OHNO");
    echo((box_inside_x-y)-(table_tray_y+2*wt+lid_clearance));
}

module bowl(x, y, r, z=0) {
    offset_x = x/2-r;
    offset_y = y/2-r;
    offset_z = z-bowl_corner_r-wt;
    hull() {
        translate([offset_x, offset_y, -offset_z]) sphere(r=r);
        translate([-offset_x, offset_y, -offset_z]) sphere(r=r);
        translate([offset_x, -offset_y, -offset_z]) sphere(r=r);
        translate([-offset_x, -offset_y, -offset_z]) sphere(r=r);

        translate([offset_x, offset_y, 100]) sphere(r=r);
        translate([-offset_x, offset_y, 100]) sphere(r=r);
        translate([offset_x, -offset_y, 100]) sphere(r=r);
        translate([-offset_x, -offset_y, 100]) sphere(r=r);
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
        translate([wt+bowl_xy/2, wt+bowl_xy/2, 0]) {
            // Big bowls.
            for (x = [0:bowls_x-2]) {
                for (y = [0:bowls_y-1]) {
                    translate([x*(wt+bowl_xy), y*(wt+bowl_xy),0]) bowl(bowl_xy, bowl_xy, bowl_corner_r);
                }
            }
            // Little bowls.
            for (x = [2:2]) {
                for (y = [0:bowls_y+1]) {
                    translate([x*(wt+bowl_xy), (y*(wt+bowl_xy))/2-(wt+bowl_xy)/4,0])  bowl(bowl_xy, bowl_xy/2-wt, bowl_corner_r);
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

small_bowl_z = box_tray_z;

module removable_small_bowl(z=small_bowl_z, extra=0) {
    difference() {
        hull() {
            translate([table_tray_corner_r,table_tray_corner_r,0]) cylinder(r=box_tray_insert_corner_r, h= z);
            translate([table_tray_x-table_tray_corner_r,table_tray_corner_r,0]) cylinder(r=box_tray_insert_corner_r, h= z);
            translate([table_tray_corner_r,table_tray_y-table_tray_corner_r,0]) cylinder(r=box_tray_insert_corner_r, h= z);
            translate([table_tray_x-table_tray_corner_r,table_tray_y-table_tray_corner_r,0]) cylinder(r=box_tray_insert_corner_r, h= z);
        }
        #bowl(1/6);
    }
}

module box_tray() {
    difference() {
        cube([box_tray_x, box_tray_y, box_tray_z-zff]);
        translate([wt,wt,box_tray_z-cards_all_z]) #cube([card_x, card_y, cards_all_z]);
        translate([wt+card_x+wt,wt,box_tray_z-dice_xyz]) #cube([dice_xyz, dice_xyz*dice_n, dice_xyz]);
        translate([wt+bowl_xy/2, wt+bowl_xy/2, table_tray_z]) {
            for (x = [2:2]) {
                for (y = [0:bowls_y+1]) {
                    // Enjoy this magic 1/6, future reader. Best of luck.
                    translate([x*(wt+bowl_xy), (y*(wt+bowl_xy))/2-(wt+bowl_xy)/4,0]) bowl(1/6);
                }
            }
        }
        translate([wt,card_y+wt+resource_disc_r+wt,box_tray_z]) rotate([0,90,0]) #cylinder(r=resource_disc_r, h=resource_disc_n*token_z);
        translate([wt+card_x+wt+dice_xyz+wt,wt,box_tray_z-(2*workshop_tile_xy)/3]) #cube([workshop_tile_xy, token_z*workshop_tile_n, (2*workshop_tile_xy)/3]);
    }
}

table_tray();
// translate([0, table_tray_y+10, 0]) table_tray_lid();
// box_tray();
// removable_small_bowl();