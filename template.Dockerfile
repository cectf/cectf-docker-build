LABEL maintainer="Daniel Chiquito <daniel.chiquito@gmail.com>"

ADD https://github.com/cectf/cectf.github.io/archive/master.zip /var/local/cectf/cectf-frontend.zip
RUN unzip /var/local/cectf/cectf-frontend.zip -d /var/local/cectf/ && \
    mv /var/local/cectf/cectf.github.io-master/ /var/local/cectf/www/ && \
    rm /var/local/cectf/cectf-frontend.zip

RUN apk update #&& \
    # Python
RUN apk add python3 && \
    apk add python3-dev && \
    # cectf_server dependencies
    apk add libffi && \
    apk add libffi-dev && \
    apk add musl-dev && \
    apk add linux-headers && \
    apk add gcc && \
    pip3 install cectf-server && \
    # uwsgi
    pip3 install uwsgi && \
    mkdir -p /var/log/uwsgi/ && \
    ln -sf /dev/stdout /var/log/uwsgi/cectf_server.log && \
    # remove unecessary dependencies
    apk del python3-dev && \
    apk del gcc && \
    apk del musl-dev && \
    # Nginx
    apk add nginx && \
    rm -f /etc/nginx/nginx.conf && \
    rm -f /etc/nginx/conf.d/default.conf && \
    chown -R nginx:nginx /var/lib/nginx && \
    chown -R nginx:nginx /var/local/cectf/www && \
    ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log && \
    # supervisord
    apk add supervisor && \
    rm -rf /var/cache/apk/* && \
    # challenge file storage
    mkdir -p /var/local/cectf/files

COPY uwsgi.ini /etc/uwsgi/
COPY nginx.conf /etc/nginx/
COPY conf.d/cectf_server.conf /etc/nginx/conf.d/
COPY supervisord.ini /etc/supervisor.d/supervisord.ini

EXPOSE 80

CMD ["supervisord"]

