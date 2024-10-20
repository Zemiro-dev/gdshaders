shader_type canvas_item;

#include "res://shader/lib/glint.gdshaderinc"
#include "res://shader/data/theme.gdshaderinc"

float bar(float axis, float pos, vec2 dim, vec2 feather) {
	float top = 0.;
	if (feather[0] != 0.) {
		top = smoothstep(pos - dim[0] - feather[0], pos - dim[0], axis);
	} else {
		top = step(pos - dim[0], axis);
	}
	
	float bottom = 0.;
	if (feather[1] != 0.) {
		bottom = smoothstep(pos + dim[1] + feather[1], pos + dim[1], axis);
	} else {
		bottom = 1. - step(pos + dim[1], axis);
	}
	return min(top, bottom);
}

vec2 brickTile(vec2 _st, float _zoom){
    _st *= _zoom;
	
	

    // Here is where the offset is happening
    _st.x += (1. - step(1., mod(_st.y,2.0))) * .5 * sin(TIME);
    _st.x += step(1., mod(_st.y,2.0)) * -.5 * sin(TIME);

    return fract(_st);
}

float box(vec2 _st, vec2 _size){
    _size = vec2(0.5)-_size*0.5;
    vec2 uv = smoothstep(_size,_size+vec2(1e-4),_st);
    uv *= smoothstep(_size,_size+vec2(1e-4),vec2(1.0)-_st);
    return uv.x*uv.y;
}

void fragment() {
	//float skew_x_ammount = 0.;
	//vec2 skew = vec2(skew_x_ammount * UV.y + skew_x_ammount * -.5, 0.0);
	
	// Called for every pixel the material is visible on.
	//float wire = bar(UV.x +  .01*random(UV), .4, vec2(.05), vec2(.01)); //fuzzy	
	float highlight = bar(UV.y, .02, vec2(.018, .02), vec2(.002, 0.));
	float wire = bar(UV.y, .06, vec2(.02, .1 ), vec2(0., .002));
	float body = bar(UV.y, .06, vec2(0., 1.), vec2(0.));
	
	vec3 highlight_color =  mix(mix(PURPLE, WHITE, .5), YELLOW.rgb, .1) * highlight;
	highlight_color *= highlight;
	vec3 wire_color = PURPLE;
	wire_color *= wire;
	vec3 body_color = MONOLITH_BLACK;
	body_color *= body * (1.0 - wire);
	
	COLOR = vec4(highlight_color + wire_color + body_color, body + wire + highlight);
	
	//Brick
	//vec3 color = vec3(0.0);
	//vec2 st = brickTile(UV,5.0);
	//color = vec3(box(st,vec2(0.8)));
	//
	//COLOR = vec4(color, 1.0);
}
