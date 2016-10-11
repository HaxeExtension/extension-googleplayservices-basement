#!/bin/bash
dir=`dirname "$0"`
cd "$dir"
rm -f extension-googleplayservices-basement.zip
zip -0r extension-googleplayservices-basement.zip haxelib.json include.xml dependencies template select_dependencies.sh update_dependencies.sh
