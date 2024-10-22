@echo off

set ENGINE_DIR=%1

set shader_list=tex shape_curve quad_shape animate_tex

if not exist "%ENGINE_DIR%/shaders/out" mkdir "%ENGINE_DIR%/shaders/out"

for %%a in (%shader_list%) do ( 
    glslc %ENGINE_DIR%/shaders/%%a.vert -O -o %ENGINE_DIR%/shaders/out/%%a_vert.spv
    glslc %ENGINE_DIR%/shaders/%%a.frag -O -o %ENGINE_DIR%/shaders/out/%%a_frag.spv
)

 glslc %ENGINE_DIR%/shaders/screen_copy.frag -O -o %ENGINE_DIR%/shaders/out/screen_copy_frag.spv