
FMK_NAME="A_IOSHelper"

INSTALL_DIR=Product/${FMK_NAME}.framework

WRK_DIR=build
DEVICE_DIR=${WRK_DIR}/Release-iphoneos/${FMK_NAME}.framework
SIMULATOR_DIR=${WRK_DIR}/Release-iphonesimulator/${FMK_NAME}.framework

xcodebuild -configuration "Release" -arch arm64 -arch armv7 -arch armv7s only_active_arch=no defines_module=yes -target "${FMK_NAME}" -sdk iphoneos IPHONEOS_DEPLOYMENT_TARGET='8.0' clean build
xcodebuild -configuration "Release" -arch x86_64 -arch i386 only_active_arch=no defines_module=yes -target "${FMK_NAME}" -sdk iphonesimulator IPHONEOS_DEPLOYMENT_TARGET='8.0' clean build

if [ -d "${INSTALL_DIR}" ]
then
	rm -rf "${INSTALL_DIR}"
fi

mkdir -p "${INSTALL_DIR}"

cp -R "${DEVICE_DIR}"/* "${INSTALL_DIR}"
rm -rf "${INSTALL_DIR}/${FMK_NAME}"

lipo -create "${DEVICE_DIR}/${FMK_NAME}" "${SIMULATOR_DIR}/${FMK_NAME}" -output "${INSTALL_DIR}/${FMK_NAME}"
rm -r "${WRK_DIR}"

echo "==========================="
echo "========== INFO ==========="
echo "==========================="

lipo -info "${INSTALL_DIR}/${FMK_NAME}"

open Product
