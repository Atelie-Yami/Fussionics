shader_type canvas_item;


uniform sampler2D particle_texture;

struct Particle {
	vec4 color;
	float life;
	float size;
	vec2 position;
};

const int PARTICLES_COUNT = 16;
const float PARTICLES_SIZE = 8.0;


float random(vec2 position) { 
	return fract(sin(dot(position, vec2(12.9898, 4.1414))) * 43758.5453);
}
vec2 uv(vec2 uv, Particle particle) {
	return clamp((uv * particle.size) - (particle.position * particle.size), vec2(0.0), vec2(1.0));
}
vec2 motion() {
	vec2 motion;
	
	return motion;
}
void reset(Particle particle) {
	particle.color = vec4(0.0);
	particle.size = 0.0;
	particle.life = 0.3;
}

void fragment() {
	vec4 color;
	
	for (int i = 0; i < PARTICLES_COUNT; i++) {
		Particle p;
		
		if ( p.life < 0.0) {
			reset(p);
		}
		
		p.size = PARTICLES_SIZE;
		p.color = vec4(1.0);
		
		
		
		p.position; // = particle_motion_position(lenghts[i], speeds[i], diffs[i]) - vec2(0.25);
		color += p.color * texture(particle_texture, uv(UV, p)).a;
	}
	COLOR = color;
}
