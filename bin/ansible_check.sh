#!/bin/bash

cd ./$(dirname $0)/.. 2> /dev/null

actualdir=$(pwd)

if test -f output_html/.running; then
	exit 1;
fi
echo $$ > output_html/.running

mkdir -p output_html/playbooks

for config in config/*inc ; do

	. $config
	cd $ANSIBLE_REPO 2> /dev/null
	git pull
	for playbook in $PLAYBOOKS_TO_RUN ; do
		html=$(echo $playbook | sed 's/\.yml/.html/')
		export ANSIBLE_FORCE_COLOR=true
		cp $actualdir/output_html/playbooks/$html $actualdir/output_html/playbooks/$html."previous"
		$ANSIBLE_PLAYBOOK_CMD --ssh-extra-args "-o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no" --diff --check $playbook 2>&1 | aha -t "ansible playbook $playbook" > $actualdir/output_html/playbooks/$html".running.htm"
		mv $actualdir/output_html/playbooks/$html".running.htm" $actualdir/output_html/playbooks/$html
	done
	cd - 2> /dev/null

done

rm output_html/.running