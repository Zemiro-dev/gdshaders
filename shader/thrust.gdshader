shader_type canvas_item;

#include "lib/glint.gdshaderinc"
#include "data/theme.gdshaderinc"

void fragment() {
	float flicker_rng = fbm(vec2(fract(TIME*.5), 0.), 6, 5.0, .5);
	vec3 flame_color = mix(RED, YELLOW, (flicker_rng * .6) + .4);
	
	float flame_shape = polygon(rotate(UV, vec2(.5), PI) + vec2(0., -.246), 3);
	float flame_size = .5 + flicker_rng * .02;
	flame_shape = 1. - smoothstep(flame_size, flame_size + .01, flame_shape);
	
	COLOR = vec4(flame_color, flame_shape);
}
