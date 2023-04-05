shader_type canvas_item;
uniform float scanline_count : hint_range(0, 1800) = 50.0;


void fragment() {
	float s = sin((SCREEN_UV.y * scanline_count * PI * 2.0) + (TIME * 8.0)) * 0.5;
	s = pow(s + 0.5, 1.5);
	COLOR.a *= clamp(s, 0.2, 0.9) + 0.1;
	
	float c = pow(1.0 - COLOR.a, 2.0);
	COLOR.rgb += vec3(c * s, c * s * s, c);
}