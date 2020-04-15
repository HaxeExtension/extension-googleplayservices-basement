# extension-googleplayservices-basement

OpenFL extension that simply adds Google Play Services Basement into your project [for android targets].

This library does not provide any functionality, since it's intended to be used by other libraries (such as Google Play Games, and Google AdMob).

### How to Install

To install this library, you can simply get the library from haxelib like this:
```bash
haxelib install extension-googleplayservices-basement
```

### How to use this to build an extension

If you're developing extensions or implementing features that requires Google Play Services library, you just need to add something like this to your project.xml.
```xml
<set name="google-play-services-basement" />
<set name="google-play-services-games" />
<set name="google-play-services-base" />
<set name="google-play-services-plus" />
<set name="google-play-services-drive" />
<set name="google-play-services-auth" />
<set name="google-play-services-ads-lite" />
<haxelib name="extension-googleplayservices-basement" />
```


Also, if you're building an extension that contains an Android Library, you may need to add the following line to your project.properties
```
android.library.reference.2=../google-play-services-basement
```

here is an example on how may your project.properties should look like:

```
android.library=true
target=android-::ANDROID_TARGET_SDK_VERSION::
android.library.reference.1=../extension-api
android.library.reference.2=../google-play-services-basement
android.library.reference.3=../google-play-services-plus
android.library.reference.4=../google-play-services-drive
android.library.reference.5=../google-play-services-games
android.library.reference.6=../google-play-services-base
android.library.reference.7=../google-play-services-auth
android.library.reference.8=../google-play-services-ads-lite

```

### Adding more dependencies

If you need to add more dependencies, you can run `./select_dependencies.sh` and select the needed google play services libraries from the list. These will become available afterwards as per above method.

### Updating dependencies

If you need to update the libraries, simply run `./update_dependencies.sh`

### Disclaimer

Google is a registered trademark of Google Inc.
http://unibrander.com/united-states/140279US/google.html


### License

The MIT License (MIT) - [LICENSE.md](LICENSE.md)

Copyright &copy; 2016 SempaiGames (http://www.sempaigames.com)

Author: Federico Bricker
