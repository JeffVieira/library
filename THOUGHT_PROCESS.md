## 🧠 Thought Process

1. **Project Setup & Authentication**  
   I started by creating the project and setting up authentication using the `rails generate authorization` command. I implemented JWT-based authentication to handle secure user login and token management, which fits well with an API-only application.

2. **Book Entity**  
   Next, I created the `Book` model to manage the main entity of the app. This included fields like title, author, genre, ISBN, and available copies, allowing full CRUD operations on books.

3. **Permissions with RBAC (Role-Based Access Control)**  
   I implemented a permission system using the `pundit_roles` gem to define roles and access levels. This approach made it easy to separate permissions between admins and members, and felt like a good fit for the scope and complexity of the challenge.

4. **Borrow and Return Logic**  
   I built the borrow and return features by establishing a many-to-many relationship between users and books via a `borrows` table. This table stores relevant data like the borrowing user, the book, return status, and due date.

5. **Dashboard by User Role**  
   I created a dynamic dashboard that adapts its content based on the user’s role. For admins, it shows totals, due books, and members with overdue items. For members, it displays borrowed and overdue books.

6. **Serialization Layer**  
   I added a serialization layer using `ActiveModel::Serializer` to structure JSON responses. This helps keep the presentation logic clean and manageable while enabling flexible output based on the context (e.g., different views for admin vs member).

7. **API Documentation & Testing**  
   Finally, I documented the API endpoints and provided a Postman collection. I included instructions for setting up environment variables (like the JWT token and base URL) to simplify testing.
