#version 450

layout(input_attachment_index = 0, binding = 0) uniform subpassInput u_color;
//layout(input_attachment_index = 1, binding = 1) uniform subpassInput u_depth;

layout(location = 0) out vec4 outColor;

void main() {
    outColor = subpassLoad(u_color);
}