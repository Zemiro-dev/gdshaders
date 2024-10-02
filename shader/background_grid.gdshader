shader_type canvas_item;
#include "data/theme.gdshaderinc"

uniform vec2 dim = vec2(512.0);
uniform vec2 offset = vec2(0.0, 0.0);
uniform float gridSize = 128.0;

void fragment() {	
	vec3 color = BLACK;
	
	vec2 px = floor(offset + (dim * UV));
	vec2 modPx = mod(px, gridSize);
	
	if (modPx.x == 0.0 || modPx.y == 0.0)  {
		color = WHITE;
	}	
	
	COLOR = vec4(color, 1.0);
}