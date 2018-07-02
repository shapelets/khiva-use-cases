FROM shapelets/khiva-python:0.1.0

USER root

ENV NB_USER rstudio
ENV NB_UID 1000
ENV VENV_DIR /srv/venv
RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid ${NB_UID} \
    ${NB_USER}
# Set ENV for all programs...
ENV PATH ${VENV_DIR}/bin:$PATH
# And set ENV for R! It doesn't read from the environment...

# The `rsession` binary that is called by nbrsessionproxy to start R doesn't seem to start
# without this being explicitly set

ENV HOME /home/${NB_USER}
WORKDIR ${HOME}
COPY . ${HOME}
RUN chown -R ${NB_USER} ${HOME}

RUN apt-get update && \
    apt-get -y install python3-venv python3-dev && \
    apt-get purge && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create a venv dir owned by unprivileged user & set up notebook in it
# This allows non-root to install python libraries if required
RUN mkdir -p ${VENV_DIR} && chown -R ${NB_USER} ${VENV_DIR}

USER ${NB_USER}
RUN pip3 install jupyter

RUN python3 -m venv ${VENV_DIR} && \
    pip3 install --no-cache-dir \
         notebook==5.* && \
    pip3 install -r requirements.txt



CMD jupyter notebook --ip 0.0.0.0
