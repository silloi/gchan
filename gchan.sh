#!/bin/bash

function append_last_dat() {
        local SEP="<>"

        local name=$(git log -1 --format=%cn)
        # local email= $(git log -1 --format=%ce)
        local email=
        local timestamp=$(git log -1 --format=%cd)
        local response=$(git log -1 --format=%s)
        local thread=$(git rev-parse --abbrev-ref HEAD)
        local title=$1

        dat_line="${name}${SEP}${email}${SEP}${timestamp}${SEP}${response}${SEP}${title}"
        echo $dat_line >> "${thread}.dat"
}

function create_last_dat() {
        local title=$1

        touch "${title}.dat" && append_last_dat "$title"
}

function update_last_dat() {
        local thread=$(git rev-parse --abbrev-ref HEAD)

        if [[ -f "${thread}.dat" ]]; then
                append_last_dat
        else
                create_last_dat "$thread"
        fi
}

op=$1

case $op in
	"r" | "response" )
		update_last_dat && git add -A && git commit -m "$2" ;;
	"b" | "boards" )
		git fetch && git branch -a ;;
	"c" | "create" )
		git checkout -b "$2" ;;
	"p" | "post" )
		update_last_dat && (git checkout -b "$2" || git checkout "$2") && git add -A && git commit -m "$3" ;;
	"s" | "show" )
		git checkout "$2" && git pull; git log --reverse --first-parent "$2" ;;
esac
