# Blog API

This is a Ruby on Rails API for a blog application. The API allows users to create accounts, make posts, comment on posts, and tag posts. The application uses JWT for authentication and Sidekiq for background job processing.  

Note: All Api Endpoints tests are in spec/controllers

## Prerequisites

- Ruby 3.3.4
- Rails 7.1.3
- PostgreSQL
- Redis
- Docker and Docker Compose

## Database Schema
![Screenshot 2024-07-26 181839](https://github.com/user-attachments/assets/a63bd09d-86b1-40b3-8ab9-6b5e3d7d6304)


## Running the Application

```
docker-compose up
```

## API Documentation

### Authentication

- **Login**  
  **Endpoint:** `POST /login`  
  **Request:**
  ```json
  {
    "user": {
      "email": "user@example.com",
      "password": "password123"
    }
  }
  ```
  **Response:**
  ```json
  {
    "token": "jwt_token"
  }

### Users

- **Create User**  
  **Endpoint:** `POST /users`  
  **Request:**
  ```json
  {
    "user": {
      "name": "User",
      "email": "user@example.com",
      "password": "password",
      "image": "base64_encoded_image"
    }
  }
  ```
  **Response:**
  ```json
  {
    "name": "User",
    "email": "user@example.com",
    "image": "base64_encoded_image"
  }

- **Get Current User**  
  **Endpoint:** `GET /me`  
  **Response:**
  ```json
  {
    "name": "User",
    "email": "user@example.com",
    "image": "base64_encoded_image"
  }

### Posts

- **Create Post**  
  **Endpoint:** `POST /posts`  
  **Request:**
  ```json
  {
    "post": {
      "title": "Post Title",
      "body": "Post Body",
      "tags_attributes": [
        {
          "tag": "tag1"
        },
        {
          "tag": "tag2"
        }
      ]
    }
  }
  ```
  **Response:**
  ```json
  {
    "title": "Post Title",
    "body": "Post Body",
    "tags_attributes": [
      {
        "tag": "tag1"
      },
      {
        "tag": "tag2"
      }
    ],
    "comments": []
  }

- **Get All Posts**  
  **Endpoint:** `GET /posts`  
  **Response:**
  ```json
  [
    {
      "title": "Post Title",
      "body": "Post Body",
      "tags_attributes": [
        {
          "tag": "tag1"
        },
        {
          "tag": "tag2"
        }
      ],
      "comments": []
    }
  ]

- **Get Post**  
  **Endpoint:** `GET /posts/:id`  
  **Response:**
  ```json
  {
    "title": "Post Title",
    "body": "Post Body",
    "tags_attributes": [
      {
        "tag": "tag1"
      },
      {
        "tag": "tag2"
      }
    ],
    "comments": []
  }

- **Update Post**  
  **Endpoint:** `PUT /posts/:id`  
  **Request:**
  ```json
  {
    "post": {
      "title": "Updated Title",
      "body": "Updated Body",
      "tags_attributes": [
        {
          "id": 1,
          "tag": "tag1",
          "_destroy": false
        }
      ]
    }
  }

  ```
  **Response:**
  ```json
  {
    "title": "Updated Title",
    "body": "Updated Body",
    "tags_attributes": [
      {
        "tag": "tag1"
      }
    ],
    "comments": []
  }

- **Delete Post**  
  **Endpoint:** `DELETE /posts/:id`
   **Response:** `204 No Content`

### Comments

- **Create Comment**  
  **Endpoint:** `POST /posts/:post_id/comments`  
  **Request:**
  ```json
  {
    "comment": {
      "comment": "This is a comment"
    }
  }
  ```
  **Response:**
  ```json
  {
    "comment": "This is a comment"
  }

- **Update Comment**  
  **Endpoint:** `POST /posts/:post_id/comments/:id`  
  **Request:**
  ```json
  {
    "comment": {
      "comment": "Updated comment"
    }
  }
  ```
  **Response:**
  ```json
  {
    "comment": "Updated comment"
  }

- **Delete Comment**  
  **Endpoint:** `DELETE /posts/:post_id/comments/:id`
   **Response:** `204 No Content`

