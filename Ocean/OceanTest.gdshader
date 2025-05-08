// Godot Shading Language - Spatial Shader for a Distant Ocean
shader_type spatial;

// render_mode: As per Godot's documentation, 'unshaded' is the fastest
// as it doesn't involve any lighting calculations. Ideal for distant,
// stylized, or performance-critical surfaces.
// Alternatives for basic lighting: 'diffuse_lambert_vertex_lit' (per-vertex, faster) or
// 'diffuse_lambert' (per-pixel, more accurate but slower).
// For a very distant ocean, unshaded is often sufficient.
render_mode unshaded;

// Uniforms: These are parameters exposed to the Godot Editor's Inspector.
// Godot's shading language allows type hints (e.g., :source_color, :hint_range).
uniform vec4 base_color : source_color = vec4(0.1, 0.3, 0.7, 1.0); // The main color of the water
uniform sampler2D noise_texture_1 : source_color, filter_linear_mipmap, repeat_enable; // Seamless noise for wave pattern
uniform float wave_speed_1 : hint_range(0.0, 0.5, 0.01) = 0.02;    // Scroll speed for the first noise layer
uniform vec2 wave_direction_1 = vec2(1.0, 0.3);                   // Scroll direction (doesn't need to be normalized here, will be in code)
uniform float wave_scale_1 : hint_range(0.1, 20.0, 0.1) = 5.0;    // Tiling/scale of the first noise texture

uniform sampler2D noise_texture_2 : source_color, filter_linear_mipmap, repeat_enable; // Second noise layer for variation
uniform float wave_speed_2 : hint_range(0.0, 0.5, 0.01) = 0.03;
uniform vec2 wave_direction_2 = vec2(-0.4, 0.8);
uniform float wave_scale_2 : hint_range(0.1, 20.0, 0.1) = 7.5;

// wave_strength: Controls the amplitude of vertex displacement.
// For distant oceans, this should be very small or zero.
uniform float vertex_wave_strength : hint_range(0.0, 0.2, 0.005) = 0.01;
// color_noise_influence: How much the noise affects the final water color.
uniform float color_noise_influence : hint_range(0.0, 1.0, 0.01) = 0.08;


// Varyings can be used to pass data from vertex to fragment shader.
// For this simple shader, we recalculate noise in fragment for simplicity,
// but for more complex effects, passing it via varying would be better.
// varying vec2 scrolled_uv_1;
// varying vec2 scrolled_uv_2;

// Vertex processing function
void vertex() {
    // UV: Built-in variable for the mesh's texture coordinates.
    vec2 base_uv = UV;

    // Calculate scrolled UVs for both noise textures
    // TIME: Built-in global uniform for elapsed time.
    // normalize(): Ensures direction vector has a length of 1, for consistent speed.
    vec2 uv1_offset = normalize(wave_direction_1) * TIME * wave_speed_1;
    vec2 scrolled_uv1 = base_uv * wave_scale_1 + uv1_offset;

    vec2 uv2_offset = normalize(wave_direction_2) * TIME * wave_speed_2;
    vec2 scrolled_uv2 = base_uv * wave_scale_2 + uv2_offset;

    // Sample noise textures using the texture() built-in.
    // We use the .r (red) channel, assuming grayscale noise.
    float noise_value_1 = texture(noise_texture_1, scrolled_uv1).r;
    float noise_value_2 = texture(noise_texture_2, scrolled_uv2).r;

    // Combine noise for a more varied pattern.
    // (noise_value_1 * noise_value_2) can also create interesting patterns.
    float combined_noise = (noise_value_1 + noise_value_2) * 0.5;

    // VERTEX: Built-in variable representing vertex position in model space.
    // Optionally displace vertices along the Y-axis (upwards/downwards).
    // (combined_noise - 0.5) centers the displacement around zero.
    if (vertex_wave_strength > 0.0) {
        VERTEX.y += (combined_noise - 0.5) * vertex_wave_strength;
    }

    // Example of passing data to fragment shader if needed:
    // scrolled_uv_1_varying = scrolled_uv1; // Assign to a declared varying
}

// Fragment processing function
void fragment() {
    // Re-calculate scrolled UVs for fragment. If performance becomes an issue
    // and these are identical to vertex calculations, pass via varyings.
    // However, for distant simple ocean, direct calculation here is often fine.
    vec2 base_uv = UV;
    vec2 uv1_offset = normalize(wave_direction_1) * TIME * wave_speed_1;
    vec2 scrolled_uv1 = base_uv * wave_scale_1 + uv1_offset;

    vec2 uv2_offset = normalize(wave_direction_2) * TIME * wave_speed_2;
    vec2 scrolled_uv2 = base_uv * wave_scale_2 + uv2_offset;

    float noise_value_1 = texture(noise_texture_1, scrolled_uv1).r;
    float noise_value_2 = texture(noise_texture_2, scrolled_uv2).r;
    float combined_noise = (noise_value_1 + noise_value_2) * 0.5;

    // ALBEDO: Built-in output for the material's base color.
    // Modulate the base_color by the combined_noise for visual texture.
    vec3 final_color = base_color.rgb - (combined_noise * color_noise_influence);
    ALBEDO = final_color;

    // ALPHA: Built-in output for transparency.
    ALPHA = base_color.a;

    // For an unshaded material, other outputs like METALLIC, ROUGHNESS, EMISSION
    // are typically not used or have minimal effect unless specific render modes are chosen.
}