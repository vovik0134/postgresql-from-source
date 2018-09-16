FROM debian:stretch

MAINTAINER vovik0134@gmail.com

ARG BRANCH

ENV PGSQL /usr/local/pgsql
ENV PATH "$PGSQL/bin":$PATH
ENV PGDATA "$PGSQL/data"

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        git \
        gcc \
        libc6-dev \
        libreadline-dev \
        zlib1g-dev \
        build-essential \
        bison \
        flex \
    # clone postgres source
    && git config --global http.sslVerify false \
    && git clone https://github.com/postgres/postgres.git \
    # build postgresql
    && cd /postgres \
    && git checkout $BRANCH \
    && ./configure \
    && make \
    && make install \
    && adduser postgres \
    && mkdir "$PGDATA" \
    && chown -R postgres "$PGSQL" \
    # install postgres_fdw
    # && cd /postgres/contrib/postgres_fdw \
    # && make \
    # && cp postgres_fdw.control "$PGSQL/share/extension/" \
    # && cp postgres_fdw--1.0.sql "$PGSQL/share/extension/" \
    # && cp postgres_fdw.so "$PGSQL/lib/" \
    # cleanup
    && rm -rf /postgres \
    && apt-get remove -y \
        git \
        gcc \
        libc6-dev \
        libreadline-dev \
        zlib1g-dev \
        build-essential \
        bison \
        flex \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/*

EXPOSE 5432

USER postgres

# init pgdata
RUN initdb -D "$PGDATA" \
    && echo "host all all 0.0.0.0/0 trust" > "$PGDATA/pg_hba.conf"

CMD ["postgres", "-h 0.0.0.0"]