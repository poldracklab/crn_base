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

FROM neurodebian:latest
MAINTAINER Stanford Center for Reproducible Neuroscience <crn.poldracklab@gmail.com>

# Preparations
RUN ln -snf /bin/bash /bin/sh
ENV SHELL /bin/bash
ARG DEBIAN_FRONTEND=noninteractive

# Update packages and install the minimal set of tools
RUN sed -i -e 's,main$,main contrib non-free,g' /etc/apt/sources.list.d/neurodebian.sources.list && \
    apt-get -y update && \
    apt-get install -y curl \
                       git \
                       xvfb \
                       bzip2 \
                       apt-utils \
                       tcsh \
                       bc \
                       tar \
                       libgomp1 \
                       perl-modules \
                       fsl-core \
                       afni \
                       graphviz && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Set FSL environment variables
ENV FSLDIR=/usr/share/fsl/5.0 \
    FSLOUTPUTTYPE=NIFTI_GZ \
    FSLMULTIFILEQUIT=TRUE \
    POSSUMDIR=/usr/share/fsl/5.0 \
    FSLTCLSH=/usr/bin/tclsh \
    FSLWISH=/usr/bin/wish \
    PATH=/usr/lib/fsl/5.0:$PATH \
    LD_LIBRARY_PATH=/usr/lib/fsl/5.0:$LD_LIBRARY_PATH

# Install ANTs
RUN mkdir -p /opt/ants && \
    curl -sSL "https://files.osf.io/v1/resources/fvuh8/providers/osfstorage/57f34767594d9001ef91bfb7" \
    | tar -xjC /opt/ants --strip-components 1
ENV ANTSPATH /opt/ants
ENV PATH $ANTSPATH:$PATH

# Install BIDS-validator
RUN curl -sL https://deb.nodesource.com/setup_4.x | bash - && \
    apt-get install -y nodejs && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    npm install -g bids-validator

# Install C3D
RUN mkdir -p /opt/c3d && \
    curl -sSL "https://files.osf.io/v1/resources/fvuh8/providers/osfstorage/57f341d6594d9001f591bac2" \
    | tar -xzC /opt/c3d --strip-components 1

ENV C3DPATH=/opt/c3d
ENV PATH=$C3DPATH:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$PATH

CMD ["/bin/bash"]
