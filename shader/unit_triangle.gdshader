shader_type canvas_item;

#include "lib/glint.gdshaderinc"
#include "data/theme.gdshaderinc"

void fragment() {
	float cockpit = polygon(scale(UV + vec2(0., .25 ), .5, .5), 3);
	cockpit = 1. - step(.05, cockpit);
	float ship = polygon(UV + vec2(0., - .078 ), 3);
	ship = 1. - step(.57735, ship);
	ship = ship - cockpit;

	COLOR = vec4(vec3(ship) * BLUE + vec3(cockpit) * WHITE, ship + cockpit);
}