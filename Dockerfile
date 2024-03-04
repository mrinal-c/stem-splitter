# from https://github.com/xserrat/docker-facebook-demucs/blob/main/Dockerfile
FROM nvidia/cuda:11.8.0-base-ubuntu22.04

USER root

RUN apt update && apt install -y --no-install-recommends \
    build-essential \
    nginx \
    supervisor \
    ffmpeg \
    git \
    python3 \
    python3-dev \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

RUN git clone --depth 1 --branch v4.0.0 --single-branch https://github.com/facebookresearch/demucs /lib/demucs

# Install dependencies
RUN python3 -m pip install -e /lib/demucs --default-timeout=1000 --no-cache-dir
RUN python3 -m pip install flask gunicorn pika celery --no-cache-dir


WORKDIR /app
COPY app.py .
COPY supervisor.conf /etc/supervisor/conf.d/supervisor.conf
COPY nginx.conf /etc/nginx/nginx.conf
EXPOSE 80

ENTRYPOINT ["/bin/bash", "--login", "-c"]
CMD ["supervisord -n"]
# CMD ["gunicorn -b 0.0.0.0:5000 --access-logfile=- --timeout 500 app:app"]
