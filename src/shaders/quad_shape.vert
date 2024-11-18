#version 450

vec2 quad[6] = {
    vec2(-1,-1),
    vec2(1, -1),
    vec2(-1, 1),
    vec2(1, -1),
    vec2(1, 1),
    vec2(-1, 1)
};

void main() {
    gl_Position = vec4(quad[gl_VertexIndex], 0.0, 1.0);
}