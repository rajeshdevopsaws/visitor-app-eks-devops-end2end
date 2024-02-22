FROM python:3.7

RUN apt-get update && \
    apt-get install -y redis-server && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt /app/


RUN pip install --no-cache-dir -r requirements.txt
RUN pip install --upgrade werkzeug

COPY . /app/

EXPOSE 3000 6379

CMD ["sh", "-c", "service redis-server start && python3 app.py"]
