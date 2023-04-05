shader_type canvas_item;

uniform sampler2D border;
uniform sampler2D legancy: repeat_enable;
uniform float fade: hint_range(0.0, 1.0, 0.01);
const float internal_rect_size = 4.0;


void fragment() {
	vec4 _legancy = texture(legancy, UV + vec2(TIME * 0.05));
	vec4 _legancy_2 = texture(legancy, UV - vec2(TIME * 0.05));
	float _border = texture(border, UV).a;
	
	float base_color = _legancy.r * _legancy.a * _legancy.a * pow(_border, 0.33);
	float base_color_2 = _legancy_2.r * _legancy_2.a * _legancy_2.a * pow(_border, 0.33);
	
	base_color = clamp(base_color, 0.0, 1.0);
	base_color_2 = clamp(base_color_2, 0.0, 1.0);
	
	float rect = round(clamp(UV.x * internal_rect_size, 0.0, 1.0));
	rect *= round(clamp((1.0 - UV.x) * internal_rect_size, 0.0, 1.0));
	rect *= round(clamp((1.0 - UV.y) * internal_rect_size, 0.0, 1.0));
	rect *= round(clamp(UV.y * internal_rect_size, 0.0, 1.0));
	
	base_color = mix(base_color * (1.0 - (_border * _border)), base_color_2, rect);
	
	COLOR += vec4(base_color) * 0.4 * fade;
}