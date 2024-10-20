shader_type canvas_item;

#include "res://shader/lib/glint.gdshaderinc"
#include "res://shader/data/theme.gdshaderinc"

uniform float strength : hint_range(0., 1., .1) = 1.;
uniform vec2 offset = vec2(0.0, 0.0);

void vertex() {
	// Called for every vertex the material is visible on.
	VERTEX += offset;
}

void fragment() {
	vec3 color_step_empty = RED.rgb;
	vec3 color_step_half = YELLOW.rgb;
	vec3 color_step_full = BLUE.rgb;
	float debug_dot = 1. - circle(UV, .2, FUZZ*1.8);
	vec3 color = (1. - step(.5, strength)) * mix(color_step_empty, color_step_half, strength * 2.)
		+ (step(.5, strength) * mix(color_step_half, color_step_full, (strength - .5) * 2.));
	
	
	COLOR = vec4(color, debug_dot);
} 

// COLOR = vec4(texture(TEXTURE, UV).rgb - (smoothstep(0., 1., abs(sin(TIME))*(RED+GREEN))), 1.);