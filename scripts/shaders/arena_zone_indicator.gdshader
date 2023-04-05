shader_type canvas_item;

const float SPEED = 3.0;
const vec2 WAVE = vec2(90, 120); 

const float X = 40.0;
const float Y_TOP = 60.0;
const float Y_BOT = 70.0;

const float MICRO_SMOOTH = 1.2;

uniform float motion_side: hint_range(-1.0, 1.0, 0.1);
uniform vec4 base_color: source_color;
uniform float fade: hint_range(0.0, 1.0, 0.01);

void fragment() {
	vec4 color = vec4(1, 1, 1, 1);
	
	vec2 uv = UV * WAVE;
	float wave = cos(uv.x + uv.y - (TIME * motion_side * SPEED)) * 0.5;
	wave = 0.5 + wave;
	color.a = wave;
	
	float cut_x = pow(UV.x, X);
	float cut_x_2 = pow(1.0 - UV.x, X);
	float cut_y = pow(UV.y, Y_BOT);
	float cut_y_2 = pow(1.0 - UV.y, Y_TOP);
	
	color.a *= clamp(mix(cut_x, cut_x_2, motion_side) + cut_y + cut_y_2, 0.0, 1.0);
	color.a = pow(color.a, MICRO_SMOOTH) * fade;
	
	COLOR = base_color * color;
}