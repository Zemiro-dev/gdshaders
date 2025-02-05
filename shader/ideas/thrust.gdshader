shader_type canvas_item;

#include "res://shader/lib/glint.gdshaderinc"

uniform sampler2D noise1 : repeat_enable;
uniform vec2 scroll1 = vec2(0.05);

uniform float base_size : hint_range(0.01, .65, 0.01) = .5;
uniform float base_width : hint_range(-1., 1., 0.01) = 0.;

uniform float mid_size : hint_range(0.01, .65, 0.01) = .5;
uniform float mid_width : hint_range(-1., 1., 0.01) = 0.;

uniform float top_size : hint_range(0.01, .65, 0.01) = .5;
uniform float top_width : hint_range(-1., 1., 0.01) = 0.;

uniform float speed_mod : hint_range(0., 2., .05) = 1.0;
uniform float ripple_speed : hint_range(0., 100., 1.) = 1.0;
uniform float ripple_power : hint_range(0., .3, .01) = .08;

uniform float distance_intensity_shift : hint_range(-1.0, 1.0, .1) = .1;
uniform float top_distance_intensity_shift : hint_range(-1.0, 1.0, .1) = .2;
uniform float color_intensity_shift : hint_range(-2.0, 2.0, .1) = .4;
uniform float top_color_intensity_shift : hint_range(-2.0, 2.0, .1) = .6;

global uniform vec4 theme_red;
global uniform vec4 theme_orange;
global uniform vec4 theme_yellow;
global uniform vec4 theme_white;
global uniform float base_fuzz;

void fragment() {
	vec4 base_color = theme_red;
	vec4 mid_color = theme_orange;
	vec4 top_color = theme_yellow;
	float noise1_strength = texture(noise1, vec2(0.0) + scroll1 * TIME * speed_mod).r;
	float noise2_strength = texture(noise1, vec2(-UV.y) + scroll1 * TIME * ripple_speed).r * ripple_power;
	
	float noise1_color_shift = (.4 - noise1_strength) * color_intensity_shift;
	float noise1_top_color_shift = (.5 - noise1_strength) * top_color_intensity_shift;
	float noise1_base_distance_shift = noise1_strength * distance_intensity_shift;
	float noise1_mid_distance_shift = noise1_strength * distance_intensity_shift;
	float noise1_top_distance_shift = noise1_strength * top_distance_intensity_shift;
	
	vec2 baseuv = vec2(UV.x * (1. - base_width) + base_width / 2., UV.y + .49 - base_size/2. + noise1_base_distance_shift + noise2_strength);
	float base = 1. - smoothstep(base_size, base_size + base_fuzz, polygon(rotate(baseuv, vec2(.5), PI), 3));
	vec3 bcol = mix(base_color.rgb, top_color.rgb, noise1_color_shift);
	
	vec2 miduv = vec2(UV.x * (1. - mid_width) + mid_width / 2., UV.y + .49 - mid_size/2. + noise1_mid_distance_shift + noise2_strength);
	float mid = 1. - smoothstep(mid_size, mid_size + base_fuzz, polygon(rotate(miduv, vec2(.5), PI), 3));
	vec3 mcol = mix(mid_color.rgb, top_color.rgb, noise1_color_shift);
	
	vec2 topuv = vec2(UV.x * (1. - top_width) + top_width / 2., UV.y + .49 - top_size/2. + noise1_top_distance_shift + noise2_strength);
	float top = 1. - smoothstep(top_size, top_size + base_fuzz, polygon(rotate(topuv, vec2(.5), PI), 3));
	vec3 tcol = mix(top_color.rgb, theme_white.rgb, noise1_top_color_shift);
	
	COLOR = vec4(((base - max(mid, top)) * bcol ) + ((mid - top) * mcol) + (top * tcol), max(max(base, mid), top));
}