FROM rocker/tidyverse:3.5.1

LABEL maintainer="Torsten Sprenger <mail@spren9er.de>"

ADD VERSION .

# r & latex & fonts
RUN apt-get update -qq && apt-get -y --no-install-recommends install \
    libgdal-dev \
    libmagick++-dev \
    libudunits2-dev \
    git \
    texlive \
    xzdec \
    cargo \
    libpoppler-cpp-dev \
  && install2.r --error \
    extrafont \
    jsonlite \
    lubridate \
    plotly \
    rmarkdown \
    tidytext \
    GGally \
    pdftools \
  && git clone https://github.com/google/fonts /root/.fonts \
  && fc-cache -f -v \
  && R -e " \
    options(repos = c(CRAN = 'http://cran.rstudio.com')); \
    install.packages('ggplot2'); \
    devtools::install_github('thomasp85/gganimate'); \
    devtools::install_github('dkahle/ggmap', ref = 'tidyup'); \
    extrafont::font_import(prompt = FALSE); \
    extrafont::loadfonts();" \
  && mkdir /root/r \
  && mkdir /root/texmf \
  && tlmgr init-usertree \
  && tlmgr install ly1

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
    IRkernel::installspec(name = 'ir-kernel-3.5.1', displayname = 'R 3.5.1')"

EXPOSE 8888

CMD ["jupyter", "notebook", "--allow-root", "--no-browser", "--ip=0.0.0.0", "--port=8888"]
