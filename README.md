# Water Training Booking App

A Flask web app for customers to book swimming lessons, aqua therapy, and performance water training. Includes calendar booking, messaging, user profiles, and an informational content feed.

## Features
- Booking for: Swimming Lesson, Aqua Therapy, Performance Training
- Calendar page to request bookings and view your schedule
- Messaging between users (you and clients)
- User profile with editable details
- Content feed for water safety and stroke mechanics posts (admin can publish)

## Quickstart

### Prerequisites
- Python 3.10+ (Python 3.13 tested)

### Setup
1. Install dependencies:
   ```bash
   python3 -m pip install --user -r requirements.txt
   ```
   If you prefer a virtual environment and it's available on your system:
   ```bash
   python3 -m venv .venv && source .venv/bin/activate && pip install -r requirements.txt
   ```

2. Initialize and seed the database:
   ```bash
   python3 -m flask --app wsgi init-db
   python3 -m flask --app wsgi seed
   ```
   This creates an admin user:
   - Email: `admin@example.com`
   - Password: `admin123`

3. Run the app:
   ```bash
   python3 wsgi.py
   ```
   Open `http://localhost:5000` in your browser.

## Configuration
Environment variables (optional):
- `SECRET_KEY`: Flask session secret (default: `dev-secret-key`)
- `DATABASE_URL`: SQLAlchemy DB URL (default: `sqlite:///app.db`)
- `ADMIN_EMAIL`: Admin seed email (default: `admin@example.com`)
- `ADMIN_PASSWORD`: Admin seed password (default: `admin123`)

## Project Structure
```
app/
  __init__.py
  models.py
  auth/
    __init__.py
    routes.py
  bookings/
    __init__.py
    routes.py
  messages/
    __init__.py
    routes.py
  profile/
    __init__.py
    routes.py
  content/
    __init__.py
    routes.py
  templates/
    base.html
    auth/
      login.html
      register.html
    bookings/
      calendar.html
    messages/
      inbox.html
    profile/
      profile.html
      edit.html
    content/
      feed.html
      create.html
  static/
    css/styles.css
    js/app.js
wsgi.py
requirements.txt
```

## Notes
- Booking conflict checks are basic (user-level). You can extend to coach availability and resource constraints.
- Messaging is a simple in-app inbox; consider WebSocket or polling for real-time features later.
- Content creation is restricted to admin users.

## Next Steps
- Add admin dashboard to approve/decline bookings
- Add availability management and time-slot generation
- Email notifications for bookings and messages
- File uploads for profile photos and content images
