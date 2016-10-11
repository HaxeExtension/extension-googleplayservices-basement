#!/bin/bash

: ${ANDROID_SDK?"No ANDROID_SDK environment variable set. You can set it first with e.g. : export ANDROID_SDK=~/SDKs/android-sdk/"}

GMSPATH=$ANDROID_SDK"/extras/google/m2repository/com/google/android/gms/*"
DEPPATH="./dependencies/"

GMSFILES=()
GMSSELECTED=()
GMSPRESELECTED=("google-play-services-basement" "google-play-services-ads-lite" "google-play-services-auth" "google-play-services-base" "google-play-services-drive" "google-play-services-plus" "google-play-services-games" "google-play-services-gcm" "google-play-services-iid")



select_dependencies () {

  for f in $DEPPATH*
  do
     if [[ -d $f ]]; then GMSPRESELECTED+=("$(basename $f)"); fi;
  done

  # cycle through each gms dir
  a=0;
  for f in $GMSPATH
  do
     a=$((a+1));
     PACKAGENAME=$(basename $f)
     GMSFILES+=($PACKAGENAME)

     GMSSELECTED[$a]="*"
     if [[ " ${GMSPRESELECTED[@]} " =~ " google-${PACKAGENAME} " ]]; then
         GMSSELECTED[$a]="*"
     else
         GMSSELECTED[$a]=" "
     fi
     
  done


  while :
  do
      clear
    cat<<EOF

    ==============================
    Play Services Builder
    ------------------------------
    Select which services you'd like included:

EOF
  a=0;
  selected=0;
  for i in "${GMSFILES[@]}"
  do
     a=$((a+1));
     if  (($a < 10))
        then
           echo "     ["${GMSSELECTED[$a]}"0$a] google-"$i" "
     else
           echo "     ["${GMSSELECTED[$a]}"$a] google-"$i" "
     fi
     if  [[ "${GMSSELECTED[$a]}" == "*" ]]; then selected=$((selected+1)) ; fi
  done
cat<<EOF

     [ **] Select all
     [ CO] Continue
     [ QQ] Quit

    ------------------------------
    $selected Packages selected

    Select option or press [Enter] to continue
EOF
      read -n2

  a=0;
  for i in "${GMSFILES[@]}"
  do
     a=$((a+1));
     if [[ "$REPLY" == "$a" || "$REPLY" == "0$a" ]]; then

        if [ "${GMSSELECTED[$a]}" == "*" ]; then
           GMSSELECTED[$a]=" " ; REPLY="unselected"
        elif [ "${GMSSELECTED[$a]}" == " " ]; then
           GMSSELECTED[$a]="*" ; REPLY="selected"
        fi 
        
     fi

     if [[ "$REPLY" == "a" || "$REPLY" == "**" || "$REPLY" == "*" || "$REPLY" == "A" || "$REPLY" == "al" || "$REPLY" == "AL" ]]; then
        GMSSELECTED[$a]="*" ;
     fi
  done

  if [[ "$REPLY" == "a" || "$REPLY" == "**" || "$REPLY" == "*" || "$REPLY" == "A" || "$REPLY" == "al" || "$REPLY" == "AL" ]]; then
     REPLY="selected"
  fi

      case "$REPLY" in
        "selected")  echo "selected" ;;
        "unselected")  echo "unselected" ;;
        "")  update_dependencies ;;
        " ")  update_dependencies  ;;
        "CO")  update_dependencies                      ;;
        "co")  update_dependencies                      ;;
        "QQ")  echo "aborted"; exit                      ;;
        "qq")  echo "aborted"; exit   ;; 
        * )  echo "'"$REPLY"' is an invalid option"     ;;
      esac
      if [[ "$REPLY" != "selected" && "$REPLY" != "unselected" ]]; then sleep 1; fi
  done
}


update_dependencies () {
  PACKAGES=""
  a=0;
  for i in "${GMSFILES[@]}"
  do
     a=$((a+1));
     if [ "${GMSSELECTED[$a]}" == "*" ]; then
      PACKAGES=$PACKAGES" google-$i"
     fi
  done
  #echo $PACKAGES
  ./update_dependencies.sh $PACKAGES
  exit
} 

select_dependencies
