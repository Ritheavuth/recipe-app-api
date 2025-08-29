FROM python:3.9-alpine3.13
LABEL maintainer="theavuth"

# Correct variable name
ENV PYTHONUNBUFFERED=1

# System deps (optional now, but useful if you add db drivers later)
# RUN apk add --no-cache build-base

COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app
WORKDIR /app
EXPOSE 8000

# Create venv, install deps
ARG DEV=false
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV = "true"]; \
        then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi && \
    rm -f /tmp/requirements.txt && \
    # Create a non-root user on Alpine (BusyBox adduser)
    adduser -D -H -s /sbin/nologin django-user && \
    chown -R django-user:root /app /py

ENV PATH="/py/bin:$PATH"

USER django-user
