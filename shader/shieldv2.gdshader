shader_type canvas_item;

#include "lib/glint.gdshaderinc"
#include "data/theme.gdshaderinc"

void fragment() {
	vec2 uv = UV / TEXTURE_PIXEL_SIZE;
	float mainShield = shield(uv, .4, .025, .065);
	// the pow statement adds some white highlighting near the main ring   
	vec3 mainShieldColor = BLUE.rgb + (.08 * pow(mainShield, 10.0));
	COLOR = vec4(mainShieldColor, mainShield);
}
