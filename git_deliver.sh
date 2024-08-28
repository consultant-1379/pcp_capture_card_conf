#!/bin/bash

# ### 19/02/2015 -  THIS FILE IS NOT IN USE CURRENTLY FOR PACKAGE DELIVERY ### #
# ###               REFER git_build.sh FOR DELIVERY                        ### #


module=$1
userId=$2
workspace=$3
branch=$4
reason=$5
CT=/usr/atria/bin/cleartool
pkg_dir="/proj/$USER/eniq_events_releases"

function getReason {
        if [ -n "$reason" ]; then
        	reason=`echo $reason | sed 's/$\ /x/'`
                reason=`echo JIRA:::$reason | sed s/" "/,JIRA:::/g`
        else
                reason="CI-DEV"
        fi
}

function getProductNumber {
        product=`cat $workspace/build.cfg | grep $module | grep $branch | awk -F " " '{print $3}'`
}

function getSprint {
	echo "Workspace:$workspace"
	echo "Module: $module"
	echo "Branch: $branch"
        sprint=`cat $workspace/build.cfg | grep $module | grep $branch | awk -F " " '{print $5}'`
	echo "Sprint: $sprint"
}

function getPkg {
	pkg=`ls -lrt $pkg_dir | grep pcp_capture_card_conf | grep $rstate | tail -1 | awk '{print $9}'`
}

function deliver {
	echo "Running command: /vobs/dm_eniq/tools/scripts/deliver_eniq -auto events $sprint $reason N $userId $product NONE $pkg_dir/$pkg"
	$CT setview -exec "cd /vobs/dm_eniq/tools/scripts;./deliver_eniq -auto events $sprint $reason N $userId $product NONE $pkg_dir/$pkg" deliver_ui
}

function getRstate {
	rstate=`cat $workspace/rstate.txt`
	rm -rf $workspace/rstate.txt
}

getReason
getProductNumber
getSprint
getRstate
getPkg
deliver

