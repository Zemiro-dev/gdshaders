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


float polygon(vec2 uv, float width, int sides)
{
	uv = uv * 2.0 - 1.0;

	float angle = atan(uv.x, uv.y);
	float radius = TWO_PI / float(sides);
	
	float dist = cos(floor(0.5 + angle / radius) * radius - angle) * length(uv);
	float poly = step(width, dist);
	return poly;
}


// util lib
float random (vec2 uv)
{
    return fract(sin(dot(uv.xy, vec2(12.9898,78.233))) * 43758.5453123);
}

// matrix transforms
vec2 rotate(vec2 uv, vec2 pivot, float angle)
{
	//modified this from godot shaders to match my alchemy stuff so zero is zero
	mat2 rotation = mat2(vec2(cos(angle), -sin(angle)),
						vec2(sin(angle), cos(angle)));
	
	uv -= pivot;
	uv = rotation * uv;
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
