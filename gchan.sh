#!/bin/bash

function get_thread_name() {
        return $(git rev-parse --abbrev-ref HEAD)
}

function append_last_dat() {
        local SEP="<>"

        local name=$(git log -1 --format=%cn)
        local email=$(git log -1 --format=%ce)
        local timestamp=$(git log -1 --format=%cd)
        local response=$(git log -1 --format=%s)
        local thread=$1

        dat_line="${name}${SEP}${email}${SEP}${timestamp}${SEP}${response}${SEP}${thread}"
        echo $dat_line >> "${title}.dat"
}

function create_last_dat() {
        local thread=$1

        touch "${title}.dat" && append_dat "$title"
}

function update_last_dat() {
        local thread=$(get_thread_name)

        if [[ -f "${thread}.dat" ]]; then
                append_last_dat
        else
                create_last_dat thread
        fi
}

op=$1
message=$2

update_last_dat

case $op in
	"r" | "response" )
		git add -A && git commit -m "$message" ;;
	"b" | "boards" )
		git fetch && git branch -a ;;
	"c" | "create" )
		git checkout -b $2 ;;
	"p" | "post" )
		git checkout -b $2 && git commit -m "$3" ;;
	"s" | "show" )
		git checkout $2 && git pull && git log ;;
esac

