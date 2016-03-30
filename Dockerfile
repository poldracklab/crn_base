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

FROM ubuntu:vivid
MAINTAINER Stanford Center for Reproducible Neuroscience <crn.poldracklab@gmail.com>

RUN ln -snf /bin/bash /bin/sh

# Update packages and install the minimal set of tools
RUN apt-get update && \
    apt-get install -y curl git xvfb bzip2 apt-utils

# Install ANTs
RUN mkdir -p /opt/ants && \
    curl -sSL "https://2a353b13e8d2d9ac21ce543b7064482f771ce658.googledrive.com/host/0BxI12kyv2olZVFhUcGVpYWF3R3c/ANTs-Linux_Ubuntu14.04.tar.bz2" \
    | tar -xjC /opt/ants --strip-components 1
ENV ANTSPATH /opt/ants
ENV PATH $ANTSPATH:$PATH
RUN echo 'export ANTSPATH=/opt/ants' >> /root/.bashrc && \
    echo 'export PATH=$ANTSPATH:$PATH' >> /root/.bashrc


# Enable neurodebian
RUN curl -sSL http://neuro.debian.net/lists/vivid.de-m.full | tee /etc/apt/sources.list.d/neurodebian.sources.list && \
    curl -sSL http://neuro.debian.net/lists/vivid.us-tn.full >> /etc/apt/sources.list.d/neurodebian.sources.list && \
    apt-key adv --recv-keys --keyserver hkp://pgp.mit.edu:80 0xA5D32F012649A5A9 && \
    apt-get update && \
    apt-get install -y fsl-core afni && \
    echo 'source /etc/fsl/fsl.sh' >> /root/.bashrc && \
    echo 'source /etc/afni/afni.sh' >> /root/.bashrc

# Clear apt cache to reduce image size
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

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
RUN conda create -y -n crnenv numpy \
                              scipy \
                              pandas \
                              scikit-image \
                              ipython \
                              matplotlib \
                              networkx \
                              lxml && \
    echo 'source activate crnenv' >> /root/.bashrc

# Install pip
RUN source activate crnenv && \
    pip install --upgrade pip && \
    pip install xvfbwrapper && \
    pip install lockfile && \
    pip install --upgrade numpy && \
    pip install --upgrade pandas

# Install nipype & mriqc
RUN mkdir -p src && \
    cd src && \
    git clone https://github.com/nipy/nipype.git && \
    source activate crnenv && \
    cd nipype && \
    pip install -e .

CMD ["/bin/bash"]