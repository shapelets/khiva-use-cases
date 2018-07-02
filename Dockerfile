FROM shapelets/khiva-python:0.1.0
RUN pip3 install --no-cache-dir notebook==5.*

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

# Specify the default command to run
CMD ["jupyter", "notebook", "--ip", "0.0.0.0"]
