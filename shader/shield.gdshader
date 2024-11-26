shader_type canvas_item;

uniform sampler2D noise1 : repeat_enable;
uniform sampler2D noise2 : repeat_enable;
uniform float strength;
uniform float fps;
uniform int frames = 256;

//normalized
float clock(float time) {
	float fframes = float(frames);
	return floor(mod(time * fps, fframes)) / fframes;
}

void fragment() {
	float c = clock(TIME); //Get clock frame
	vec4 offset1 = texture(noise1, UV+c); //Get offset
	vec4 offset2 = texture(noise2,UV+c);
	vec4 offset = offset1*offset2*strength;
	//vec4 offset = vec4(0, 0, 0., 0.);
	//COLOR = texture(TEXTURE, vec2(UV.x,UV.y) + normal.xy); //Apply offset
	COLOR = texture(TEXTURE, UV + offset.xy - vec2(.5) * strength); //We need to remove the displacement
}
