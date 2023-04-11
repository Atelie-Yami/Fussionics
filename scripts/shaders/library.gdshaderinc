float random(vec2 position) { 
	return fract(sin(dot(position, vec2(12.9898, 4.1414))) * 43758.5453);
}
vec2 random_2d(vec2 position) {
	return vec2(
		fract(sin(dot(position, vec2(12.9898, 4.1414))) * 43758.5453),
		fract(sin(dot(position + vec2(1.0, 1.0), vec2(12.9898, 4.1414))) * 43758.5453)
	);
}
vec2 modulo(vec2 divident, vec2 divisor){
	vec2 positiveDivident = mod(divident, divisor) + divisor;
	return mod(positiveDivident, divisor);
}
float noise(vec2 position){
	vec2 index_position = floor(position);
	vec2 fract_position = fract(position);
	fract_position = fract_position * fract_position * (3.0 - 2.0 * fract_position);
	float result = mix(
			mix(random(index_position), random(index_position + vec2(1.0,0.0)), fract_position.x),
			mix(
					random(index_position + vec2(0.0,1.0)),
					random(index_position + vec2(1.0,1.0)),
					fract_position.x),
			fract_position.y
	);
	return result * result;
}
float seamless_noise(vec2 uv, vec2 _period, int cell_amount) {
	uv = uv * float(cell_amount);
	vec2 cellsMinimum = floor(uv);
	vec2 cellsMaximum = ceil(uv);
	vec2 uv_fract = fract(uv);
	
	cellsMinimum = modulo(cellsMinimum, _period);
	cellsMaximum = modulo(cellsMaximum, _period);
	
	vec2 blur = smoothstep(0.0, 1.0, uv_fract);
	
	vec2 lowerLeftDirection = random_2d(vec2(cellsMinimum.x, cellsMinimum.y));
	vec2 lowerRightDirection = random_2d(vec2(cellsMaximum.x, cellsMinimum.y));
	vec2 upperLeftDirection = random_2d(vec2(cellsMinimum.x, cellsMaximum.y));
	vec2 upperRightDirection = random_2d(vec2(cellsMaximum.x, cellsMaximum.y));
	
	vec2 fraction = fract(uv);
	
	return mix(
			mix(
					dot(lowerLeftDirection, fraction - vec2(0, 0)),
					dot( lowerRightDirection, fraction - vec2(1, 0)),
					blur.x
			),
			mix(
					dot(upperLeftDirection, fraction - vec2(0, 1)),
					dot( upperRightDirection, fraction - vec2(1, 1)),
					blur.x
			),
			blur.y
	) * 0.8 + 0.5;
}