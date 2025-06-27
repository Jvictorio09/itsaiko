# Use official slim Python image
FROM python:3.9-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Set working directory
WORKDIR /app

# Install dependencies
COPY requirements.txt .
RUN pip install --upgrade pip && pip install --no-cache-dir -r requirements.txt

# Copy the rest of the app
COPY . .

# Run database migrations and collect static files
RUN python manage.py migrate
RUN python manage.py collectstatic --noinput

# Expose any port (Railway injects $PORT)
EXPOSE 8000

# Start Gunicorn using the dynamic Railway port
CMD exec gunicorn myProject.wsgi:application --bind 0.0.0.0:$PORT
