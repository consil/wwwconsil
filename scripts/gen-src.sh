#!/bin/sh

y=14
rm -rf out

mkdir -p out
chmod 771 out   # nfs hosting requirement

pandoc -s  static/about.md  > out/about.html

for f in $y/*.txt ; do
    bn=$(basename $f)
    bnn=${bn%.*}
    title=$(echo "$bn" |  perl -n -e '/(.*)_(\d+)\.txt/ && print $1')
    dat=$(echo "$bn" |  perl -n -e '/(.*)_(\d+)\.txt/ && print $2')
    echo "$bnn" |  perl -n -e '/(.*)_(\d+)\.txt/ && print $2'
    mkdir -p out/$y
    chomod 771 out/$y
     lipsum weave $f | perl -n -e '/\s*\<\<.*\>\>\=/ || print ' | pandoc -s > out/$y/${dat}_${title}.html
    cp $f out/$y/${dat}_${title}.txt
done
{
    echo "[consil.org](../)  "
    echo " "
    echo "## txt  "

    echo "### 20${y}  " 
    ls out/$y/*.txt | sort | while read f ; do 
        ff=$(basename $f)
        bff=${ff%.*}
         echo "[$bff](${y}/${bff}.html)  "; 
done
} | pandoc -s > out/index.html

{
    echo "[consil.org](../)  "
    echo " "
    echo "## src  "

    echo "### 20${y}  " 
    for f in out/src/* ; do # a b c 
        bf=$(basename $f)
        for ff in $f/* ; do
            [ -e "$ff" ] || continue
            bff=$(basename $ff)
            { echo "#### $bff"; for fff in $ff/*; do bfff=$(basename $fff); [ -e "$fff" ] && echo "[$bfff]($bfff)  " ; done } | pandoc -s > $ff/index.html
                echo "[$bff]($bf/$bff/index.html)  "
                [ -f "$ff/meta.txt" ] && grep descr: $ff/meta.txt | sed 's/descr://g' 
                echo "  "
        done
    done
} | pandoc -s > out/src/index.html

{
echo "# consil.org"

echo ""

echo "[src](src/index.html)  "
echo "[txt](txt/index.html)  "
echo "[about](about/index.html)"

echo ""

echo "generated .. " $(date) 

} | pandoc -s > out/index.html



