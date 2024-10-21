shader_type canvas_item;

#include "res://shader/lib/glint.gdshaderinc"
#include "res://shader/data/theme.gdshaderinc"

uniform float divisions : hint_range(4., 64., 1.) = 32.;
uniform float strengths[64];

void fragment() {
	vec2 toCenter = vec2(.5) - UV;
	float theta = atan(toCenter.y, toCenter.x) + PI;
	float radius = length(toCenter) * (2.1 + FUZZ*10.);
	float inner_radius = length(toCenter) * (2.2 + FUZZ*10.);
	
	
	float theta_step = 2. * PI / divisions;
	float division = 0.;
	for (float i = 0.0; i < divisions; i++) {
		division += i * step(i * theta_step, theta) * (1. - step((i+1.) * theta_step, theta));
	}
	float strength = strengths[int(division)];
	float next_strength = strengths[int(mod(float(division)+1., divisions))];
	float progression = (theta - (division * theta_step)) / theta_step;
	
	float test_radius = mix(strength, next_strength, progression); //TODO lerp is bad looking here do more
	
	float pct = 1. - smoothstep(test_radius,  test_radius+FUZZ*10., radius);
	float ipct = 1. - smoothstep(test_radius,  test_radius+FUZZ*10., inner_radius);
	pct -= ipct;
	
	COLOR = BLUE * pct;
	// Called for every pixel the material is visible on.
}