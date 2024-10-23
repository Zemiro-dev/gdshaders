shader_type canvas_item;

#include "res://shader/lib/glint.gdshaderinc"
#include "res://shader/data/theme.gdshaderinc"

uniform sampler2D _noise1 : repeat_enable;
uniform vec2 scroll1 = vec2(0.05);

uniform sampler2D _noise2 : repeat_enable;
uniform vec2 scroll2 = vec2(-0.05, 0.05);

uniform vec4 top_color : source_color;
uniform float light_start : hint_range(0.0, 1.0) = 0.275;
uniform float light_end : hint_range(0.0, 1.0) = 0.4;

void fragment() {
	float noise1_strength = texture(_noise1, UV + scroll1 * TIME * .1).r;
	float noise2_strength = texture(_noise2, UV + scroll1 * TIME * .3).r;
	float strength = noise1_strength * noise2_strength;
	vec4 top_light = smoothstep(light_start, light_end, strength) * top_color;
	strength = .5 + (strength - .5) * .3;
	COLOR = mix(PURPLE_BLACK, PURPLE, strength) + top_light;
}
