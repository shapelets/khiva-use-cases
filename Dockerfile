#FROM shapelets/khiva-python:0.1.0

#ENV NB_USER jovyan
#ENV NB_UID 1000
#ENV HOME /home/${NB_USER}

#RUN adduser --disabled-password \
#    --gecos "Default user" \
#    --uid ${NB_UID} \
#    ${NB_USER}

# Make sure the contents of our repo are in ${HOME}
#COPY . ${HOME}
#USER root
#RUN chown -R ${NB_UID} ${HOME}
#USER ${NB_USER}

#RUN pip3 install jupyter

# Specify the default command to run
#CMD ["jupyter", "notebook", "--ip", "0.0.0.0"]


FROM shapelets/khiva-python:0.1.0

ENV NB_USER jovyan
ENV NB_UID 1000
ENV HOME /home/${NB_USER}

RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid ${NB_UID} \
    ${NB_USER}

# Make sure the contents of our repo are in ${HOME}
COPY . ${HOME}
USER root
RUN chown -R ${NB_UID} ${HOME}
USER ${NB_USER}

RUN apt-get update && \
    apt-get -y install python3-venv python3-dev && \
    apt-get purge && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create a venv dir owned by unprivileged user & set up notebook in it
# This allows non-root to install python libraries if required


USER ${NB_USER}
RUN pip3 install khiva==0.1.3
RUN pip3 install --no-cache-dir \
         notebook==5.2 \
         git+https://github.com/jupyterhub/nbrsessionproxy.git \
         git+https://github.com/jupyterhub/nbserverproxy.git && \
    jupyter serverextension enable --sys-prefix --py nbserverproxy && \
    jupyter serverextension enable --sys-prefix --py nbrsessionproxy && \
    jupyter nbextension install    --sys-prefix --py nbrsessionproxy && \
    jupyter nbextension enable     --sys-prefix --py nbrsessionproxy


CMD jupyter notebook --ip 0.0.0.0

USER root
COPY . ${HOME}
RUN chown -R ${NB_USER} ${HOME}

## Become normal user again
USER ${NB_USER}