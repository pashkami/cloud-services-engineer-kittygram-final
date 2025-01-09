FROM python:3.10 as build
WORKDIR /backend
COPY requirements.txt .
RUN pip install -r requirements.txt --no-cache-dir
COPY . .
CMD ["python", "manage.py", "migrate"]


FROM python:3.10
ENV PYTHONUNBUFFERED=1
WORKDIR /backend
COPY --from=build /usr/local/lib/python3.10/site-packages /usr/local/lib/python3.10/site-packages
COPY --from=build /backend /backend
EXPOSE 8000
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]