FROM python:3.9-alpine3.13
LABEL maintainer="theavuth"

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

# If you later need native builds (psycopg2/mysqlclient/Pillow), uncomment:
# RUN apk add --no-cache build-base

COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app
WORKDIR /app
EXPOSE 8000

ARG DEV=false

RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ "$DEV" = "true" ]; then \
        /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi && \
    rm -f /tmp/requirements.txt /tmp/requirements.dev.txt && \
    adduser -D -H -s /sbin/nologin django-user && \
    chown -R django-user:root /app /py

ENV PATH="/py/bin:$PATH"

USER django-user
