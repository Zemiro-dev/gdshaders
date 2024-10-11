const float TWO_PI = 6.28318530718;


// shapes
float square(vec2 uv, float width)
{
	uv = uv * 2.0 - 1.0;

	vec2 abs_uv = abs(uv.xy);
	float square = step(width, max(abs_uv.x, abs_uv.y));
	return square;
}


float circle(vec2 uv, float radius, float feather)
{
	return smoothstep(radius, radius + feather, length(uv - vec2(0.5)));
}

float polygon(vec2 uv, int sides)
{
	uv = uv * 2.0 - 1.0;

	float angle = atan(uv.x, uv.y);
	float radius = TWO_PI / float(sides);

	float dist = cos(floor(0.5 + angle / radius) * radius - angle) * length(uv);
	return dist;
}

// util lib
float random (vec2 uv)
{
    return fract(sin(dot(uv.xy, vec2(12.9898,78.233))) * 43758.5453123);
}

float noise(vec2 uv) {
    vec2 uv_index = floor(uv);
    vec2 uv_fract = fract(uv);

    // Four corners in 2D of a tile
    float a = random(uv_index);
    float b = random(uv_index + vec2(1.0, 0.0));
    float c = random(uv_index + vec2(0.0, 1.0));
    float d = random(uv_index + vec2(1.0, 1.0));

    vec2 blur = smoothstep(0.0, 1.0, uv_fract);

    return mix(a, b, blur.x) +
            (c - a) * blur.y * (1.0 - blur.x) +
            (d - b) * blur.x * blur.y;
}

float fbm(vec2 uv, int octaves, float lacunarity, float gain) {
    float amplitude = 0.5;
    float frequency = 1.0;
	float value = 0.0;

    for(int i = 0; i < octaves; i++) {
        value += amplitude * noise(frequency * uv);
        amplitude *= gain;
        frequency *= lacunarity;
    }
    return value;
}

// matrix transforms
mat2 rotate2d(float _angle){
    return mat2(vec2(cos(_angle),-sin(_angle)),
                vec2(sin(_angle),cos(_angle)));
}

vec2 rotate(vec2 uv, vec2 pivot, float angle)
{
	mat2 rotation = rotate2d(angle);

	uv -= pivot;
	uv = uv * rotation;
	uv += pivot;
	return uv;
}

vec2 scale(vec2 uv, float x, float y)
{
	mat2 scale = mat2(vec2(x, 0.0), vec2(0.0, y));

	uv -= 0.5;
	uv = uv * scale;
	uv += 0.5;
	return uv;
}


// custom
float shield(vec2 uv, float radius, float feather, float ifeather) {
	float d = length(uv - 0.5); //dist from center mapped
	float outer = 1.0 - smoothstep(radius, radius+feather, d);
	float inner = smoothstep(radius-ifeather, radius, d);
	float shield = outer * inner;
	return shield;
}
