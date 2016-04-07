# Copyright (c) 2016, The developers of the Stanford CRN
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# * Redistributions of source code must retain the above copyright notice, this
#   list of conditions and the following disclaimer.
#
# * Redistributions in binary form must reproduce the above copyright notice,
#   this list of conditions and the following disclaimer in the documentation
#   and/or other materials provided with the distribution.
#
# * Neither the name of crn_base nor the names of its
#   contributors may be used to endorse or promote products derived from
#   this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

FROM oesteban/crn_base
MAINTAINER Stanford Center for Reproducible Neuroscience <crn.poldracklab@gmail.com>

WORKDIR /root

# Install miniconda
RUN curl -sSLO https://repo.continuum.io/miniconda/Miniconda-latest-Linux-x86_64.sh && \
    /bin/bash Miniconda-latest-Linux-x86_64.sh -b && \
    rm Miniconda-latest-Linux-x86_64.sh
ENV PATH /root/miniconda2/bin:$PATH

# http://bugs.python.org/issue19846
# > At the moment, setting "LANG=C" on a Linux system *fundamentally breaks Python 3*, and that's not OK.
ENV LANG C.UTF-8

# Create conda environment
RUN conda create -y -n crnenv lockfile && \
    echo 'source activate crnenv' >> /root/.bashrc

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y gfortran \
                       liblapack-dev \
                       libblas-dev \
                       libatlas-dev \
                       libatlas-base-dev \
                       libblas3 \
                       libblas-common \
                       libopenblas-dev \
                       libxml2-dev \
                       libxslt1-dev \
                       libfreetype6-dev \
                       libpng12-dev \
                       libqhull-dev \
                       libxft-dev \
                       libjpeg-dev

# Clear apt cache to reduce image size
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install pip
RUN source activate crnenv && \
    pip install --upgrade pip && \
    pip install nose && \
    pip install numpy && \
    pip install scipy && \
    pip install pandas && \
    pip install matplotlib && \
    pip install xvfbwrapper

# Install nipype & mriqc
RUN mkdir -p src && \
    cd src && \
    git clone https://github.com/nipy/nipype.git && \
    source activate crnenv && \
    cd nipype && \
    pip install -e .

CMD ["/bin/bash"]
