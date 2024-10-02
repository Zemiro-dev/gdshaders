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

// util lib
float random (vec2 uv)
{
    return fract(sin(dot(uv.xy, vec2(12.9898,78.233))) * 43758.5453123);
}

// matrix transforms
mat2 rotate2d(float _angle){
    return mat2(vec2(cos(_angle),-sin(_angle)),
                vec2(sin(_angle),cos(_angle)));
}


// custom
float shield(vec2 uv, float radius, float feather, float ifeather) {
	float d = length(uv - 0.5); //dist from center mapped
	float outer = 1.0 - smoothstep(radius, radius+feather, d);
	float inner = smoothstep(radius-ifeather, radius, d);
	float shield = outer * inner;
	return shield;
}
