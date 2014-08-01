#!/bin/bash

#################################
#	plus7 dumper v0.2	#
#	(c) 2014 WTFPL		#
#	Nokius			#
#################################

logo="
  ___   _      _   _   ___   ____   ___    _   _   __  __   ___   ___   ___   
 | _ \ | |    | | | | / __| |__  | |   \  | | | | |  \/  | | _ \ | __| | _ \  
 |  _/ | |__  | |_| | \__ \   / /  | |) | | |_| | | |\/| | |  _/ | _|  |   /  
 |_|   |____|  \___/  |___/  /_/   |___/   \___/  |_|  |_| |_|   |___| |_|_\  

	v0.2
"


#variable
tmp0=/tmp/tmp0 # contains the webpage
tmp1=/tmp/tmp1 # contains the tmp json link
tmp2=/tmp/tmp2 # contains the needed json link
tmp3=/tmp/tmp3 # contains the link
tmp4=/tmp/tmp4 # contains the json data

#Text stuff
red='\e[0;31m'
NC='\e[0m'

#Check if curl is installed
if which curl >/dev/null; then

echo ""
printf "%*s" $COLUMNS | tr " " "#"
echo -e "$red$logo$NC"
printf "%*s" $COLUMNS | tr " " "#"

else
	echo -e "$red WARRNING!$NC"
	echo "you need curl to run this script"
	return
fi


#Code
#dig for the json file

echo "Enter the Arte plus 7 link"
read link

if [[ $link != *?autoplay=1* ]]
then
   echo -e "$red WARRNING!$NC"
   echo "Not a vaild plus 7 link"
   return
fi

#echo "lets do some magic :) "
curl -s $link -o $tmp0

#loocking for the for the .json file

grep -E -m1 -o 'http://arte.tv/papi/tvguide/videos/stream/player/[^ ]+PLUS7[^"]+' $tmp0 >$tmp1
if [ $? -eq 1 ]  
then
        echo -e "$red WARRNING!$NC"
        echo "Needed link is missing"
        return
fi

#delete /player/ in link

sed s/\\/player// $tmp1 > $tmp2

#add url= to link file

sed 's/^/url= /g' $tmp2 > $tmp3

#grep the json file

curl -s -K $tmp3 -o $tmp4

printf "%*s" $COLUMNS | tr " " "#"

#looking for the links in json file
streamname=$(grep -o 'VTI":"[^:]*","VDU"' $tmp4 | sed s/VTI\"\\:\//  | sed s/\"\//| sed s/\"\.*\"\//)
filename=$(grep -o 'VTR":"http:[^:]*"' $tmp4  | sed 's:.*/::g'| sed 's:".*"::g' | sed s/-/\\_/g)
echo "Wich quality of '$streamname' you like to download?"
echo " 1) 200p 2) 406p 3) 720p 4) QUIT"
read n
case $n in
    1) link=$(grep -o 'http://artestras.vo.llnwxd.net/o35/nogeo/HBBTV/[^:]*MP4-800_AMM-HBBTV.mp4' $tmp4)
	echo "Where to save the file?"
	echo "e.g. /home/username"
	read filepath
	printf "%*s" $COLUMNS | tr " " "#"
	curl -o $filepath/$filename.mp4 $link
	echo " $streamname is saved at $filepath/$filename.mp4"
;;
    2) link=$(grep -o 'http://artestras.vo.llnwxd.net/o35/nogeo/HBBTV/[^:]*MP4-1500_AMM-HBBTV.mp4' $tmp4)
        echo "Where to save the file?"
        echo "e.g. /home/username"
        read filepath
        printf "%*s" $COLUMNS | tr " " "#"
        curl -o $filepath/$filename.mp4 $link
        echo " $streamname is saved at $filepath/$filename.mp4"
;;
    3) link=$(grep -o 'http://artestras.vo.llnwxd.net/o35/nogeo/HBBTV/[^:]*MP4-2200_AMM-HBBTV.mp4' $tmp4)
        echo "Where to save the file?"
        echo "e.g. /home/username"
        read filepath
        printf "%*s" $COLUMNS | tr " " "#"
        curl -o $filepath/$filename.mp4 $link
        echo " $streamname is saved at $filepath/$filename.mp4"
;;
    4) echo "Goodbye" 
	rm $tmp0 $tmp1 $tmp2 $tmp3 $tmp4
	streamname=""
	filename= ""
	filepath= ""
	return
;;
    *) 	echo "invalid option"
	rm $tmp0 $tmp1 $tmp2 $tmp3 $tmp4
	streamname=""
	filename= ""
	filepath= ""
	return
;;
esac

printf "%*s" $COLUMNS | tr " " "#"

#clean up

rm $tmp0 $tmp1 $tmp2 $tmp3 $tmp4
streamname=""
filename= ""
filepath= ""

return
