FROM alpine:3.15

# based upon
#   https://github.com/HenryQW/Awesome-TTRSS/blob/main/Dockerfile

# Install ttrss itself
WORKDIR /var/www

RUN apk add --update --no-cache \
    bash \
    bind-tools \
    ca-certificates \
    curl \
    git \
    iproute2 \
    net-tools \
    nginx \
    php8 \
    php8-fpm php8-pdo php8-pgsql php8-pdo_pgsql \
    php8-gd php8-mbstring php8-intl php8-xml php8-curl \
    php8-session php8-tokenizer php8-dom php8-fileinfo \
    php8-json php8-iconv php8-pcntl php8-posix php8-zip php8-exif \
    py3-pip \
    sudo \
    supervisor \
    tar \
    tcpdump \
    vim \
  && ln -s /usr/bin/php8 /usr/bin/php \
  && rm -rf /var/www/* \
  && git clone https://git.tt-rss.org/fox/tt-rss --depth=1 /var/www

# we want to log to stdout for supervisord
RUN pip install supervisor-stdout

# Add plugins

# Download plugins
WORKDIR /var/www/plugins.local

## Effective Config
RUN mkdir prefs_effective_config \
    && curl -sL https://git.tt-rss.org/fox/ttrss-prefs-effective-config/archive/master.tar.gz | \
    tar xzvpf - --strip-components=1 -C prefs_effective_config

## Feediron
RUN mkdir feediron \
  && curl -sL https://github.com/feediron/ttrss_plugin-feediron/archive/master.tar.gz | \
  tar xzvpf - --strip-components=1 -C feediron ttrss_plugin-feediron-master

## googlereaderkeys
RUN git clone https://git.tt-rss.org/fox/ttrss-googlereaderkeys.git --depth=1 googlereaderkeys

# Add themes

# Download themes
WORKDIR /var/www/themes.local

## Feedly
RUN curl -sL https://github.com/levito/tt-rss-feedly-theme/archive/master.tar.gz | \
  tar xzvpf - --strip-components=1 --wildcards -C . tt-rss-feedly-theme-master/feedly*.css tt-rss-feedly-theme-master/feedly/fonts

## RSSHub
RUN curl -sL https://github.com/DIYgod/ttrss-theme-rsshub/archive/master.tar.gz | \
  tar xzvpf - --strip-components=2 -C . ttrss-theme-rsshub-master/dist/rsshub.css

# Fix permissions
RUN chown -R nobody:nogroup /var/www

COPY conf/php-fpm/www.conf /etc/php8/php-fpm.d/www.conf
COPY conf/supervisord/supervisord.conf /etc/supervisord.conf
COPY conf/nginx/ttrss.nginx.conf /etc/nginx/http.d/default.conf
COPY conf/nginx/nginx.conf /etc/nginx/nginx.conf