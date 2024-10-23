shader_type canvas_item;

#include "res://shader/lib/glint.gdshaderinc"
#include "res://shader/data/theme.gdshaderinc"

void fragment() {
	float cockpit = polygon(scale(UV + vec2(0., .25 ), .5, .5), 3);
	cockpit = 1. - smoothstep(.05,.05+FUZZ, cockpit);
	float ship = polygon(UV + vec2(0., - .078 ), 3);
	ship = 1. - smoothstep(.5, .5+FUZZ*2.5, ship);
	ship = ship - cockpit;
	float ink = polygon(UV + vec2(0., - .078 ), 3);
	ink = 1. - smoothstep(.53 , .56+FUZZ*2.5, ink);
	ink = ink - ship - cockpit;

	COLOR = vec4(vec3(ship) * BLUE.rgb + vec3(cockpit) * WHITE + ink * PURPLE_BLACK.rgb, ship + cockpit + ink );
} 