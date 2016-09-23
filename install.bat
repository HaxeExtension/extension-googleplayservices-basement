@echo off
SET dir=%~dp0
cd %dir%
haxelib remove extension-googleplayservices-basement
haxelib local extension-googleplayservices-basement.zip
