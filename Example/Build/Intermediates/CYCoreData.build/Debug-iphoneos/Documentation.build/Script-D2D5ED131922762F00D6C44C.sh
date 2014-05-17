#!/bin/sh
#appledoc Xcode script
# Start constants
company="cynicalcocoa";
companyID="com.cynicalcocoa";
companyURL="https://github.com/cynicalcocoa/cycoredata";
target="iphoneos";
#target="macosx";
outputPath="~/help";
# End constants
/usr/local/bin/appledoc \
--project-name "${PROJECT_NAME}" \
--project-company "${company}" \
--company-id "${companyID}" \
--docset-atom-filename "${company}.atom" \
--docset-feed-url "${companyURL}/${company}/%DOCSETATOMFILENAME" \
--docset-package-url "${companyURL}/${company}/%DOCSETPACKAGEFILENAME" \
--docset-fallback-url "${companyURL}/${company}" \
--output "../${PRODUCT_NAME}" \
--publish-docset \
--docset-platform-family "${target}" \
--logformat xcode \
--keep-intermediate-files \
--no-repeat-first-par \
--no-warn-invalid-crossref \
--exit-threshold 2 \
"${PROJECT_DIR}/../Classes"

