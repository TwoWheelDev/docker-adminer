FROM php:8.4-fpm-alpine

RUN	echo "upload_max_filesize = 128M" >> /usr/local/etc/php/conf.d/0-upload_large_dumps.ini \
&&	echo "post_max_size = 128M" >> /usr/local/etc/php/conf.d/0-upload_large_dumps.ini \
&&	echo "memory_limit = 1G" >> /usr/local/etc/php/conf.d/0-upload_large_dumps.ini \
&&	echo "max_execution_time = 600" >> /usr/local/etc/php/conf.d/0-upload_large_dumps.ini \
&&	echo "max_input_vars = 5000" >> /usr/local/etc/php/conf.d/0-upload_large_dumps.ini

RUN	addgroup -S adminer \
&&	adduser -S -G adminer adminer \
&&	mkdir -p /var/www/html \
&&	mkdir /var/www/html/plugins-enabled \
&&	chown -R adminer:adminer /var/www/html

RUN	set -x \
&&	apk add --no-cache --virtual .build-deps \
	postgresql-dev \
	sqlite-dev \
	unixodbc-dev \
	freetds-dev \
&&	docker-php-ext-configure pdo_odbc --with-pdo-odbc=unixODBC,/usr \
&&	docker-php-ext-install \
	mysqli \
	pdo_pgsql \
	pdo_sqlite \
	pdo_odbc \
	pdo_dblib \
&&	runDeps="$( \
		scanelf --needed --nobanner --format '%n#p' --recursive /usr/local/lib/php/extensions \
			| tr ',' '\n' \
			| sort -u \
			| awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
	)" \
&&	apk add --virtual .phpexts-rundeps $runDeps \
&&	apk del --no-network .build-deps

COPY	*.php /var/www/html/

ENV	ADMINER_VERSION 4.13
ENV	ADMINER_DOWNLOAD_SHA256 8c8cf581ccb3b408f7d573506cc80124356dd8c912d2badd16ff03da5e03e130
ENV	ADMINER_COMMIT c6bb5b80a815bf90bb2e01bdc7b8451ee9eff651

RUN	set -x \
&&	apk add --no-cache --virtual .build-deps git \
&&	curl -fsSL "https://github.com/pematon/adminer/releases/download/v$ADMINER_VERSION/adminer-$ADMINER_VERSION.php" -o adminer.php \
&&	echo "$ADMINER_DOWNLOAD_SHA256  adminer.php" |sha256sum -c - \
&&	git clone --recurse-submodules=designs --depth 1 --shallow-submodules --branch "v$ADMINER_VERSION" https://github.com/pematon/adminer.git /tmp/adminer \
&&	commit="$(git -C /tmp/adminer/ rev-parse HEAD)" \
&&	[ "$commit" = "$ADMINER_COMMIT" ] \
&&	cp -r /tmp/adminer/designs/ /tmp/adminer/plugins/ . \
&&	rm -rf /tmp/adminer/ \
&&	apk del --no-network  .build-deps

COPY	entrypoint.sh /usr/local/bin/
ENTRYPOINT	[ "entrypoint.sh", "docker-php-entrypoint" ]

USER	adminer
CMD	[ "php-fpm" ]
