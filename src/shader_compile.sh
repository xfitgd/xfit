#!/bin/sh

ENGINE_DIR=$1

shader_list="tex shape_curve quad_shape animate_tex"

if [ ! -d "${ENGINE_DIR}/shaders/out" ]
then
    mkdir "${ENGINE_DIR}/shaders/out"
fi

for i in $shader_list
do
glslc "${ENGINE_DIR}/shaders/${i}.vert" -O -o "${ENGINE_DIR}/shaders/out/${i}_vert.spv"
glslc "${ENGINE_DIR}/shaders/${i}.frag" -O -o "${ENGINE_DIR}/shaders/out/${i}_frag.spv"
done

glslc "${ENGINE_DIR}/shaders/screen_copy.frag" -O -o "${ENGINE_DIR}/shaders/out/screen_copy_frag.spv"