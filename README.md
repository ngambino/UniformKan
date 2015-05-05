## Compilation

The file `common/uniform-kan-prelude.sty` contains the usually duplicate preample stuff, including macro definitions.
TeX files such as `Notes/conds-on-fibrations.tex` include it using `\usepackage{uniform-kan-prelude}`.
In order for this to work, LaTeX needs to know to look for inputs in the directory `common`.
This can usually be achieved in several different ways:

#### Specific instructions for Nicola

```
mkdir -p ~/Library/texmf/tex/latex
ln -s ~/Desktop/UniformKan/common ~/Library/texmf/tex/latex/uniform-kan-common
```

#### Environment variable

On Linux with TexLive, you can set an environment variable:

```
TEXTINPUTS=.:<path to repository>/UniformKan/common:
```

#### Local installation

Find the local TeX tree.
This depends on your operating system and TeX installation.
Under Linux with TeXLive, it is '~/texmf'.
Under MacOS with TeXLive or MacTeX, it seems to be '~/Library/texmf'.
Create this directory if it does not exist.
After entering it, place a symbolic link to the `common` directory of the repository in the `tex/latex` subdirectory:

```
mkdir -p tex/latex
ln -s <path to repository>/UniformKan/common tex/latex/uniform-kan-common
```
