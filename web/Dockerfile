FROM python:alpine

WORKDIR /usr/src/app

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY sqlite/init_db.py sqlite/schema.sql ./
RUN chmod 700 init_db.py schema.sql
RUN python3 init_db.py

RUN mkdir static
RUN mkdir templates

ADD static static
ADD templates templates

COPY app.py .

CMD [ "python", "./app.py" ]

