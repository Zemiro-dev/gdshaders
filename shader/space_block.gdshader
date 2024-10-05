shader_type canvas_item;

#include "lib/glint.gdshaderinc"
#include "data/theme.gdshaderinc"

void fragment() {
	vec2 tl = step(vec2(.1), UV);
	vec2 br = step(vec2(.1), 1.0 - UV);
	float circle = distance(UV,vec2(0.5));
	float sq = tl.x * tl.y * br.x * br.y;
	float border = max((1.0 - sq), step(.52, circle));
	vec3 border_color = mix(PURPLE, WHITE, .0);
	vec3 square_color = mix(PURPLE, WHITE, .9 - circle);
	COLOR = vec4(square_color * sq * (1.0 - border) + border_color * border, 1.0);
}
