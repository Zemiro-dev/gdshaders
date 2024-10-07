shader_type canvas_item;

#include "lib/glint.gdshaderinc"
#include "data/theme.gdshaderinc"

uniform float star_rays = 1.0;
uniform float brightness1 : hint_range(0.0, 1.1, 0.1) = 1.0;
uniform float brightness2 : hint_range(-20.0, 50.0, 0.1) = 20.;
uniform float brightness3 : hint_range(-10.0, 20.0, 0.1) = 10.;

mat2 Rot(float a){
    float s= sin(a), c=cos(a);
    return mat2(vec2(c,-s),vec2(s,c));
}

float Star (vec2 uv, float size, float baseRotation) {
    float d = length(uv) * star_rays;
    float m = 0.
    // inverted circle
    +smoothstep(.12,0.15,d)/7. * (size)
    // glow
    +0.01/d *(size*brightness2 +brightness3);
    // circle
    // rotate 45 deg
    uv *= Rot(baseRotation);
    float rays = 0.;
    rays += (max(0.,1.-abs(pow(abs(uv.x),1.8)*uv.y*30000.))) ;
    
    // rotate 45 deg
    uv *= Rot(3.14159/4.);
    rays += (max(0.,1.-abs(uv.x*uv.y* 3000.))) * .7 ;
    m*= smoothstep(1.,0.2,d);
    m+= rays* smoothstep(1.,0.2,d/(size));;
    
    return m;
}

void fragment() {
	float star = Star(UV+vec2(-.5), .2, TIME*10.);
	COLOR = vec4(mix(BLUE, YELLOW, .1) * star, smoothstep(.01, 1., star));
}


