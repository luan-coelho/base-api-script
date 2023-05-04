#!/bin/bash

read -p "Please inform the Group: " group
read -p "Please inform the Artifact: " artifact

url="https://code.quarkus.io/d?g=${group}&a=${artifact}&b=GRADLE&nc=true&cn=code.quarkus.io"

zip_file_name="${artifact}.zip"
curl -o "${zip_file_name}" "${url}"

unzip "${zip_file_name}" > /dev/null 2>&1

rm "${zip_file_name}"

git clone "https://github.com/luan-coelho/api-base" > /dev/null 2>&1

rm -rf "${artifact}/src"
cp -R "api-base/src" "${artifact}/"

cp "api-base/build.gradle" "${artifact}/build.gradle"

rm -rf "api-base"

original_package="com.baseapi"
new_package=${group//./\/}

mkdir -p "${artifact}/src/main/java/${new_package}"
mv "${artifact}/src/main/java/${original_package//./\/}/" "${artifact}/src/main/java/${new_package}/"
rmdir -p "${artifact}/src/main/java/${original_package//./\/}" 2> /dev/null || true

mkdir -p "${artifact}/src/test/java/${new_package}"
mv "${artifact}/src/test/java/${original_package//./\/}/" "${artifact}/src/test/java/${new_package}/"
rmdir -p "${artifact}/src/test/java/${original_package//./\/}" 2> /dev/null || true

find "${artifact}/src/main/java" -name "*.java" -exec sed -i "s|${original_package}|${group}|g" {} \;
find "${artifact}/src/test/java" -name "*.java" -exec sed -i "s|${original_package}|${group}|g" {} \;

rm -rf "${artifact}/src/main/java/com"
rm -rf "${artifact}/src/test/java/com"

echo "Successfully built project"
