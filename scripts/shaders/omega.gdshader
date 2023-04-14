shader_type canvas_item;

uniform sampler2D particle_texture;
uniform vec4 colors[7]: source_color;
uniform vec2 diffs[7];
uniform float speeds[7];
uniform float lenghts[7];

const float PARTICLES_SIZE = 2.0;

struct Particle {
	vec4 color;
	float size;
	vec2 position;
};

vec2 uv(vec2 uv, Particle particle) {
	return clamp((uv * particle.size) - (particle.position * particle.size), vec2(0.0), vec2(1.0));
}

vec2 particle_motion_position(float _lemgth, float speed, vec2 diff) {
	float margin = 0.5 * _lemgth;
	vec2 margin_center = vec2(0.5) * (1.0 - _lemgth);
	vec2 pos;
	pos.x = margin + (cos((TIME + diff.x) * speed) * margin);
	pos.y = margin + (cos((TIME + diff.y) * speed) * margin);
	return pos + margin_center;
}

void fragment() {
	vec4 color;
	
	for (int i = 0; i < 7; i++) {
		Particle p;
		p.size = PARTICLES_SIZE;
		p.color = colors[i];
		p.position = particle_motion_position(lenghts[i], speeds[i], diffs[i]) - vec2(0.25);
		color += p.color * texture(particle_texture, uv(UV, p)).a;
	}
	COLOR = color;
}
