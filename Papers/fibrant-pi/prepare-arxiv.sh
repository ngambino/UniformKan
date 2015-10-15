#!/bin/bash

function message {
    echo "================================================================================" 1>&2
    echo "$1" 1>&2
    echo "================================================================================" 1>&2
}

function error_exit {
    message "$1"
    exit 1
}

message "Copying relevant files to ./arxiv/"
echo $(dirname @0) || error_exit "failed to switch to fibrant-pi paper directory"
(pdflatex frobenius.tex && bibtex frobenius) || error_exit "failed to compile frobenius"
rm -rf arxiv && mkdir arxiv
(cp -t arxiv frobenius.tex frobenius.bbl ../../common/uniform-kan-prelude.sty) || error_exit "failed to copy relevant files frobenius.tex frobenius.bbl ../../common/uniform-kan-prelude.sty to arxiv subdirectory"

# modify files to make them self-contained and workaround arxiv TeX bugs
message "Preparing files in ./arxiv/"
cd arxiv
mv uniform-kan-prelude.sty uniform-kan-prelude.tex
sed -i 's/\\ProvidesPackage{uniform-kan-prelude}//' uniform-kan-prelude.tex
sed -i 's/,draft]{amsart}/]{amsart}/' frobenius.tex
sed -i 's/\\usepackage{uniform-kan-prelude}/\\input{uniform-kan-prelude}/' frobenius.tex
sed -i 's/\\bibliography{\.\.\/\.\.\/common\/uniform-kan-bibliography}/\\bibliography{uniform-kan-bibliography}/' frobenius.tex
# remove holes in arrow since arxiv uses an outdated version of xy which causes fragments of arrows to disappear
sed -i 's/|\(!{\[[urdl]\+\];\[[urdl]\+\]}\|(.\+)\){\\hole}\( % bug: doesn'\''t work?\)\?//g' frobenius.tex

message "Test compiling arXiv document..."
mkdir test
cp frobenius.tex uniform-kan-prelude.tex test/
cd test
pdflatex frobenius.tex && pdflatex frobenius.tex
result=$?
cd ..
rm -rf test
(exit $result) || error_exit "failed to test compile arXiv document"

message "Success: please find arXiv sources in the arxiv subdirectory"
