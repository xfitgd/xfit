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
layout(set = 0, binding = 3) uniform UniformBufferObject3 {
    mat4 pre;
} pre;

//#extension GL_EXT_debug_printf : enable
layout(location = 0) in vec2 inPosition;
layout(location = 1) in vec2 inTexCoord;
layout(location = 0) out vec2 fragTexCoord;


void main() {
    gl_Position = pre.pre * proj.proj * view.view * model.model * vec4(inPosition, 0.0, 1.0);
    fragTexCoord = inTexCoord;
}