FROM ubuntu:14.04

ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -qq

# Install and configre SSH server
RUN apt-get install -y openssh-server
RUN mkdir /var/run/sshd
RUN echo 'root:nuclide' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

# Install Watchman
RUN apt-get -y install make autoconf git libpython-dev
RUN git clone https://github.com/facebook/watchman.git \
	&& cd watchman \
	&& git checkout v3.9.0 \
	&& ./autogen.sh \
	&& ./configure \
	&& make && make install

# Install Node.js and Nuclide Remote Server
RUN apt-get install -y curl nodejs npm

# 'Hack' to get 0.12 version of Node.js
RUN curl -sL https://deb.nodesource.com/setup_0.12 | sudo bash -
RUN apt-get update -qq

RUN apt-get install -y nodejs
RUN npm install -g nuclide

# Start ssh service
CMD ["/usr/sbin/sshd", "-D"]


