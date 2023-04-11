shader_type canvas_item;

uniform sampler2D noise_texture: repeat_enable;
uniform float powered: hint_range(0.0, 1.0, 0.01);

void fragment() {
	vec4 color = COLOR;
	vec2 uv = UV + vec2(TIME * 0.1);
	
	color.rgb = mix(color.rgb, color.rgb * (color.rgb + texture(noise_texture, uv).rgb), powered * 0.5);
	color.a = mix(color.a * 0.5,pow(color.a, 0.6), powered);
	
	COLOR = color;
}
