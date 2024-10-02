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


void fragment() {
	vec2 cord =  UV * 2.0 - 1.0;
	
	float pct = polygon(UV + vec2(0., - .078 ), 3);
	pct = step(.57735, pct);
	
	pct = 1. - pct;
	
	COLOR = vec4(vec3(pct) * BLUE, pct);
}