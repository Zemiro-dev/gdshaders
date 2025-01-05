shader_type canvas_item;

#include "lib/glint.gdshaderinc"
#include "data/theme.gdshaderinc"

float hit(vec2 uv, float radius, float feather, float ifeather) {
	float d = length(uv); //dist from center mapped
	float outer = 1.0 - smoothstep(radius, radius+feather, d);
	float inner = smoothstep(radius-ifeather, radius, d);
	float hit = outer * inner;
	return hit;
}

void fragment() {
	vec2 uv = UV / TEXTURE_PIXEL_SIZE;
	float clock = fract(TIME/.5);
	float maxRadius = 2.0;
	float radius = clock * maxRadius;
	uv = (uv * 2.0) - 1.0; // remap to -1 to 1
	float d = length(uv); //dist from center mapped
	// outer fade of main shield
	float shieldBound = 1.0 - smoothstep(.8, .85, d);

	uv = uv - vec2(.75, 0);
	float ripple = hit(uv, radius, .025, .04);

	vec3 rippleColor = BLUE.rgb + (.08 * pow(ripple, 10.0));

	// the pow statement adds some white highlighting near the main ring
	//vec3 mainShieldColor = BLUE + (.08 * pow(mainShield, 10.0));
	//COLOR = vec4(mainShieldColor, mainShield);
	COLOR = vec4(rippleColor, ripple * shieldBound);
}
