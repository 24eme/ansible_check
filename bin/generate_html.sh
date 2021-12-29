#!/bin/bash

cd $(dirname $0)/.. 2> /dev/null

mkdir -p output_html/playbooks

grep changed= output_html/playbooks/*html | grep ok= | sed 's/^[^:]*\/\([^:]*\).html:/\1@/' | sed 's/$/<\/p>/' | awk -F '@' 'BEGIN {print "<table>"} {print "<tr><td><a href=\"playbooks/"$1".html\">"$1"</a></td><td>"$2"</td></tr>"} END { print "</table>"}'  > output_html/index.html.tmp
echo -n "<p>Last update: " >> output_html/index.html.tmp ; ls -lrt --full-time  output_html/playbooks/ | tail -n  1 | awk '{print $6" "$7}' >> output_html/index.html.tmp ; echo "</p>" >> output_html/index.html.tmp
running=$(ls output_html/playbooks/*html.running.htm 2> /dev/null | sed 's/.*playbooks.//' | sed 's/.html.running.htm//')
if test "$running"; then
echo "<p><a href='playbooks/"$running".html.running.htm'>"$running" currently checked</a></p>" >> output_html/index.html.tmp
fi
echo "<p><a href='feed.xml'>RSS Feed</p>" >> output_html/index.html.tmp
mv output_html/index.html.tmp output_html/index.html

grep changed= output_html/playbooks/*html.previous | grep ok= | sed 's/^[^:]*\/\([^:]*\).html.previous:/\1@/' | sed 's/$/<\/p>/' | awk -F '@' 'BEGIN {print "<table>"} {print "<tr><td><a href=\"playbooks/"$1".html\">"$1"</a></td><td>"$2"</td></tr>"} END { print "</table>"}'  > output_html/index.html.previous

echo "playbook;host;global color;ok;changed;unreachable;failed;skipped;rescued;ignored" > output_html/playbooks.csv
cat output_html/index.html | grep tr | sed 's/style="color/style>/' | sed 's/;">/:/' | sed 's/<[^>]*>//g'  | sed 's/=/:/g' | sed 's/:/;/g' | sed 's/ *; */;/g'  | sed 's/  */;/g' | awk -F ';' '{print $1";"$3";"$2";"$5";"$7";"$9";"$11";"$13";"$15";"$17}' >> output_html/playbooks.csv

echo "playbook;host;global color;ok;changed;unreachable;failed;skipped;rescued;ignored" > output_html/playbooks.csv.previous
cat output_html/index.html.previous | grep tr | sed 's/style="color/style>/' | sed 's/;">/:/' | sed 's/<[^>]*>//g'  | sed 's/=/:/g' | sed 's/:/;/g' | sed 's/ *; */;/g'  | sed 's/  */;/g' | awk -F ';' '{print $1";"$3";"$2";"$5";"$7";"$9";"$11";"$13";"$15";"$17}' >> output_html/playbooks.csv.previous

diff output_html/playbooks.csv* | grep ';' | sed 's/^..//'  | awk -F ';' '{print $1}'  | sort -u  | while read playbook ; do ls --full-time output_html/playbooks/$playbook".html" | awk '{print $6" "$7" '$playbook'"}' ; done  | sort -r  | awk 'BEGIN {updated=""; print "<?xml version=\"1.0\" encoding=\"utf-8\"?><feed xmlns=\"http://www.w3.org/2005/Atom\"><title>Ansible checks</title>"} {if ( updated == "" ) updated=$1" "$2 ; print "<entry><title>ansible check "$3" changed</title><id>"$3$1$2"</id><link>/playbook/"$3".html</link><updated>"$1" "$2"</updated></entry>"} END{print "<updated>"updated"</updated></feed>"}' > output_html/feed.xml
