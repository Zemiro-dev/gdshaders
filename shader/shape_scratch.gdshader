shader_type canvas_item;

#include "lib/glint.gdshaderinc"
#include "data/theme.gdshaderinc"

void fragment()
{
	vec2 uv = UV / TEXTURE_PIXEL_SIZE;
	mat3 pan1 = mat3(1.0);
	pan1[2][0] = .5;
	pan1[2][1] = .5;
	
	mat3 pan2 = mat3(1.0);
	pan2[2][0] = -.5;
	pan2[2][1] = -.5;
	
	float angle = TIME;
	mat3 rotateMatrix = mat3(
		vec3(cos(angle), -sin(angle), 0.0),
		vec3(sin(angle), cos(angle), 0.0),
		vec3(0.0, 0.0, 1.0)
	);
	mat3 scaleMatrix = mat3(1.0);
	scaleMatrix[0][0] = 2.0; //we're scaling the space so of course the shape is smaller
	scaleMatrix[1][1] = 2.0; //we're scaling the space so of course the shape is smaller
	vec3 nv = vec3(uv, 1.0);
	nv = (pan1 * rotateMatrix * scaleMatrix * pan2) * nv;
	uv = nv.xy;
	float poly = polygon(uv, 0.35, 3);
	COLOR = vec4(vec3(poly), 1.0);
}