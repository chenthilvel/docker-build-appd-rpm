FROM chenthilvel/fpm
MAINTAINER ChenthilVel
COPY preinstall build-rpm.sh /root/

CMD ["/bin/bash", "/root/build-rpm.sh"]
