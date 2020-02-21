# Docker for R Dev Environment

## Overview

Docker will install following software

- R (with tidyverse, lubridate, plotly, gganimate and some more packages)
- Jupyter
- imagemagick
- TexLive

It builds an jupyter kernel with R and runs a notebook server on port 8888 on start up.

Furthermore it installs Google Fonts and prepares them for usage with _ggplot2_.

## Instructions

Build Docker image with

```bash
docker build -t rstats .
```

Run your Docker container with

```bash
docker run -it --name rstats
  -v ~/path/to/my/r/projects:/root/r
  -v ~/.Rprofile:/root/.Rprofile
  -e JUPYTER_TOKEN=1
  -p 8888:8888
  spren9er/r-docker:TAG
```

## Atom

You can connect your Atom editor with a running remote R kernel by using Hydrogen package.

- Define a remote kernel in Hydrogen settings
- Open up an R file
- Choose 'Hydrogen: Connect to remote kernel'
- Supply token defined when running the container (`JUPYTER_TOKEN`)
- Run R code
