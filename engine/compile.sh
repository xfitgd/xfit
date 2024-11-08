#!/bin/sh

ENGINE_DIR=$1
OUT_DIR=$2
PLATFORM=$3
ANDROID_PATH=$4
ANDROID_VER=$5
ANDROID_BUILD_TOOL_VER=$6
ANDROID_KEY_STORE=$7
WORK_DIR=$8
ARCH=$9

if [ "$PLATFORM" = "android" ]
then
    if [ ! - "$OUT_DIR" ]; then
        mkdir $OUT_DIR
    fi
    "${ANDROID_PATH}/build-tools/${ANDROID_BUILD_TOOL_VER}/aapt2" compile --dir res -o "${OUT_DIR}/res.zip"
    "${ANDROID_PATH}/build-tools/${ANDROID_BUILD_TOOL_VER}/aapt2" link -o "${OUT_DIR}/output.apk" -I "${ANDROID_PATH}/platforms/android-${ANDROID_VER}/android.jar" "${OUT_DIR}/res.zip" --java . --manifest "${WORK_DIR}/AndroidManifest.xml"
    zip -r "${OUT_DIR}/output.apk" "lib/x86_64/"
    zip -r "${OUT_DIR}/output.apk" "lib/arm64-v8a/"
    zip -r "${OUT_DIR}/output.apk" "lib/riscv64/"
    zip -r "${OUT_DIR}/output.apk" "assets/"
    "${ANDROID_PATH}/build-tools/${ANDROID_BUILD_TOOL_VER}/zipalign" -p -f -v 4 "${OUT_DIR}/output.apk" "${OUT_DIR}/unsigned.apk"
    "${ANDROID_PATH}/build-tools/${ANDROID_BUILD_TOOL_VER}/apksigner" sign --ks "${WORK_DIR}/${ANDROID_KEY_STORE}" --ks-pass pass:android --out "${OUT_DIR}/signed.apk" "${OUT_DIR}/unsigned.apk"
fi

