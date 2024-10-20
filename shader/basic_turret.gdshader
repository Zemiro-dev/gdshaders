shader_type canvas_item;

#include "lib/glint.gdshaderinc"
#include "data/theme.gdshaderinc"

uniform float barWidth : hint_range(0.0, 1.0) = 0.3;
uniform float progress : hint_range(0.0, 1.0) = 0.2;
uniform bool is_grayscale = false;


float convert_to_grayscale(vec3 rgb) {
	float gray = dot(rgb, vec3(0.2126, 0.7152, 0.0722));
	return gray;
}

vec3 convert_color(vec3 rgb) {
	if (is_grayscale) {
		return vec3(convert_to_grayscale(rgb));
	}
	return rgb;
}


void fragment() {
	//float progress = fract(TIME/3.0);
	//


	float sharp_body = 1.0 - circle(UV, .48, .0);
	float feathered_body = 1.0 - circle(UV, .48, .01);
	float bar = (step((1.0 - barWidth)/2.0, UV.x) - step(1. - (1.0 - barWidth)/2.0, UV.x)) * sharp_body;
	float progressBar = bar * (step(1.0 - progress, UV.y)) * sharp_body;
	float leftEye = polygon(scale(UV + vec2(.29, .20 ), .5, .5), 3);
	float rightEye = polygon(scale(UV + vec2(-.29, .20 ), .5, .5), 3);
	leftEye = 1. - step(.05, leftEye);
	rightEye = 1. - step(.05, rightEye);
	float eye = leftEye + rightEye;

	vec3 progressBarColor = convert_color(RED.rgb) * progressBar;
	vec3 eyeColor = eye * convert_color(mix(YELLOW.rgb, RED.rgb, progress));
	vec3 bodyColor = PURPLE * feathered_body * (1.0-bar) * (1.0-eye);
	vec3 barColor = convert_color(ORANGE.rgb) * (bar - progressBar);
	COLOR = vec4(progressBarColor + bodyColor + barColor + eyeColor, progressBar + feathered_body);
}
