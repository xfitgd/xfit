@echo off

set ENGINE_DIR=%1
set OUT_DIR=%2
set PLATFORM=%3
set ANDROID_PATH=%4
set ANDROID_VER=%5
set ANDROID_BUILD_TOOL_VER=%6
set WORK_DIR=%7
set ARCH=%8

IF "%PLATFORM%" == "android" (
    if not exist "%OUT_DIR%" mkdir "%OUT_DIR%"
    "%ANDROID_PATH%/build-tools/%ANDROID_BUILD_TOOL_VER%/aapt2" compile --dir res -o %OUT_DIR%/res.zip
    "%ANDROID_PATH%/build-tools/%ANDROID_BUILD_TOOL_VER%/aapt2" link -o %OUT_DIR%/output.apk -I %ANDROID_PATH%/platforms/android-%ANDROID_VER%/android.jar %OUT_DIR%/res.zip --java . --manifest %WORK_DIR%/AndroidManifest.xml
    IF "%ARCH%" == "aarch64" (
        call :ZIP_APK "%ENGINE_DIR%/zip_aarch64.exe"
    ) ELSE (
        call :ZIP_APK "%ENGINE_DIR%/zip_x86_64.exe"
    )
    "%ANDROID_PATH%/build-tools/%ANDROID_BUILD_TOOL_VER%/zipalign" -p -f -v 4 %OUT_DIR%/output.apk %OUT_DIR%/unsigned.apk
    "%ANDROID_PATH%/build-tools/%ANDROID_BUILD_TOOL_VER%/apksigner" sign --ks %WORK_DIR%/debug.keystore --ks-pass pass:android --out %OUT_DIR%/signed.apk %OUT_DIR%/unsigned.apk
)

exit

:ZIP_APK
    "%~1" -r %OUT_DIR%/output.apk lib/x86_64/
    "%~1" -r %OUT_DIR%/output.apk lib/arm64-v8a/
    "%~1" -r %OUT_DIR%/output.apk lib/riscv64/
    "%~1" -r %OUT_DIR%/output.apk assets/

