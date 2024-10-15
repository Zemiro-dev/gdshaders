shader_type canvas_item;

#include "lib/glint.gdshaderinc"
#include "data/theme.gdshaderinc"

void fragment() {	
	float inner_shell = 1. - circle(UV, .1, .02);
	vec3 inner_shell_color = mix(WHITE, RED, .25) * inner_shell;
	
	float outer_shell = (1. - circle(UV, .13 , .05)) * (1. - inner_shell);
	vec3 outer_shell_color = RED * outer_shell;
	
	float glow = (1. - circle(UV, .18 , .3 )) * (1. - inner_shell) * (1. - outer_shell);
	vec3 glow_color = mix(WHITE, RED, .7) * glow;
	glow = glow / 2.0;
	COLOR = vec4(outer_shell_color + inner_shell_color + glow_color, inner_shell + outer_shell + glow);
}
