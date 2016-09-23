#!/bin/bash
dir=`dirname "$0"`
cd "$dir"
haxelib remove extension-googleplayservices-basement
haxelib local extension-googleplayservices-basement.zip
