shader_type canvas_item;

#include "lib/glint.gdshaderinc"
#include "data/theme.gdshaderinc"

uniform float barWidth : hint_range(0.0, 1.0) = 0.3;
//uniform float progress : hint_range(0.0, 1.0) = 0.2;

void fragment() {
	float progress = fract(TIME/3.0);
	//
	
	
	float body = 1.0 - circle(UV, .48, .01);
	float bar = (step((1.0 - barWidth)/2.0, UV.x) - step(1. - (1.0 - barWidth)/2.0, UV.x));
	float progressBar = bar * (step(1.0 - progress, UV.y)) * body;	
	float leftEye = polygon(scale(UV + vec2(.29, .20 ), .5, .5), 3);
	float rightEye = polygon(scale(UV + vec2(-.29, .20 ), .5, .5), 3);
	leftEye = 1. - step(.05, leftEye);
	rightEye = 1. - step(.05, rightEye);
	float eye = leftEye + rightEye;
	
	vec3 progressBarColor = RED * progressBar;
	vec3 eyeColor = eye * mix(YELLOW, RED, progress);
	vec3 bodyColor = BLUE * body * (1.0-bar) * (1.0-eye);
	vec3 barColor = mix(RED, YELLOW, .5) * (bar - progressBar);
	COLOR = vec4(progressBarColor + bodyColor + barColor + eyeColor, progressBar + body);
}
