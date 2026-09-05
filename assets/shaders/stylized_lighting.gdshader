shader_type spatial;

uniform sampler2D albedo_texture : source_color;

uniform vec3 shadow_tint : source_color = vec3(0.35, 0.35, 0.40);
uniform vec3 mid_tint : source_color = vec3(0.70, 0.70, 0.75);
uniform vec3 light_tint : source_color = vec3(1.0, 1.0, 1.0);

uniform float shadow_threshold = 0.25;
uniform float light_threshold = 0.65;

void fragment() {
	ALBEDO = texture(albedo_texture, UV).rgb;
}

void light() {
	float ndotl = max(dot(NORMAL, LIGHT), 0.0);

	vec3 lighting;

	if (ndotl < shadow_threshold) {
		lighting = shadow_tint;
	}
	else if (ndotl < light_threshold) {
		lighting = mid_tint;
	}
	else {
		lighting = light_tint;
	}

	DIFFUSE_LIGHT += ALBEDO * lighting * ATTENUATION;
}