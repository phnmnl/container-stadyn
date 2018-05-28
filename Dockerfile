# PhenoMeNal H2020

FROM container-registry.phenomenal-h2020.eu/phnmnl/rbase:v3.4.1-1xenial0_cv0.2.12

MAINTAINER PhenoMeNal-H2020 Project ( phenomenal-h2020-users@googlegroups.com )

LABEL maintainer="PhenoMeNal-H2020 Project ( phenomenal-h2020-users@googlegroups.com )"
LABEL version="1.0"
LABEL software.version="1.0"
LABEL software="simid"
LABEL description="Corrects mass isotopomer distribution (MID) for natural isotopes abundance, giving artificial MID"
LABEL website="https://github.com/seliv55/simid"
LABEL documentation="https://github.com/phnmnl/container-stadyn/blob/master/README.md"
LABEL license="https://github.com/phnmnl/container-stadyn/blob/develop/License.txt"
LABEL license="https://github.com/phnmnl/container-stadyn/blob/master/License.txt"
LABEL tags="Metabolomics"

ENV REVISION "6bde3cb4e1a88be03dae05a526c511b6c1c8defe"

# Setup package repos
RUN apt-get -y update && apt-get -y --no-install-recommends install r-base-dev libssl-dev \
                                    libcurl4-openssl-dev git \
                                    libssh2-1-dev libnetcdf-dev r-cran-ncdf4 && \
    echo 'options("repos"="http://cran.rstudio.com")' >> /etc/R/Rprofile.site && \
    R -e "install.packages(c('devtools', 'optparse'))" && \
    R -e 'library(devtools); install_github("seliv55/simid",ref=Sys.getenv("REVISION")[1])' && \
    apt-get purge -y git r-base-dev libssl-dev libcurl4-openssl-dev libssh2-1-dev libnetcdf-dev && \
    apt-get clean && apt-get autoremove -y && rm -rf /var/lib/{apt,dpkg,cache,log}/ /tmp/* /var/tmp/*

# Add scripts folder to container
ADD scripts/rustadyn.R /usr/bin/rustadyn.R
RUN chmod +x /usr/bin/rustadyn.R

# Add test scripts
ADD runTest1.sh /usr/local/bin/runTest1.sh
RUN chmod a+x /usr/local/bin/runTest1.sh
# Define Entry point script
ENTRYPOINT ["rustadyn.R"]

