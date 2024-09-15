const float TWO_PI = 6.28318530718;

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


float random (vec2 uv)
{
    return fract(sin(dot(uv.xy, vec2(12.9898,78.233))) * 43758.5453123);
}


mat2 rotate2d(float _angle){
    return mat2(vec2(cos(_angle),-sin(_angle)),
                vec2(sin(_angle),cos(_angle)));
}
