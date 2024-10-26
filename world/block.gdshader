shader_type canvas_item;

#include "res://shader/lib/glint.gdshaderinc"
#include "res://shader/data/theme.gdshaderinc"

uniform int mode = 0;
uniform vec2 scroll1 = vec2(0.);
uniform vec2 scroll2 = vec2(0.);
uniform float box_size = .9;
uniform float ink_width = .03;
uniform float highlight_width = .05;
uniform float highlight_power = .5;
uniform vec4 texture_mix : source_color;
uniform float texture_mix_power = .0;

uniform sampler2D noise1 : repeat_enable;
uniform sampler2D noise2 : repeat_enable;
uniform sampler2D noise3 : repeat_enable;

float get_strength(vec2 uv) {	
	float noise1_strength = texture(noise1, uv+scroll1).r;
	float noise2_strength = texture(noise2, uv+scroll2).r;
	float strength = noise1_strength * (1.0-noise2_strength);
	return strength;
}

vec4 get_highlight_color() {
	return mix(PURPLE, vec4(WHITE, 1.), highlight_power);
}

float get_ink(vec2 uvink) {	
	float ink = 1. - smoothstep(box_size+ink_width, box_size+ink_width+FUZZ*2., max(abs(uvink.x), abs(uvink.y)));
	return ink;
}

float get_box(vec2 uvink) {
	float box = 1. - smoothstep(box_size - highlight_width, box_size-highlight_width+FUZZ, max(abs(uvink.x), abs(uvink.y)));
	return box;
}

float get_highlight(vec2 uvink) {
	float highlight = 1. - smoothstep(box_size, box_size+FUZZ, max(abs(uvink.x), abs(uvink.y)));
	return highlight;
}

vec4 box_mode(vec2 uv) {
	vec2 uvink = uv * 2. - 1.;
	float ink = get_ink(uvink);
	float box = get_box(uvink);
	float highlight = get_highlight(uvink);	
	
	
	ink -= box - highlight;
	highlight -= box;
	
	vec4 highlight_color = get_highlight_color();
	
	float strength = get_strength(uv);
	
	vec4 box_color = mix(PURPLE, texture_mix, (1.-strength) * texture_mix_power);
	return PURPLE_BLACK * ink + box_color * box + highlight_color * highlight;
}

void fragment() {
	switch(mode){
		case 0:
			COLOR = box_mode(UV);
			break;
		case 1:
			COLOR = box_mode(UV);
			float divide = (UV.x - (1. - UV.y - FUZZ));
			float corner = smoothstep(0., FUZZ , divide);
			float iCorner = smoothstep(FUZZ, FUZZ*2., divide);
			float iBand = 1.0 - smoothstep(FUZZ + highlight_width, FUZZ*2. + highlight_width, divide);
			float line = (corner - iCorner) * COLOR.a;
			corner -= 1.0 - iCorner;
			iBand -= 1.0 - iCorner;
			vec2 uvink = UV * 2. - 1.;
			float ink = get_ink(uvink);
			float box = get_box(uvink);
			float highlight = get_highlight(uvink);	
			
			
			ink -= box - highlight;
			highlight -= box;
			iBand -= (ink - box - highlight) * iBand; 
			
			vec3 cur_color = COLOR.rgb;
			COLOR.a = corner * COLOR.a + line;
			COLOR.rgb *= (1. - line);
			COLOR.rgb *= (1. - iBand);
			COLOR.rgb += iBand * (get_highlight_color().rgb + PURPLE_BLACK.rgb * 2.);
			break;
		default:
			COLOR = PURPLE;
			break;
	}
}
