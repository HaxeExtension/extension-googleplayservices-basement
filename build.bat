@echo off
SET dir=%~dp0
cd %dir%
if exist extension-googleplayservices-basement.zip del /F extension-googleplayservices-basement.zip
winrar a -afzip extension-googleplayservices-basement.zip haxelib.json include.xml dependencies
pause