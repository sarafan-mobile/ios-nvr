if [ "${CONFIGURATION}" != "Debug" ]; then
     find ${DWARF_DSYM_FOLDER_PATH} -name "*.dSYM" | xargs -I \{\} Tuist/Dependencies/SwiftPackageManager/.build/checkouts/firebase-ios-sdk/Crashlytics/upload-symbols -gsp $SCRIPT_INPUT_FILE_0 -p ios \{\}
fi