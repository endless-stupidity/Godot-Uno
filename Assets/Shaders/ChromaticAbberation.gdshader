shader_type canvas_item;

uniform vec2 r_displacement = vec2(3.0, 0.0);
uniform vec2 g_displacement = vec2(0.0, 0.0);
uniform vec2 b_displacement = vec2(-3.0, 0.0);
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

uniform float noise_amount = 40.0;

void fragment()
{
	float r = texture(SCREEN_TEXTURE, SCREEN_UV + vec2(SCREEN_PIXEL_SIZE*r_displacement), 0.0).r;
	float g = texture(SCREEN_TEXTURE, SCREEN_UV + vec2(SCREEN_PIXEL_SIZE*g_displacement), 0.0).g;
	float b = texture(SCREEN_TEXTURE, SCREEN_UV + vec2(SCREEN_PIXEL_SIZE*b_displacement), 0.0).b;
	COLOR = vec4(r, g, b, 1.0);
	
	vec2 uv = UV*0.05;
	float a = fract(sin(dot(UV, vec2(12.9898, 78.233) * TIME)) * 438.5453) * 1.9;
	vec4 col = texture(TEXTURE, UV);
	col.a *= pow(a, noise_amount);
	COLOR.a = col.a;
}