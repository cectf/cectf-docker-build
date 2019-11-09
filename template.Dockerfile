LABEL maintainer="Daniel Chiquito <daniel.chiquito@gmail.com>"

RUN apk update && \
    # Python
    apk add python3 && \
    apk add python3-dev && \
    # cectf_server dependencies
    apk add libffi && \
    apk add libffi-dev && \
    apk add musl-dev && \
    apk add gcc && \
    pip3 install cectf-server && \
    # remove unecessary dependencies
    apk del python3-dev && \
    apk del gcc && \
    apk del musl-dev && \
    # uwsgi
    # TODO
    # Nginx
    apk add nginx && \
    rm -rf /etc/nginx/nginx.conf && \
    chown -R nginx:nginx /var/lib/nginx && \
    # supervisord
    apk add supervisor && \
    rm -rf /var/cache/apk/*

COPY nginx.conf /etc/nginx/
COPY conf.d/cectf_server.conf /etc/nginx/conf.d/
COPY supervisord.ini /etc/supervisor.d/supervisord.ini

EXPOSE 80

CMD ["supervisord"]

