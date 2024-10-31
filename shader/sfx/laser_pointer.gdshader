shader_type canvas_item;


#include "res://shader/lib/glint.gdshaderinc"
#include "res://shader/data/theme.gdshaderinc"

uniform float laser_height : hint_range(0.0, .8, 0.1) = .1;
uniform float laser_width : hint_range(0.0, .8, 0.1) = .8;
uniform float opacity : hint_range(0., 1., .1) = .2;
uniform float cold_glow_power : hint_range(0., 100., 1.) = 10.;
uniform vec4 cold_glow_color : source_color;

float glow_bar(vec2 mask_uv, float power) {
	float glow_dist = (smoothstep(laser_width, 1., mask_uv.x) + smoothstep(laser_height, 1., mask_uv.y));
	float glow = .01/glow_dist;
	return clamp(glow, 0., 1.) * power;
}

void fragment() {
	vec4 cold_color = cold_glow_color;
	vec2 mask_uv = abs(UV * 2. - 1.);
	float cold_glow = glow_bar(mask_uv, cold_glow_power);
	cold_color.rgb += (vec3(cold_glow) * .1);
	cold_color.a *= clamp(cold_glow, 0., 1) * opacity;
	COLOR = cold_color;
}
