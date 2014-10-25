
MY_PROJECT_NAME="A-IOSHelper.xcodeproj"

MY_TARGET_NAME="A-IOSHelper"

MY_STATIC_LIB="lib${PROJECT_NAME}.a"

LIB_DIR = 'tmp/'

if [ ! -d "${LIB_DIR}" ]; then
  mkdir -p "${LIB_DIR}"
fi 

# armv7 armv7s
 
MY_ARMV7_BUILD_PATH='temp/armv7'
MY_CURRENT_BUILD_PATH="${MY_ARMV7_BUILD_PATH}"
 
xcodebuild -project "${MY_PROJECT_NAME}" -target "${MY_TARGET_NAME}" -configuration 'Release'  -sdk iphoneos CONFIGURATION_BUILD_DIR="${MY_CURRENT_BUILD_PATH}" ARCHS='armv7 armv7s'  VALID_ARCHS='armv7 armv7s' IPHONEOS_DEPLOYMENT_TARGET='5.0' clean build

#MY_ARMV7S_BUILD_PATH='temp/armv7S'
#MY_CURRENT_BUILD_PATH="${MY_ARMV7S_BUILD_PATH}"
 
#xcodebuild -project "${MY_PROJECT_NAME}" -target "${MY_TARGET_NAME}" -configuration 'Release'  -sdk iphoneos CONFIGURATION_BUILD_DIR="${MY_CURRENT_BUILD_PATH}" ARCHS='armv7s'  VALID_ARCHS='armv7s' IPHONEOS_DEPLOYMENT_TARGET='5.0' clean build
 
# arm64  
 
MY_ARM64_BUILD_PATH='temp/arm64'
MY_CURRENT_BUILD_PATH="${MY_ARM64_BUILD_PATH}"
 
xcodebuild -project "${MY_PROJECT_NAME}" -target "${MY_TARGET_NAME}" -configuration 'Release' -sdk iphoneos CONFIGURATION_BUILD_DIR="${MY_CURRENT_BUILD_PATH}" ARCHS='arm64' IPHONEOS_DEPLOYMENT_TARGET='7.0'  clean build
 
# i386
MY_I386_BUILD_PATH='temp/i386'
MY_CURRENT_BUILD_PATH="${MY_I386_BUILD_PATH}"
 
xcodebuild -project "${MY_PROJECT_NAME}" -target "${MY_TARGET_NAME}" -configuration 'Release' -sdk iphonesimulator CONFIGURATION_BUILD_DIR="${MY_CURRENT_BUILD_PATH}" ARCHS='i386' VALID_ARCHS='i386' IPHONEOS_DEPLOYMENT_TARGET='5.0' clean build
 
# x86_64 
 
MY_X86_64_BUILD_PATH='temp/x86_64'
MY_CURRENT_BUILD_PATH="${MY_X86_64_BUILD_PATH}"
 
xcodebuild -project "${MY_PROJECT_NAME}" -target "${MY_TARGET_NAME}" -configuration 'Release' -sdk iphonesimulator CONFIGURATION_BUILD_DIR="${MY_CURRENT_BUILD_PATH}" ARCHS='x86_64' VALID_ARCHS='x86_64' IPHONEOS_DEPLOYMENT_TARGET='7.0' clean build
 

MY_TARGET_NAME="${MY_TARGET_NAME}"

MY_STATIC_LIB="lib${MY_TARGET_NAME}.a"
 

MY_FINAL_BUILD_PATH='lib/'

if [ ! -d "${MY_FINAL_BUILD_PATH}" ]; then
  mkdir -p "${MY_FINAL_BUILD_PATH}"
fi
 

#lipo -create "${MY_ARMV7_BUILD_PATH}/${MY_STATIC_LIB}" "${MY_ARMV7S_BUILD_PATH}/${MY_STATIC_LIB}" "${MY_ARM64_BUILD_PATH}/${MY_STATIC_LIB}" "${MY_I386_BUILD_PATH}/${MY_STATIC_LIB}" "${MY_X86_64_BUILD_PATH}/${MY_STATIC_LIB}" -output "${MY_FINAL_BUILD_PATH}${MY_STATIC_LIB}"
lipo -create "${MY_ARMV7_BUILD_PATH}/${MY_STATIC_LIB}" "${MY_ARM64_BUILD_PATH}/${MY_STATIC_LIB}" "${MY_I386_BUILD_PATH}/${MY_STATIC_LIB}" "${MY_X86_64_BUILD_PATH}/${MY_STATIC_LIB}" -output "${MY_FINAL_BUILD_PATH}${MY_STATIC_LIB}"



rm -rf 'temp'
rm -rf 'build'

 
open "${MY_FINAL_BUILD_PATH}"