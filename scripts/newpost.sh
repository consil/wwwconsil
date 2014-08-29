#!/bin/sh



[ -e "$HOME/blog/14" ] || { echo "Err: blog dir not exists"; exit 1; }

dat=$(date +"%m%d")

echo "What title"
read title

tit="$(perl -e '$v=$ARGV[0]; $v=~ s/\W+/_/g; $v=~ s/_+/_/g; print $v' "$title")"

pat=$HOME/blog/14/${tit}_${dat}.txt
{ 
    
echo "# $title"
echo ""
echo "> by ben@consil.org," $(date +"%Y-%m-%d")

echo ""
echo ""

} > $pat

echo $pat


