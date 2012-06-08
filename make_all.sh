#!/bin/bash

ARTICLES=`find . -name 'Makefile' -a -print`
CWD=`pwd`
BASEDIR=`dirname "$0"`
OUTDIR="$BASEDIR/articles"
i=0
if [ ! -d "$OUTDIR" ]; then
    mkdir $OUTDIR
fi

for ARTICLE in $ARTICLES; do
    path=`dirname "$ARTICLE"`
    cd "$path"
    make > /dev/null
    cd "$CWD"
    name=`basename "$path"`
    name="$name.pdf"
    cp "$path/$name" "$OUTDIR"
    (( i++ ))
done

echo "All $i articles were built."

tar czf "$BASEDIR/Articles.tar.gz" "articles"

echo "Bundled all articles in '$BASEDIR/Articles.tar.gz'."
