services:
  rabbitmq:
    image: rabbitmq:3-management
    container_name: rabbitMQ
    ports:
      - "5672:5672"
      - "15672:15672"
    environment:
      RABBITMQ_DEFAULT_USER: guest
      RABBITMQ_DEFAULT_PASS: guest

  api:
    container_name: backend-api
    build:
      context: ../                # IMPORTANT: this points to your solution root: D:\Bioskopina
      dockerfile: backend/Bioskopina/Dockerfile  # relative to context!
    ports:
      - "5000:80"  
    environment:
      - RABBITMQ_HOST=rabbitmq  
      - RABBITMQ_PORT=5672
      - RABBITMQ_USERNAME=guest
      - RABBITMQ_PASSWORD=guest
      - SQL_USER=${SQL_USER}
      - SQL_PASSWORD=${SQL_PASSWORD}
      - SQL_DATABASE=${SQL_DATABASE}
    depends_on:
      - rabbitmq
