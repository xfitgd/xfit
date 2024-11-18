#version 450

layout(location = 0) out vec4 outColor;

layout(binding = 0) uniform UniformBufferObject0 {
    vec4 color;
} cor;

void main() {
    outColor = cor.color;
}