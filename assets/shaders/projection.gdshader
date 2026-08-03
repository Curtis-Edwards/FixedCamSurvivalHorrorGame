shader_type spatial;
render_mode unshaded;

uniform sampler2D projection_texture;

uniform mat4 projector_view;
uniform mat4 projector_projection;

varying vec3 world_pos;

void vertex() {
    world_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
}

void fragment() {

    // world → view space
    vec4 view_pos = projector_view * vec4(world_pos, 1.0);

    // view → clip space
    vec4 clip = projector_projection * view_pos;

    vec2 uv = clip.xy / clip.w;
	uv.y = -uv.y;
    uv = uv * 0.5 + 0.5;

    //ALBEDO = texture(projection_texture, uv).rgb;
	ALBEDO = pow(texture(projection_texture, uv).rgb, vec3(2.2));
}