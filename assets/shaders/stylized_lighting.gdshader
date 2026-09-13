shader_type spatial;

uniform sampler2D albedo_texture : source_color, filter_linear_mipmap;

uniform float shadow_threshold : hint_range(0.0, 1.0) = 0.3;
uniform float light_threshold : hint_range(0.0, 1.0) = 0.7;

uniform float shadow_strength : hint_range(0.0, 1.0) = 0.35;
uniform float mid_strength : hint_range(0.0, 1.0) = 0.65;


void fragment() {
	ALBEDO = texture(albedo_texture, UV).rgb;
}


void light() {
	float ndotl = max(dot(NORMAL, LIGHT), 0.0);

	float lighting;

	if (ndotl < shadow_threshold) {
		lighting = shadow_strength;
	}
	else if (ndotl < light_threshold) {
		lighting = mid_strength;
	}
	else {
		lighting = 1.0;
	}

	DIFFUSE_LIGHT += ALBEDO * LIGHT_COLOR * lighting * ATTENUATION;
}
