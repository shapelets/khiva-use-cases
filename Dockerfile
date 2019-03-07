FROM shapelets/khiva-python:0.2.0

USER root

# Setting variables to execute jupyter notebooks
ENV NB_USER khiva-binder
ENV NB_UID 1000
ENV VENV_DIR /srv/venv
ENV HOME /home/${NB_USER}

RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid ${NB_UID} \
    ${NB_USER}

ENV PATH ${VENV_DIR}/bin:$PATH

WORKDIR ${HOME}
COPY . ${HOME}
RUN chown -R ${NB_USER} ${HOME}

RUN apt-get update && \
    apt-get -y install python3-venv python3-dev && \
    apt-get purge && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create a virtual environment directory owned by a non-privileged user & set up notebook in it
# This allows non-root to install python libraries if required
RUN mkdir -p ${VENV_DIR} && chown -R ${NB_USER} ${VENV_DIR}
USER ${NB_USER}
RUN python3 -m venv ${VENV_DIR} 
RUN pip3 install --no-cache-dir tornado==5.* 
RUN pip3 install --no-cache-dir notebook==5.* && \
    pip3 install --no-cache-dir -r ../requirements.txt

CMD jupyter notebook --ip 0.0.0.0
