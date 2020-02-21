FROM rocker/tidyverse:3.6.2

LABEL maintainer="Torsten Sprenger <mail@spren9er.de>"

ADD VERSION .

# r packages
RUN apt-get update -qq && apt-get -y --no-install-recommends install \
    libgdal-dev \
    libmagick++-dev \
    libudunits2-dev \
    git \
    xzdec \
    cargo \
    libpoppler-cpp-dev \
  && install2.r --error \
    extrafont \
    jsonlite \
    svglite \
    lubridate \
    plotly \
    rmarkdown \
    tidytext \
  && R -e " \
    options(repos = c(CRAN = 'http://cran.rstudio.com')); \
    devtools::install_github('thomasp85/gganimate');"

# latex
RUN apt-get -y --no-install-recommends install \
    ghostscript \
    texlive \
  && mkdir /root/r \
  && mkdir /root/texmf \
  && tlmgr init-usertree

# fonts
RUN git clone https://github.com/google/fonts /root/.fonts \
  && fc-cache -f -v \
  && R -e " \
    extrafont::font_import(prompt = FALSE); \
    extrafont::loadfonts();"

# jupyter
RUN apt-get -y --no-install-recommends install \
    build-essential \
    python3-all \
    python3-pip \
    python3-setuptools \
    libncurses5-dev \
    libncursesw5-dev \
    libzmq3-dev \
  && python3 -m pip install --upgrade pip \
  && python3 -m pip install jupyter \
  && R -e " \
    devtools::install_github('IRkernel/IRkernel'); \
    IRkernel::installspec(name = 'ir-kernel-3.6.2', displayname = 'R 3.6.2')"

EXPOSE 8888

CMD ["jupyter", "notebook", "--allow-root", "--no-browser", "--ip=0.0.0.0", "--port=8888"]
