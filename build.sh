
FMK_NAME="A_IOSHelper"
FMK_VERSION=1.0

INSTALL_DIR=Product/${FMK_NAME}.framework

WRK_DIR=build
DEVICE_DIR=${WRK_DIR}/Release-iphoneos/${FMK_NAME}.framework
SIMULATOR_DIR=${WRK_DIR}/Release-iphonesimulator/${FMK_NAME}.framework

xcodebuild -configuration "Release" -target "${FMK_NAME}" -sdk iphoneos IPHONEOS_DEPLOYMENT_TARGET='6.0' clean build
xcodebuild -configuration "Release" -target "${FMK_NAME}" -sdk iphonesimulator IPHONEOS_DEPLOYMENT_TARGET='6.0' clean build

if [ -d "${INSTALL_DIR}" ]
then
rm -rf "${INSTALL_DIR}"
fi

mkdir -p "${INSTALL_DIR}"
mkdir -p "${INSTALL_DIR}/Modules"
mkdir -p "${INSTALL_DIR}/Headers"

cp -R "${DEVICE_DIR}/Headers/" "${INSTALL_DIR}/Headers/"
cp -R "${DEVICE_DIR}/Modules/" "${INSTALL_DIR}/Modules/"
cp -R "${DEVICE_DIR}/Info.plist" "${INSTALL_DIR}/Info.plist"

lipo -create "${DEVICE_DIR}/${FMK_NAME}" "${SIMULATOR_DIR}/${FMK_NAME}" -output "${INSTALL_DIR}/${FMK_NAME}"
rm -r "${WRK_DIR}"

open Product
