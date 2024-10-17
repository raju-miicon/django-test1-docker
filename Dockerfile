# Use an official Python runtime as a parent image
FROM python:3.11-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Set the working directory inside the container
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    gcc \
    python3-dev \
    && rm -rf /var/lib/apt/lists/*

# Copy the requirements file and install Python dependencies
COPY requirements.txt /app/
RUN pip install --upgrade pip && \
    pip install -r requirements.txt

# Copy the entire project directory into the container
COPY . /app/

# Collect static files and run database migrations
RUN python manage.py collectstatic --noinput
RUN python manage.py migrate

# Expose the Django app port
EXPOSE 8000

# Start the Django app using Gunicorn
CMD ["gunicorn", "MyProject.wsgi:application", "--bind", "0.0.0.0:8000"]
