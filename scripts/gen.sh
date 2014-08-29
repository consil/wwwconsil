#!/bin/sh

y=14

rm -rf out
mkdir -p out/$y
chmod 771 out   # nfs hosting requirement

pandoc -s  static/about.md  > out/about.html
( cat 'memo.txt' && echo '-------  ' && echo 'generated: ' $(date +"%Y-%m-%d")) | pandoc -s  > out/memo.html 


for f in $y/* ; do
    [ -e "$f" ] || continue
    bn=$(basename $f)
    title=${bn%.*}
    #title=$(echo "$bn" |  perl -n -e '/(.*)_(\d+)\.txt/ && print $1')
    #dat=$(echo "$bn" |  perl -n -e '/(.*)_(\d+)\.txt/ && print $2')
    if [ -f "$f" ] ; then
        date=$(perl -n -e 'if ($. == 3){ /.*,\s+(\d\d\d\d\-\d\d\-\d\d)/ && print $1 }' $f)
        [ -z "$date" ] && { echo "Err: no date" ; exit 1 ; }
        outdir=out/$y/${date}_${title}
        mkdir -p $outdir 
        (lipsum weave $f | perl -n -e '/\s*\<\<.*\>\>\=/ || print ' && echo '------' && echo '[source](source.txt)  ' && echo 'generated: ' $(date +"%Y-%m-%d")) | pandoc -s > $outdir/index.html
        cp $f $outdir/source.txt
    elif [ -d "$f" ] ; then
        if [ -f "$f/index.txt" ] ; then
            tar cfvz $outdir/${dat}_${title}.tar.gz ${f}
            ( cat $f/index.txt && echo '-----' && echo "[src](${dat}_${title})  ") | pandoc -s  > $outdir/index.html 
        else
            echo "Err: no index file in $f"
            exit 1
        fi
    fi
done
{
    echo "[consil.org](../)  "
    echo " "
    echo "[memo](memo.html)  "
    echo " "
    echo "## posts  "

    echo "### 20${y}  " 
    find out/$y/* -type d | sort | while read f ; do 
        ff=$(basename $f)
        bff=${ff%.*}
         echo "[$bff](${y}/${bff}/index.html)  "; 
done
} | pandoc -s > out/index.html
