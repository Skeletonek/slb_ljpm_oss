shader_type canvas_item;

uniform bool apply;
uniform float blur_amount : hint_range(-2.0, 10.0);
uniform float mix_amount : hint_range(0.0, 1.0);
uniform vec4 color_over;
uniform vec4 color_not_applied;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture , filter_linear_mipmap;

void fragment() {
	if(apply) {
		vec4 blurred = textureLod(SCREEN_TEXTURE, SCREEN_UV, blur_amount);
		vec4 fin = mix(blurred, color_over, mix_amount);
		COLOR = fin;
	}
	else {
		COLOR = color_not_applied;
	}
}
