# kurento-dev
#
# VERSION               4.4.3

FROM      ubuntu:14.04
MAINTAINER semanhou <hhool.student@gmail.com>

RUN cp /etc/apt/sources.list /etc/apt/sources.list.bak &&  sed -i -e "s/archive\.ubuntu\.com/mirrors\.aliyun\.com/g" /etc/apt/sources.list

RUN apt-get update \
	&& apt-get install -y wget vim git devscripts build-essential

RUN	echo "deb http://ubuntu.kurento.org/ trusty kms6" | tee /etc/apt/sources.list.d/kurento.list \
	&& wget -O - http://ubuntu.kurento.org/kurento.gpg.key | apt-key add - \
	&& apt-get update \
	&& apt-get -y install kurento-media-server-6.0 \
	&& apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y cmake \
&& cd /opt && mkdir kurento && cd kurento && git clone https://github.com/Kurento/kurento-media-server.git \
&& git clone https://github.com/Kurento/kms-core.git \
&& git clone https://github.com/Kurento/kms-elements.git \
&& git clone https://github.com/Kurento/kms-filters.git \
&& git clone https://github.com/Kurento/kms-jsonrpc.git \
&& git clone https://github.com/Kurento/kms-chroma.git \
&& git clone https://github.com/Kurento/kms-cmake-utils.git \
&& git clone https://github.com/Kurento/kms-crowddetector.git \
&& git clone https://github.com/Kurento/kms-datachannelexample.git \
&& git clone https://github.com/Kurento/kms-opencv-plugin-sample.git \
&& git clone https://github.com/Kurento/kms-platedetector.git \
&& git clone https://github.com/Kurento/kms-plugin-sample.git \
&& git clone https://github.com/Kurento/kms-pointerdetector.git \
&& git clone https://github.com/Kurento/kurento-module-creator.git \
&& cd /opt/kurento/kurento-media-server && git checkout 6.6.1 \
&& cd /opt/kurento/kms-core && git checkout 6.6.1 \ 
&& cd /opt/kurento/kms-filters && git checkout 6.6.1 \
&& cd /opt/kurento/kms-elements && git checkout 6.6.1 \
&& cd /opt/kurento/kms-jsonrpc && git checkout 1.1.2 \
&& cd /opt/kurento/kms-cmake-utils && git checkout 1.3.2 \
&& cd /opt/kurento/kms-crowddetector && git checkout 6.6.0 \
&& cd /opt/kurento/kms-chroma && git checkout 6.6.0 \
&& cd /opt/kurento/kms-datachannelexample && git checkout 6.6.0 \
&& cd /opt/kurento/kms-platedetector && git checkout 6.6.0 \
&& cd /opt/kurento/kms-pointerdetector && git checkout 6.6.0 \
&& cd /opt/kurento/kurento-media-server \
&& sudo apt-get install -y $(cat debian/control | sed -e "s/$/\!\!/g" | tr -d '\n' | sed "s/\!\! / /g" | sed "s/\!\!/\n/g" | grep "Build-Depends" | sed "s/Build-Depends: //g" | sed "s/([^)]*)//g" | sed "s/, */ /g") \
&& debuild -us -uc \
&& cd /opt/kurento/kurento-module-creator \
&& sudo apt-get install -y $(cat debian/control | sed -e "s/$/\!\!/g" | tr -d '\n' | sed "s/\!\! / /g" | sed "s/\!\!/\n/g" | grep "Build-Depends" | sed "s/Build-Depends: //g" | sed "s/([^)]*)//g" | sed "s/, */ /g") \
&& debuild -us -uc \
&& cd /opt/kurento/kms-core \
&& sudo apt-get install -y $(cat debian/control | sed -e "s/$/\!\!/g" | tr -d '\n' | sed "s/\!\! / /g" | sed "s/\!\!/\n/g" | grep "Build-Depends" | sed "s/Build-Depends: //g" | sed "s/([^)]*)//g" | sed "s/, */ /g") \
&& debuild -us -uc \
&& cd /opt/kurento/kms-elements \
&& sudo apt-get install -y $(cat debian/control | sed -e "s/$/\!\!/g" | tr -d '\n' | sed "s/\!\! / /g" | sed "s/\!\!/\n/g" | grep "Build-Depends" | sed "s/Build-Depends: //g" | sed "s/([^)]*)//g" | sed "s/, */ /g") \
&& sed -i 's/add_subdirectory(tests)/#add_subdirectory(tests)/g' CMakeLists.txt \
&& sed -i 's/override_dh_auto_test/#override_dh_auto_test/g'  debian/rules \
&& sed -i 's/dh_auto_build -- -j2 check ARGS=-j10/#dh_auto_build -- -j2 check ARGS=-j10/g'  debian/rules \
&& debuild -us -uc \
&& cd /opt/kurento/kms-filters \
&& sudo apt-get install -y $(cat debian/control | sed -e "s/$/\!\!/g" | tr -d '\n' | sed "s/\!\! / /g" | sed "s/\!\!/\n/g" | grep "Build-Depends" | sed "s/Build-Depends: //g" | sed "s/([^)]*)//g" | sed "s/, */ /g") \
&& sed -i 's/add_subdirectory(tests)/#add_subdirectory(tests)/g' CMakeLists.txt \
&& debuild -us -uc \
&& cd /opt/kurento/kms-jsonrpc \
&& sudo apt-get install -y $(cat debian/control | sed -e "s/$/\!\!/g" | tr -d '\n' | sed "s/\!\! / /g" | sed "s/\!\!/\n/g" | grep "Build-Depends" | sed "s/Build-Depends: //g" | sed "s/([^)]*)//g" | sed "s/, */ /g") \
&& debuild -us -uc

EXPOSE 8888
EXPOSE 8443

COPY ./entrypoint.sh /entrypoint.sh

ENV GST_DEBUG=Kurento*:5

#ENTRYPOINT ["/entrypoint.sh"]
