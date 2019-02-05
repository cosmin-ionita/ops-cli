FROM linuxbrew/linuxbrew:1.9.3

ENV HOMEBREW_NO_AUTO_UPDATE=1
RUN brew install python2

RUN pip2 install -U virtualenv
RUN virtualenv ops

USER root
RUN rm /bin/sh && ln -s /bin/bash /bin/sh
USER linuxbrew
RUN source ops/bin/activate
RUN pip2 install --upgrade https://github.com/adobe/ops-cli/releases/download/0.23/ops-0.23.tar.gz

ADD . /ops-cli
RUN /ops-cli/examples/aws-kubernetes/update.sh
