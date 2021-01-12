shader_type canvas_item;

uniform float cutoff : hint_range(0.0,1.0);
uniform sampler2D mask : hint_albedo;

void fragment()
{
	float value = texture(mask, UV).r;
	if(value < cutoff){
		COLOR = vec4(COLOR.rbg, 1.0);
	}
	if(value > cutoff){
		COLOR = vec4(COLOR.rbg, 0.0);
	}
}