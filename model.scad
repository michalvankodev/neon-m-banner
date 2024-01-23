
border_fill = 5;
led_width = 5.6;
led_height = 12;

module rounded_cube(size, radius) {
  hull(){ 
    translate([radius, radius, 0])
         for (p=[[0, radius, 0], [radius, 0, 0]]) cylinder(size[2], radius, radius);
    
    translate([size[0] - radius, radius, 0])
       for (p=[[size[0], radius, 0], [size[0] - radius, 0, 0]]) cylinder(size[2], radius, radius);
    
    translate([radius, size[1] - radius, 0])
       for (p=[[0, size[1] - radius, 0], [radius, size[1], 0]]) cylinder(size[2], radius, radius);
    
    translate([size[0] - radius, size[1] - radius, 0])
      for (p=[[size[0], size[1] - radius, 0], [size[0] - radius, size[1], 0]]) cylinder(size[2], radius, radius);
      }
}

// Adjust the dimensions and radius as needed
size1 = [170, 170, 5];
outer_border_radius = 27;

// Create the rounded cube
module outer_border(size, radius, diff) {
    difference() {
    rounded_cube(size, radius);
     translate([diff, diff, 0])
         rounded_cube([size[0]-2*diff, size[1]-2*diff, size[2]], radius - diff);
    }
}

module get_svg_path(size) {
  resize([size[0], size[1], 0])  linear_extrude(size[2]) import("border.svg");    
}

length = 170;
base_height = 5;
border_width = 5;

m_height = 55.6;
m_width = 80;

module letter_m() {
    translate([length / 2 - m_width/2 , length / 2 - m_height / 2, 0])
    linear_extrude(led_height + base_height) import("m-letter.svg");
}

module letter_m_void() {
    difference() {
        translate([length / 2 - 45, length / 2 - 32.5, 0]) rounded_cube([90, 65, 17], 5);
        letter_m();
        translate([length / 2 - 29.5, length / 2 - 47.5, 0])rounded_cube([22, 65, 17], 10);
        translate([length / 2 + 7.5, length / 2 - 47.5, 0])rounded_cube([22, 65, 17], 10); 
    }
}

union() {
     //base([170, 170, 5], outer_border_radius);
    //outer_border([170, 170, 17], outer_border_radius, 5);
    // base
    get_svg_path([length, length, base_height]);
    
    // border
    difference() {
       get_svg_path([length, length, base_height + led_height]);
    translate([border_width, border_width, 0])
        get_svg_path([length - 2 * border_width, length - 2 * border_width, base_height + led_height]);
    }
    
    // border inner
    inner_translate = border_width + led_width;
    translate([inner_translate, inner_translate, 0])
    difference() {
       inner_length = length - 2 * border_width - 2 * led_width;
       
        
       get_svg_path([inner_length, inner_length, base_height + led_height]);
    translate([border_width, border_width, 0])
        get_svg_path([inner_length - 2 * border_width, inner_length - 2 * border_width, base_height + led_height]);
    }
    
    letter_m_void();
    
}