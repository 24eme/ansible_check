#!/bin/bash

cd ./$(dirname $0)/.. 2> /dev/null

mkdir -p output_html/playbooks

grep changed= output_html/playbooks/*html | grep ok= | sed 's/^[^:]*\/\([^:]*\).html:/\1@/' | sed 's/$/<\/p>/' | awk -F '@' 'BEGIN {print "<table>"} {print "<tr><td><a href=\"playbooks/"$1".html\">"$1"</a></td><td>"$2"</td></tr>"} END { print "</table>"}'  > output_html/index.html.tmp
echo -n "<p>Last update: " >> output_html/index.html.tmp ; ls -lrt --full-time  output_html/playbooks/ | tail -n  1 | awk '{print $6" "$7}' >> output_html/index.html.tmp ; echo "</p>" >> output_html/index.html.tmp
mv output_html/index.html.tmp output_html/index.html

grep changed= output_html/playbooks/*html.previous | grep ok= | sed 's/^[^:]*\/\([^:]*\).html.previous:/\1@/' | sed 's/$/<\/p>/' | awk -F '@' 'BEGIN {print "<table>"} {print "<tr><td><a href=\"playbooks/"$1".html\">"$1"</a></td><td>"$2"</td></tr>"} END { print "</table>"}'  > output_html/index.html.previous

echo "playbook;host;global color;ok;changed;unreachable;failed;skipped;rescued;ignored" > output_html/playbooks.csv
cat output_html/index.html | grep tr | sed 's/style="color/style>/' | sed 's/;">/:/' | sed 's/<[^>]*>//g'  | sed 's/=/:/g' | sed 's/:/;/g' | sed 's/ *; */;/g'  | sed 's/  */;/g' | awk -F ';' '{print $1";"$3";"$2";"$5";"$7";"$9";"$11";"$13";"$15";"$17}' >> output_html/playbooks.csv

echo "playbook;host;global color;ok;changed;unreachable;failed;skipped;rescued;ignored" > output_html/playbooks.csv.previous
cat output_html/index.html.previous | grep tr | sed 's/style="color/style>/' | sed 's/;">/:/' | sed 's/<[^>]*>//g'  | sed 's/=/:/g' | sed 's/:/;/g' | sed 's/ *; */;/g'  | sed 's/  */;/g' | awk -F ';' '{print $1";"$3";"$2";"$5";"$7";"$9";"$11";"$13";"$15";"$17}' >> output_html/playbooks.csv.previous
