shader_type canvas_item;

#include "lib/glint.gdshaderinc"
#include "data/theme.gdshaderinc"


void fragment() {
	vec2 uv = UV / TEXTURE_PIXEL_SIZE;
	
	//float outer = square(UV, .3);
	float outer = circle(uv, .4, 0.01);
	float inner = 1.0 - circle(uv, .3, 0.13);
	
	//float outer = circle(vec2(UV.x, UV.y), 0.35, 0.01);
	//
	//float fade_effect = sin(TIME) * 0.015;
	//
	//float inner = 1.0 - circle(vec2(UV.x, UV.y), 0.275, 0.1 - fade_effect );
	//
	COLOR = vec4(vec3(BLUE), 1.0 - (outer + inner));
	//COLOR.a -= outer + inner;
}
//
//float shieldHit(vec2 uv, float clock) {
	//float depth = 0.09;
	//float d = length(uv - 0.5) * 2.0; //dist from center mapped
	//float fwdEdge = smoothstep(max(0.0, clock - depth), clock, d);
	//float wipeOut = step(d, clock);
	////float wipeOut = smoothstep(d - .05, d, clock);
	//float result = fwdEdge * wipeOut;
	//return result;	
//}
