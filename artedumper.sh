#!/bin/bash

#################################
#     	Arte dumper v0.1	      #
#	    (c)	2014   WTFPL	        #
#	          Nokius	            #
#################################

#variable
tmp0=/tmp/artetmp0  # contains the webpage
tmp1=/tmp/artetmp1  # contains the tmp json link
tmp2=/tmp/artetmp2  # contains the needed json link
tmp3=/tmp/artetmp3  # contains the link
tmp4=/tmp/artetmp4  # contains the json data


#Code
#dig for the json file

echo    "Enter the Arte plus 7 link"
read    link
echo    "lets do some magic :) "
curl -s $link  -o $tmp0

#loocking for the for the .json file

grep -E -m1 -o 'http://arte.tv/papi/tvguide/videos/stream/player/D/[^ ]+PLUS7[^"]+' $tmp0 >$tmp1

#delete /player/ in link

sed  s/\\/player// $tmp1 > $tmp2

#add url= to link file

sed 's/^/url= /g' $tmp2 > $tmp3

#grep the json file

curl -s -K $tmp3 -o $tmp4

echo    "####################################"
echo    "the links you want"

#looking for the links in json file

grep -o "http://artestras.vo.llnwxd.net/o35/nogeo/HBBTV/[^:]*mp4" $tmp4

echo    "####################################"

#clean up

rm /tmp/artetmp*

exit 0
