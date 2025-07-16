# Library Management System

This is a Ruby on Rails-based Library Management System that allows users to borrow books, track due dates, and manage library operations. The application supports both admin and member roles, with different dashboards and functionalities for each.

---

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

- **Ruby Version**: `3.2.2` (or update `.ruby-version` if needed)
- **Rails Version**: `7.x`
- **Database**: SQLite3 (default) or PostgreSQL for production.

---

## Setup Instructions

1. **Clone the Repository**:
```bash
  git clone https://github.com/your-repo/library-management.git
  cd library-management
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

Authentication
  - Login: POST /api/v1/sign_in
  - Logout: DELETE /api/v1/sign_out

Books
  - List Books: GET /api/v1/books
  - Borrow Book: POST /api/v1/borrows
  - Return Book: PATCH /api/v1/borrows/:id

Dashboards
  - Admin Dashboard: GET /api/v1/dashboards (Admin only)
  - Member Dashboard: GET /api/v1/dashboards (Member only)

## Postman Collection

You can test the API using the Postman collection:
[Postman Workspace](https://web.postman.co/workspace/ccc6e88f-64af-47ed-87ba-7d80727dbba1)

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
