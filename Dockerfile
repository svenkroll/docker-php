FROM centos:centos7

ENV PHPVERSION 7.0.4

RUN yum install -y epel-release \
    && yum -y install \
	bzip2-devel \
	wget \
	gcc \
	curl-devel \
	libxml2-devel \
	xz-devel \
	bison-devel \
	openssl-devel \
	libxslt-devel \
	libjpeg-devel \
	libpng-devel \
	freetype-devel \
	libc-client-devel \ 
	libmcrypt-devel \
	make \
    && yum clean all

RUN mkdir -p /usr/local/src/php \
	&& wget -O /usr/local/src/php/php-$PHPVERSION.tar.gz http://de1.php.net/distributions/php-$PHPVERSION.tar.gz \
	&& cd /usr/local/src/php \
	&& tar -zxvf php-$PHPVERSION.tar.gz

RUN cd /usr/local/src/php/php-$PHPVERSION/; \
    ./configure \
    --enable-fpm \
    --enable-pdo \
    --with-pdo-mysql \
    --enable-sockets \
    --enable-exif \
    --enable-soap \
    --enable-wddx \
    --enable-pcntl \
    --enable-soap \
    --enable-bcmath \
    --enable-mbstring \
    --enable-dba \
    --enable-gd-native-ttf \
    --enable-zip \
    --enable-calendar \
    --with-mysqli \
    --with-pdo-sqlite \
    --with-iconv \
    --with-zlib \
    --with-bz2 \
    --with-gettext \
    --with-xmlrpc \
    --with-openssl \
    --enable-opcache \
    --with-mhash \
    --with-mcrypt \
    --with-xsl \
    --with-curl \
    --with-pcre-regex \
    --with-gd \
    --with-freetype-dir=/usr \
    --with-jpeg-dir=/usr \
    --with-png-dir=/usr \
    --with-pear \
    --with-fpm-user=www-data \
    --with-fpm-group=www-data \
    --with-config-file-path=/usr/local/etc/php/ \
    --with-config-file-scan-dir=/usr/local/etc/php/conf.d/ \
    --with-libdir=lib/x86_64-linux-gnu

RUN cd /usr/local/src/php/php-$PHPVERSION; \
    make; \
    make install

RUN mkdir -p /usr/local/etc/php/conf.d/ && \
    mkdir -p /usr/local/etc/php/php-fpm.d/ && \
    cp /usr/local/src/php/php-$PHPVERSION/php.ini-production /usr/local/etc/php/php.ini

COPY php-fpm.conf /usr/local/etc/php-fpm.conf 
COPY www.conf /usr/local/etc/php/php-fpm.d/www.conf

RUN adduser www-data

EXPOSE 9000

CMD ["/usr/local/sbin/php-fpm","-R","-c","/usr/local/etc/php/php.ini","-y","/usr/local/etc/php-fpm.conf"]
