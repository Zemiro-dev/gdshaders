shader_type canvas_item;

#include "lib/glint.gdshaderinc"
#include "data/theme.gdshaderinc"

uniform float remaining : hint_range(0.0, 1.0) = 0.3;
uniform float units : hint_range(0., 10.) = 5.;

float barOutline(vec2 uv) {
	vec2 _uv = uv * 2. - 1.;
	float pct = 0.;
	pct = length( max(abs(_uv) - .55   ,0.) ); //make distance field
	pct = smoothstep(.28, .3 , pct) - smoothstep(.33, .35 , pct); //make outline
	return pct;
}

float unitBar(vec2 uv, float size) {
	//uniform remaining
	//uniform units
	vec2 _uv = uv * 2. - 1.;
	float pct = length( min(abs(_uv * .01)-size,0.) );
	pct = smoothstep(.5, .5002, pct);
	return pct;
	//vec2 _uv = uv * 2. - 1.;
	//float pct = 0.;
	//pct = length( max(abs(_uv) - .55   ,0.) ); //make distance field
	//
	////float innerBarMask = 1. - smoothstep(.26, .28 , pct);
	////float innerBar = step(.12  , uv.x) - step(.88, uv.x);
	//float divider = fract((uv.x - .12) * 100./76. * (units ));
	//divider = smoothstep(.90 , 95., divider) + smoothstep(.1      , 0.05, divider);
	//divider = divider * step(.15, uv.x) * step(uv.x, .85);
	//divider = 1.0 - divider;
	//return innerBarMask;
}

float bullseye(vec2 uv) {
	vec2 _uv = uv * 2. - 1.;
	float pct = 0.;
	pct = length( max(abs(_uv),0.) ); //distance field
	pct = fract(pct * 10.); //split
	pct = min(smoothstep(.2, .7, pct), smoothstep(.7, .2, pct));
	return pct;
}

void fragment() {
	vec2 uv = vec2(fract(UV.x*units), UV.y);
	float inner = unitBar(uv, .358);
	float outer = unitBar(uv, .3582);
	float remainingBar = smoothstep(remaining, remaining-.01, UV.x);
	inner *= remainingBar;
	outer *= 1. - inner;
	COLOR = vec4(RED.rgb * inner + mix(RED.rgb, BLACK, .55) * outer, outer + inner);
}