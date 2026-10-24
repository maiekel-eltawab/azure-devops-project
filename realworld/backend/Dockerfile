FROM python:3.12-slim-bookworm

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1

WORKDIR /app

RUN apt-get update \
    && apt-get install -y --no-install-recommends gcc libc6-dev libpq-dev \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --upgrade pip

COPY pyproject.toml README.md ./
COPY apps/ ./apps/
COPY config/ ./config/
COPY helpers/ ./helpers/
COPY manage.py ./

RUN pip install .

RUN apt-get purge -y --auto-remove gcc \
    && rm -rf /var/lib/apt/lists/*

EXPOSE 8000

CMD ["gunicorn", "config.wsgi:application", "--bind", "0.0.0.0:8000", "--workers", "2"]
