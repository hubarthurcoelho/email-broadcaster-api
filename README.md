# Email Broadcaster API

This is a Ruby on Rails API application designed for broadcasting emails to multiple recipients. It leverages Sidekiq for background processing and SendGrid for sending emails. The project is containerized using Docker Compose.

## Features

- **Messages**: Stores the content of the emails to be broadcasted.
- **Message Receipts**: Tracks the status of each email sent (pending, failed, delivered).
- **SendGrid Integration**: Utilized for reliable email delivery.

## Technologies Used

- **Ruby on Rails**: Backend framework for building the API.
- **Sidekiq**: For background job processing.
- **Redis**: In-memory data structure store, used for communication between the server and Sidekiq.
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

2. **Create the `.env` file**:
    ```dotenv
    RAILS_ENV=development
    POSTGRES_HOST=db
    POSTGRES_DB=email_broadcaster
    POSTGRES_DB_TEST=email_broadcaster_test
    POSTGRES_USER=root
    POSTGRES_PASSWORD=root
    RAILS_MAX_THREADS=5
    RAILS_MASTER_KEY=811e86d7a30f3701bf612e785fbbf785
    REDIS_URL=redis://redis:6379/0
    SENDGRID_DOMAIN=your-domain
    SENDGRID_API_KEY=your-api-key [VERY IMPORTANT, visit [sendGrid](https://sendgrid.com/)]
    ```

3. **Build and start the Docker containers**:
    ```bash
    rake docker:build  # or docker-compose up -d --build
    ```

4. **Stop Docker containers**:
    ```bash
    rake docker:down  # or docker-compose down
    ```

5. **Open server logs**:
    ```bash
    rake app:logs
    ```

6. **Open server interactive terminal**:
    ```bash
    rake app:terminal
    ```

7. **Open Rails console**:
    ```bash
    rake app:console
    ```

## Using

To use the provided endpoints, download this [vs-code extension](https://marketplace.visualstudio.com/items?itemName=rangav.vscode-thunder-client)

## Testing

To run the test suites, use the following command:

```bash
rake specs:run
```
