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
	&& git checkout v4.5.0 \
	&& ./autogen.sh \
	&& ./configure \
	&& make && make install

# Install Node.js
RUN apt-get install -y curl
RUN curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash -
RUN apt-get install -y nodejs

# Install Nuclide Remote Server
RUN npm install -g nuclide

# Start ssh service
CMD ["/usr/sbin/sshd", "-D"]


