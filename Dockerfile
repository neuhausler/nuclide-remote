FROM ubuntu:16.04

ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive

ENV NUCLIDE_VERSION 0.249.0

RUN apt-get update -qq

# Install and configre SSH server
RUN apt-get install -y openssh-server
RUN mkdir /var/run/sshd
RUN echo 'root:nuclide' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

# Install Dev SDK
RUN apt-get -y install gcc make autoconf git python-dev libpython-dev

# Install Watchman
RUN git clone https://github.com/facebook/watchman.git \
	&& cd watchman \
	&& git checkout v4.5.0 \
	&& ./autogen.sh \
	&& ./configure \
	&& make && make install

# Install Node.js
RUN apt-get install -y curl
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -
RUN apt-get install -y nodejs

# Install Nuclide Remote Server
RUN npm install -g nuclide@${NUCLIDE_VERSION}

# Start ssh service
CMD ["/usr/sbin/sshd", "-D"]


