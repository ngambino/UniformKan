#!/bin/bash

LATEX_MAIN='frobenius'
COMMONS=('uniform-kan-prelude')

COMMONS_DIR='../../common'
ARXIV_DIR='arxiv'
ARXIV_DIR_TEST='arxiv-test'

function message {
    echo "================================================================================" 1>&2
    echo "$1" 1>&2
    echo "================================================================================" 1>&2
}

function error_exit {
    message "$1"
    exit 1
}

function init_dir {
  rm -rf "$1"
  mkdir "$1"
}

# create bibliography file
cd "$(dirname $0)" || error_exit "failed to switch to paper directory"
(pdflatex "$LATEX_MAIN" && bibtex "$LATEX_MAIN") || error_exit "failed to compile $LATEX_MAIN"

message "Copying relevant files to ./$ARXIV_DIR/"
init_dir "$ARXIV_DIR"
COPY=("$LATEX_MAIN.tex" "$LATEX_MAIN.bbl")
for C in ${COMMONS[@]}; do
  COPY+=("$COMMONS_DIR/$C.sty")
done
for C in ${COPY[@]}; do
  cp -t "$ARXIV_DIR" "$C" || error_exit "failed to copy $C to subdirectory $ARXIV_DIR"
done

# modify files to make them self-contained and work around arxiv TeX bugs
message "Preparing files in ./$ARXIV_DIR/"
cd "$ARXIV_DIR"
for C in ${COMMONS[@]}; do
  mv "$C.sty" "$C.tex"
  sed -i 's/\\ProvidesPackage{'"$C"'}//' "$C.tex"
  sed -i 's/\\usepackage{'"$C"'}/\\input{'"$C"'}/' "$LATEX_MAIN.tex"
done
sed -i 's/,draft]{amsart}/]{amsart}/' "$LATEX_MAIN_TEX"
sed -i 's/\\bibliography{[^}]*}/\\bibliography{}/' "$LATEX_MAIN.tex"
# remove holes in arrow since arxiv uses an outdated version of xy which causes fragments of arrows to disappear
sed -i 's/|\(!{\[[urdl]\+\];\[[urdl]\+\]}\|(.\+)\){\\hole}\( % bug: doesn'\''t work?\)\?//g' "$LATEX_MAIN.tex"

message "Test compiling arXiv document..."
cd ..
cp -r "$ARXIV_DIR" "$ARXIV_DIR_TEST"
cd "$ARXIV_DIR_TEST"
pdflatex "$LATEX_MAIN" && pdflatex "$LATEX_MAIN"
result=$?
cd ..
rm -rf "$ARXIV_DIR_TEST"
(exit $result) || error_exit "failed to test compile arXiv document"

message "Success: please find arXiv sources in the subdirectory $ARXIV_DIR"
