# Email Broadcaster API

This is a Ruby on Rails API application designed for broadcasting emails to multiple recipients. It leverages Sidekiq for background processing and SendGrid for sending emails. The project is containerized using Docker Compose.

## Features

- **Messages**: Stores the content of the emails to be broadcasted.
- **Message Receipts**: Tracks the status of each email sent (pending, failed, delivered).
- **SendGrid Integration**: Utilized for reliable email delivery.

## Technologies Used

- **Ruby on Rails**: Backend framework for building the API.
- **Sidekiq**: For background job processing.
- **Redis**: In-memory data structure store, used for communication between the Server and Sidekiq.
- **PostgreSQL**: Database of choice.
- **Docker Compose**: Containerization for development and deployment.
- **RSpec**: Testing framework used for writing and running test cases.

## Setup

To set up the project locally, follow these steps:

1. **Clone the repository**:
    ```bash
    git clone git@github.com:hubarthurcoelho/email-broadcaster-api.git
    cd email-broadcaster-api
    ```

2. **Build and start the Docker containers**:
    ```bash
    rake docker:build or docker-compose up -d --build
    ```

3. **Stop Docker containers**:
    ```bash
    rake docker:down or docker-compose down
    ```

4. **Open Server logs**:
    ```bash
    rake app:logs
    ```

5. **Open server iteractive terminal**:
    ```bash
    rake app:terminal
    ```
  
6. **Open server rails console**:
    ```bash
    rake app:console
    ```

## Testing

To run test suites, use the following command:

```bash
rake specs:run
```

