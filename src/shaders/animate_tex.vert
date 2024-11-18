#version 450

layout(set = 0, binding = 0) uniform UniformBufferObject0 {
    mat4 model;
} model;
layout(set = 0, binding = 1) uniform UniformBufferObject1 {
    mat4 view;
} view;
layout(set = 0, binding = 2) uniform UniformBufferObject2 {
    mat4 proj;
} proj;

//#extension GL_EXT_debug_printf : enable
layout(location = 0) out vec2 fragTexCoord;

layout(set = 1, binding = 0) uniform sampler2DArray texSampler;

vec2 quad[6] = {
    vec2(-0.5,-0.5),
    vec2(0.5, -0.5),
    vec2(-0.5, 0.5),
    vec2(0.5, -0.5),
    vec2(0.5, 0.5),
    vec2(-0.5, 0.5)
};

void main() {
    gl_Position = proj.proj * view.view * model.model * vec4(quad[gl_VertexIndex] * vec2(textureSize(texSampler, 0)), 0.0, 1.0);
    fragTexCoord = (quad[gl_VertexIndex] + vec2(0.5,0.5)) * vec2(1,-1);
}