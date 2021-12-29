#!/bin/bash

cd ./$(dirname $0)/.. 2> /dev/null

mkdir -p output_html/playbooks

grep changed= output_html/playbooks/*html | grep ok= | sed 's/^[^:]*\/\([^:]*\).html:/\1@/' | sed 's/$/<\/p>/' | awk -F '@' 'BEGIN {print "<table>"} {print "<tr><td><a href=\"playbooks/"$1".html\">"$1"</a></td><td>"$2"</td></tr>"} END { print "</table>"}'  > output_html/summerzie.html.tmp
mv output_html/summerzie.html.tmp output_html/summerzie.html

grep changed= output_html/playbooks/*html.previous | grep ok= | sed 's/^[^:]*\/\([^:]*\).html:/\1@/' | sed 's/$/<\/p>/' | awk -F '@' 'BEGIN {print "<table>"} {print "<tr><td><a href=\"playbooks/"$1".html\">"$1"</a></td><td>"$2"</td></tr>"} END { print "</table>"}'  > output_html/summerzie.html.previous

echo "playbook;host;global color;ok;changed;unreachable;failed;skipped;rescued;ignored" > output_html/summerzie.csv
cat output_html/summerzie.html | grep tr | sed 's/style="color/style>/' | sed 's/;">/:/' | sed 's/<[^>]*>//g'  | sed 's/=/:/g' | sed 's/:/;/g' | sed 's/ *; */;/g'  | sed 's/  */;/g' | awk -F ';' '{print $1";"$3";"$2";"$5";"$7";"$9";"$11";"$13";"$15";"$17}' >> output_html/summerzie.csv

echo "playbook;host;global color;ok;changed;unreachable;failed;skipped;rescued;ignored" > output_html/summerzie.csv.previous
cat output_html/summerzie.html.previous | grep tr | sed 's/style="color/style>/' | sed 's/;">/:/' | sed 's/<[^>]*>//g'  | sed 's/=/:/g' | sed 's/:/;/g' | sed 's/ *; */;/g'  | sed 's/  */;/g' | awk -F ';' '{print $1";"$3";"$2";"$5";"$7";"$9";"$11";"$13";"$15";"$17}' >> output_html/summerzie.csv.previous
