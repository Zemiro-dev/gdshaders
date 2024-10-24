shader_type canvas_item;

#include "res://shader/lib/glint.gdshaderinc"
#include "res://shader/data/theme.gdshaderinc"

uniform float box_size = .9;
uniform float ink_width = .03;
uniform float highlight_width = .05;
uniform float highlight_power = .5;
uniform vec4 texture_mix : source_color;
uniform float texture_mix_power = .0;

uniform sampler2D noise1 : repeat_enable;
uniform sampler2D noise2 : repeat_enable;
uniform sampler2D noise3 : repeat_enable;

void fragment() {
	vec2 uvink = UV * 2. - 1.;
	float ink = 1. - smoothstep(box_size+ink_width, box_size+ink_width+FUZZ*2., max(abs(uvink.x), abs(uvink.y)));
	float box = 1. - smoothstep(box_size - highlight_width, box_size-highlight_width+FUZZ, max(abs(uvink.x), abs(uvink.y)));
	
	
	float highlight = 1. - smoothstep(box_size, box_size+FUZZ, max(abs(uvink.x), abs(uvink.y)));
	ink -= box - highlight;
	highlight -= box;
	
	vec4 highlight_color = mix(PURPLE, vec4(WHITE, 1.), highlight_power);
	
	float noise1_strength = texture(noise1, UV).r;
	float noise2_strength = texture(noise2, UV).r;
	float strength = noise1_strength * (1.0-noise2_strength);
	vec4 box_color = mix(PURPLE, texture_mix, (1.-strength) * texture_mix_power);
	
	COLOR = PURPLE_BLACK * ink + box_color * box + highlight_color * highlight;
}
