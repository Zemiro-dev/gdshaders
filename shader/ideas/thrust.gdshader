shader_type canvas_item;

#include "res://shader/lib/glint.gdshaderinc"
#include "res://shader/data/theme.gdshaderinc"

uniform sampler2D noise1 : repeat_enable;
uniform vec2 scroll1 = vec2(0.05);

uniform float base_size : hint_range(0.01, .65, 0.01) = .5;
uniform float base_width : hint_range(-1., 1., 0.01) = 0.;
uniform vec4 base_color : source_color = vec4(1.0, .349, .369, 1.0);

uniform float mid_size : hint_range(0.01, .65, 0.01) = .5;
uniform float mid_width : hint_range(-1., 1., 0.01) = 0.;
uniform vec4 mid_color : source_color  = vec4(1.0, .570, .298, 1.);

uniform float top_size : hint_range(0.01, .65, 0.01) = .5;
uniform float top_width : hint_range(-1., 1., 0.01) = 0.;
uniform vec4 top_color : source_color  = vec4(1.0, 0.937, .769, 1.);

void fragment() {	
	float noise1_strength = texture(noise1, vec2(0.0) + scroll1 * TIME).r;
	float noise2_strength = texture(noise1, vec2(0.0) + scroll1 * TIME * 2.).r;
	float noise3_strength = texture(noise1, vec2(0.0) + scroll1 * TIME * 4.).r;
	
	vec2 baseuv = vec2(UV.x * (1. - base_width) + base_width / 2., UV.y + .49 - base_size/2. + noise1_strength * .1);
	float base = 1. - smoothstep(base_size, base_size + FUZZ, polygon(rotate(baseuv, vec2(.5), PI), 3));
	
	vec2 miduv = vec2(UV.x * (1. - mid_width) + mid_width / 2., UV.y + .49 - mid_size/2. + noise1_strength * .1);
	float mid = 1. - smoothstep(mid_size, mid_size + FUZZ, polygon(rotate(miduv, vec2(.5), PI), 3));
	
	vec2 topuv = vec2(UV.x * (1. - top_width) + top_width / 2., UV.y + .49 - top_size/2. + noise1_strength * .2);
	float top = 1. - smoothstep(top_size, top_size + FUZZ, polygon(rotate(topuv, vec2(.5), PI), 3));
	COLOR = vec4(((base - max(mid, top)) * mix(base_color.rgb, top_color.rgb, (.5 - noise1_strength) * .4) ) + ((mid - top) * mid_color.rgb) + (top * top_color.rgb), max(max(base, mid), top));
}