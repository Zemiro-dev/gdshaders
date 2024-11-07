shader_type canvas_item;

#include "res://shader/lib/glint.gdshaderinc"
#include "res://shader/data/theme.gdshaderinc"

uniform sampler2D noise1 : repeat_enable;
uniform sampler2D noise2 : repeat_enable;
uniform vec4 target_color : source_color;
uniform float tolerance : hint_range(0.0, 1.0, 0.1) = .1;

varying vec2 world_pos;
 
void vertex() {
    world_pos = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
}
 
float get_strength(vec2 uv) {	
	float noise1_strength = texture(noise1, (world_pos*.001)).r;
	float noise2_strength = texture(noise2, (world_pos*.001)).r;
	float strength = noise1_strength * (1.0-noise2_strength);
	//float strength = noise1_strength;
	return strength;
}

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	COLOR = vec4(mix(color.rgb, WHITE, get_strength(UV) * .2), color.a);    
}