#!/bin/bash

: ${ANDROID_SDK?"No ANDROID_SDK environment variable set. You can set it first with e.g. : export ANDROID_SDK=~/SDKs/android-sdk/"}

GMSPATH=$ANDROID_SDK"/extras/google/m2repository/com/google/android/gms/*"
DEPPATH="./dependencies/"
LIMITTO=()


if [[ $@ ]]
    then
        LIMITTO=( "$@" )
        for arg in "$@"
        do
            LIMITTO+=("$arg")
        done
        echo "Updating selected dependencies"
else
    for f in $DEPPATH*/
    do
        if [[ -d $f ]]; then LIMITTO+=("$(basename $f)"); fi;
    done
    if [[ -z "$LIMITTO" ]]; then echo "No dependencies found, run ./select_dependencies.sh instead"; exit;
    else echo "Updating existing dependencies"
    fi
fi


# clear old version
echo "Clearing dependencies"
rm -rf $DEPPATH*

# cycle through each gms dir
for f in $GMSPATH
do
    PACKAGENAME="google-"$(basename $f)
    HIGH_VER=`ls -d -v $f/*/ | tail -n 1`
    VERNUM="$(basename $HIGH_VER)"
    if [[ " ${LIMITTO[@]} " =~ " ${PACKAGENAME} " ]]; then
        echo "Adding $PACKAGENAME ($VERNUM)"
        AAR=`find $HIGH_VER -iname '*.aar' | sed s#//*#/#g`
        cp $AAR $DEPPATH"google-"$(basename $AAR)
        FILENAME=$DEPPATH"google-"$(basename $AAR)
        OUTDIR=$(echo ${FILENAME%.*})
        OUTDIR=${OUTDIR%-$VERNUM}

        #extract .aar file and delete it
        unzip -q $FILENAME -d $OUTDIR
        rm $FILENAME

        mkdir -p $OUTDIR/libs
        mkdir -p $OUTDIR/src
        mkdir -p $OUTDIR/res

        # if classes.jar exists move inside libs/ directory
    	if [ -f $OUTDIR/classes.jar ]; then
    	    mv $OUTDIR/classes.jar $OUTDIR/libs/classes.jar
    	fi

        ## remove proguard.txt (?)
        ## add build.xml
        cp template/build.xml $OUTDIR/build.xml
        ## add project.properties
        cp template/project.properties $OUTDIR/project.properties
    fi
done

echo "Writing include.xml"
cat << EOF > ./include.xml
<?xml version="1.0" encoding="utf-8"?>
<extension>
    <section if="android">
EOF
for f in $DEPPATH*/
do
    f=$(basename $f)
cat << EOF >> ./include.xml
        <dependency name="$f"
            path="dependencies/$f"
            if="$f" />
EOF
done
cat << EOF >> ./include.xml
    </section>
</extension>
EOF

echo "Done"