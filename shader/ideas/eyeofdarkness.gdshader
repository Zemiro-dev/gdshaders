shader_type canvas_item;

#include "res://shader/lib/glint.gdshaderinc"
#include "res://shader/data/theme.gdshaderinc"

float bar(float axis, float pos, vec2 dim, vec2 feather) {
	float top = smoothstep(pos - dim[0] - feather[0], pos - dim[0], axis);
	float bottom = smoothstep(pos + dim[1] + feather[1], pos + dim[1], axis);
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
	// Called for every pixel the material is visible on.
	float wire = bar(UV.y + .01*random(UV), .4, vec2(.05), vec2(.01));
	vec3 wire_color = PURPLE * wire;
	
	
	vec2 orbuv = vec2(UV.x + sin(TIME) * .3, UV.y + .1);
	float inner_shell = 1. - circle(orbuv, .1, .02);
	vec3 inner_shell_color = mix(WHITE, RED.rgb, .25) * inner_shell;
	
	float outer_shell = (1. - circle(orbuv, .13 , .05)) * (1. - inner_shell);
	vec3 outer_shell_color = RED.rgb * outer_shell;
	
	float glow = (1. - circle(orbuv, .18 , .3 )) * (1. - inner_shell) * (1. - outer_shell);
	vec3 glow_color = mix(WHITE, RED.rgb, .7) * glow;
	glow = glow / (2.0 + sin(TIME*2.) * .5);
	vec3 orb = (outer_shell_color + inner_shell_color) * wire + glow_color;
	
	COLOR = vec4(wire_color * orb*1.1, 1.0);
	
	//Brick
	//vec3 color = vec3(0.0);
	//vec2 st = brickTile(UV,5.0);
	//color = vec3(box(st,vec2(0.8)));
	//
	//COLOR = vec4(color, 1.0);
}
