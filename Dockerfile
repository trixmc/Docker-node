FROM      ubuntu:18.04
MAINTAINER Olexander Vdovychenko  <farmazin@gmail.com>

#Create docker user
RUN mkdir -p /var/www
RUN mkdir -p /home/docker
RUN useradd -d /home/docker -s /bin/bash -M -N -G www-data,sudo,root docker
RUN echo docker:docker | chpasswd
RUN usermod -G www-data,users www-data
RUN chown -R docker:www-data /var/www
RUN chown -R docker:www-data /home/docker

#install Software
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y git git-core vim nano mc nginx screen curl unzip wget software-properties-common
RUN apt-get install -y supervisor memcached htop tmux zip sudo
COPY configs/nginx/default /etc/nginx/sites-available/default

# SSH service
RUN apt-get install -y openssh-server openssh-client
RUN mkdir /var/run/sshd
RUN echo 'root:root' | chpasswd
#change 'pass' to your secret password
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config
# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

#configs bash start
COPY configs/autostart.sh /root/autostart.sh
RUN  chmod +x /root/autostart.sh
COPY configs/bash.bashrc /etc/bash.bashrc
COPY configs/.bashrc /root/.bashrc
COPY configs/.bashrc /home/docker/.bashrc

#Install locale
RUN locale-gen en_US.UTF-8
RUN dpkg-reconfigure locales

#Install NodeJS
RUN apt install nodejs
RUN apt install npm

#open ports
EXPOSE 80 22