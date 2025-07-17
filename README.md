# Library Management System

This is a Ruby on Rails-based Library Management System that allows users to borrow books, track due dates, and manage library operations. The application supports both admin and member roles, with different dashboards and functionalities for each.

---

## Thought Process

You can read about my development approach and decisions [here](./THOUGHT_PROCESS.md).

## Features

- **Admin Dashboard**:
  - View all books in the library.
  - Track borrowed books and overdue books.
  - View users with overdue books.

- **Member Dashboard**:
  - View books borrowed by the user.
  - Track due dates for borrowed books.

- **Book Management**:
  - Add, update, and delete books.
  - Track available copies of books.

- **Borrowing System**:
  - Borrow books with validation for availability.
  - Automatic due date calculation (e.g., 14 days from borrow date).
  - Return books and update availability.

---

## Requirements

- **Ruby Version**: `3.4.4` (or update `.ruby-version` if needed)
- **Rails Version**: `8.x`
- **Database**: SQLite3 (default) or PostgreSQL for production.

---

## Setup Instructions

1. **Clone the Repository**:
```bash
  git clone https://github.com/JeffVieira/library.git
  cd library
```

2. **Install Dependencies:**
```bash
  bundle install
```

3. **Set Up the Database:**
```
rails db:create
rails db:migrate
rails db:seed
```

4. **Run the Application:**
```bash
rails server
```

## Running Tests

To run the test suite, use:
```bash
bundle exec rspec
```

---

## API Endpoints

**Users/access**
```
Admin/Librarian:
email: admin@mail.com
password: Adminpass123

Member:
email: member@mail.com
password: Memberpass123
```

**Authentication**
  - SignUp `POST /api/v1/sign_up`
  - Login: `POST /api/v1/sign_in`
  - Logout: `DELETE /api/v1/sign_out`

**Books**
  - List Books: `GET /api/v1/books?query=`
  - Create Books: `POST /api/v1/books`
  - Update Books: `PATCH /api/v1/books/:id`
  - Delete Books: `DELETE /api/v1/books/:id`
  - Borrow Book: `POST /api/v1/borrows`
  - Return Book: `PATCH /api/v1/return_book`

**Dashboards**
  - Admin Dashboard: `GET /api/v1/dashboards` (Admin only)
  - Member Dashboard: `GET /api/v1/dashboards` (Member only)

## Postman Collection

You can test the API using the Postman collection:
[Postman Workspace](https://app.getpostman.com/join-team?invite_code=77b2e89aa65717344362b76bb01184b62de3f1a5fc10042936dee565ea59ed6d&target_code=cb48665bc2ab8eded69f310d259fca24)

---

## Next Steps Improvements

Here are some ideas for improving the application:

- **Create Author Relation/Model**:
  - Extract the `author` field from the `Book` model into a separate `Author` model.
  - Establish a `has_many` and `belongs_to` relationship between `Author` and `Book`.
  - This will allow better management of authors and their associated books.

- **Create Genre Enum or Model/Relation**:
  - Replace the `genre` field in the `Book` model with an enum or a separate `Genre` model.
  - If using an enum:
    ```ruby
    enum :genre, { fiction: "fiction", non_fiction: "non_fiction", fantasy: "fantasy", mystery: "mystery" }, suffix: true
    ```
  - If using a `Genre` model:
    - Establish a `has_many` and `belongs_to` relationship between `Genre` and `Book`.
    - This will allow better categorization and filtering of books by genre.

---
