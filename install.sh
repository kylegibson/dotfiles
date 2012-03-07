#!/bin/bash
directory=$(dirname $0)
pushd $directory
for F in *; do
    echo README install.sh | grep -q $F;
    test $? -eq 0 && continue
    if [ -e $HOME/.$F ]; then
        echo "skipping $F, already exists"
    else
        ln -sf $(pwd)/$F $HOME/.$F
    fi
done
popd
