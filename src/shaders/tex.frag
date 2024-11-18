#version 450

layout(set = 0, binding = 3) uniform UniformBufferObject4 {
    mat4 mat;
} colormat;
layout(set = 1, binding = 0) uniform sampler2D texSampler;

layout(location = 0) in vec2 fragTexCoord;
layout(location = 0) out vec4 outColor;

void main() {
    outColor = colormat.mat * texture(texSampler, fragTexCoord);
}