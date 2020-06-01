FROM python:3

RUN pip install prometheus_client

COPY index.py .

EXPOSE 8000
EXPOSE 8001
CMD ["python3", "index.py"]
