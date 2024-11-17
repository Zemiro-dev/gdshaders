shader_type canvas_item;

uniform vec4 target_color : source_color;

void fragment() {
	vec4 pixel_color = texture(TEXTURE, UV);
	float d = length(pixel_color.rgb - target_color.rgb);
	if (d < .1) {
		COLOR = vec4(mix(pixel_color.rgb, vec3(1.), (sin(TIME) + 1.) * .3  ), pixel_color.a);
	}
}
