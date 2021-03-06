FROM rocker/tidyverse:4.1.0

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
    sf \
    magick \
    gifski \
    osmdata \
    janitor \
    arrow \
  && R -e " \
    options(repos = c(CRAN = 'http://cran.rstudio.com')); \
    devtools::install_github('thomasp85/gganimate'); \
    arrow::install_arrow();"

# latex
RUN apt-get -y --no-install-recommends install \
    ghostscript \
    texlive-base \
    texlive-latex-recommended \
    texlive-fonts-recommended \
  && tlmgr option repository ftp://tug.org/historic/systems/texlive/2018/tlnet-final \
  && tlmgr init-usertree \
  && mkdir /root/r \
  && mkdir /root/texmf \
  && tlmgr install mdframed \
  && tlmgr install needspace \
  && texhash \
  && mktexlsr \
  && updmap-sys --sync-trees

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
    IRkernel::installspec(name = 'ir-kernel-4.1.0', displayname = 'R 4.1.0')"

EXPOSE 8888

CMD ["jupyter", "notebook", "--allow-root", "--no-browser", "--ip=0.0.0.0", "--port=8888"]
