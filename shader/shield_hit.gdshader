shader_type canvas_item;

#include "lib/glint.gdshaderinc"
#include "data/theme.gdshaderinc"

float shieldHit(vec2 uv, float clock) {
	float depth = 0.09;
	float d = length(uv - 0.5) * 2.0; //dist from center mapped
	float fwdEdge = smoothstep(max(0.0, clock - depth), clock, d);
	float wipeOut = step(d, clock);
	//float wipeOut = smoothstep(d - .05, d, clock);
	float result = fwdEdge * wipeOut;
	return result;	
}


void fragment() {
	vec2 uv = UV / TEXTURE_PIXEL_SIZE;
	float clock = fract(TIME / 2.0);
	float clock2 = fract((TIME + .5) / 2.3);
	float clock3 = fract((TIME + .2) / 2.2);
	float clock4 = fract((TIME + .8) / 1.5);
	float clock5 = fract((TIME + .6) / 1.8);
	
	float shieldRadius = .8;
	float shieldBound = 1.0 - step(shieldRadius, length(uv - 0.5) * 2.0);
	float hit1 = shieldHit(uv + vec2(.1, .1), clock) * shieldBound;
	float hit2 = shieldHit(uv - vec2(.1, .1), clock2) * shieldBound;
	float hit3 = shieldHit(uv - vec2(.1, .3), clock3) * shieldBound;
	float hit4 = shieldHit(uv - vec2(.3, 0.0), clock4) * shieldBound;
	float hit5 = shieldHit(uv + vec2(0.1, 0.5), clock5) * shieldBound;
	float result = max(max(max(max(hit1, hit2), hit3), hit4), hit5);
	COLOR = vec4(BLUE, result);
}
