shader_type canvas_item;

void fragment() {
	COLOR.a *= 1.0 - round(distance(UV, vec2(0.5)) * 1.02);
}
