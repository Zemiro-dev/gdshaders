shader_type canvas_item;

#include "lib/glint.gdshaderinc"
#include "data/theme.gdshaderinc"

float polygon(vec2 uv, int sides)
{
	uv = uv * 2.0 - 1.0;

	float angle = atan(uv.x, uv.y);
	float radius = TWO_PI / float(sides);
	
	float dist = cos(floor(0.5 + angle / radius) * radius - angle) * length(uv);
	return dist;
}

vec2 scale(vec2 uv, float x, float y)
{
	mat2 scale = mat2(vec2(x, 0.0), vec2(0.0, y));
	
	uv -= 0.5;
	uv = uv * scale;
	uv += 0.5;
	return uv;
}


void fragment() {
	float cockpit = polygon(scale(UV + vec2(0., .25 ), .5, .5), 3);
	cockpit = 1. - step(.05, cockpit);
	float ship = polygon(UV + vec2(0., - .078 ), 3);
	ship = 1. - step(.57735, ship);
	ship = ship - cockpit;
	
	COLOR = vec4(vec3(ship) * BLUE + vec3(cockpit) * WHITE, ship + cockpit);
}