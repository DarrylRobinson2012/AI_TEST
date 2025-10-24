from __future__ import annotations

import os
from datetime import datetime
from flask import Flask, redirect, url_for
from flask_sqlalchemy import SQLAlchemy
from flask_login import LoginManager

# Global extensions

db = SQLAlchemy()
login_manager = LoginManager()
login_manager.login_view = "auth.login"


def create_app() -> Flask:
    app = Flask(__name__, instance_relative_config=False)

    # Basic configuration
    app.config["SECRET_KEY"] = os.getenv("SECRET_KEY", "dev-secret-key")
    db_path = os.getenv("DATABASE_URL", "sqlite:///app.db")
    app.config["SQLALCHEMY_DATABASE_URI"] = db_path
    app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False

    # Init extensions
    db.init_app(app)
    login_manager.init_app(app)

    # Import models to register with SQLAlchemy
    from .models import User  # noqa: F401

    # Blueprints
    from .auth.routes import auth_bp
    from .bookings.routes import bookings_bp
    from .messages.routes import messages_bp
    from .profile.routes import profile_bp
    from .content.routes import content_bp

    app.register_blueprint(auth_bp, url_prefix="/auth")
    app.register_blueprint(bookings_bp, url_prefix="/bookings")
    app.register_blueprint(messages_bp, url_prefix="/messages")
    app.register_blueprint(profile_bp, url_prefix="/profile")
    app.register_blueprint(content_bp, url_prefix="/content")

    @app.route("/")
    def index():
        return redirect(url_for("content.feed"))

    # CLI commands
    @app.cli.command("init-db")
    def init_db_command():
        """Initialize the database tables."""
        from .models import BaseModel  # noqa: F401
        db.create_all()
        print("Initialized the database.")

    @app.cli.command("seed")
    def seed_command():
        """Seed the database with an admin user and sample posts."""
        from .models import User, Post
        db.create_all()
        admin_email = os.getenv("ADMIN_EMAIL", "admin@example.com")
        admin_password = os.getenv("ADMIN_PASSWORD", "admin123")
        admin = User.query.filter_by(email=admin_email).first()
        if not admin:
            admin = User(email=admin_email, name="Admin", is_admin=True)
            admin.set_password(admin_password)
            db.session.add(admin)
            db.session.commit()
            print(f"Created admin user: {admin_email} / {admin_password}")
        # Seed posts if none
        if Post.query.count() == 0:
            posts = [
                Post(
                    author_id=admin.id,
                    title="Welcome to Water Training",
                    body=(
                        "This app lets you book swimming lessons, aqua therapy, and "
                        "performance water training."
                    ),
                ),
                Post(
                    author_id=admin.id,
                    title="Water Safety Basics",
                    body=(
                        "Always swim with a buddy, know your limits, and follow pool rules."
                    ),
                ),
            ]
            db.session.add_all(posts)
            db.session.commit()
            print("Seeded example posts.")
        print("Seeding complete.")

    return app
