FROM shapelets/khiva-python:0.1.0

ENV NB_USER jovyan
ENV NB_UID 1000
RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid ${NB_UID} \
    ${NB_USER}

ENV HOME /home/${NB_USER}

WORKDIR ${HOME}



# Make sure the contents of our repo are in ${HOME}
COPY . ${HOME}
USER root
RUN chown -R ${NB_UID} ${HOME}
USER ${NB_USER}

RUN pip3 install jupyter
RUN pip3 install --no-cache-dir \
         notebook==5.2 \
         git+https://github.com/jupyterhub/nbrsessionproxy.git \
         git+https://github.com/jupyterhub/nbserverproxy.git && \
    jupyter serverextension enable --sys-prefix --py nbserverproxy && \
    jupyter serverextension enable --sys-prefix --py nbrsessionproxy && \
    jupyter nbextension install    --sys-prefix --py nbrsessionproxy && \
    jupyter nbextension enable     --sys-prefix --py nbrsessionproxy

# Specify the default command to run
CMD ["jupyter", "notebook", "--ip", "0.0.0.0"]