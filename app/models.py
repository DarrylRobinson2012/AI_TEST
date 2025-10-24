from __future__ import annotations

from datetime import datetime, timedelta
from typing import Optional

from flask_login import UserMixin
from werkzeug.security import check_password_hash, generate_password_hash

from . import db, login_manager


class BaseModel(db.Model):
    __abstract__ = True
    id = db.Column(db.Integer, primary_key=True)
    created_at = db.Column(db.DateTime, default=datetime.utcnow, nullable=False)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)


class User(UserMixin, BaseModel):
    __tablename__ = "users"

    email = db.Column(db.String(255), unique=True, nullable=False, index=True)
    password_hash = db.Column(db.String(255), nullable=False)
    name = db.Column(db.String(120), nullable=False, default="")
    bio = db.Column(db.Text, default="")
    phone = db.Column(db.String(40), default="")
    is_admin = db.Column(db.Boolean, default=False, nullable=False)

    bookings = db.relationship("Booking", backref="user", lazy=True)
    sent_messages = db.relationship(
        "Message", foreign_keys="Message.sender_id", backref="sender", lazy=True
    )
    received_messages = db.relationship(
        "Message", foreign_keys="Message.receiver_id", backref="receiver", lazy=True
    )
    posts = db.relationship("Post", backref="author", lazy=True)

    def set_password(self, password: str) -> None:
        self.password_hash = generate_password_hash(password)

    def check_password(self, password: str) -> bool:
        return check_password_hash(self.password_hash, password)

    def get_id(self) -> str:
        return str(self.id)


@login_manager.user_loader
def load_user(user_id: str) -> Optional["User"]:
    return User.query.get(int(user_id))


class Booking(BaseModel):
    __tablename__ = "bookings"

    SERVICE_CHOICES = ("lesson", "therapy", "performance")

    user_id = db.Column(db.Integer, db.ForeignKey("users.id"), nullable=False)
    service_type = db.Column(db.String(20), nullable=False)
    start_time = db.Column(db.DateTime, nullable=False)
    end_time = db.Column(db.DateTime, nullable=False)
    status = db.Column(db.String(20), default="pending", nullable=False)
    notes = db.Column(db.Text, default="")

    def duration(self) -> timedelta:
        return self.end_time - self.start_time


class Message(BaseModel):
    __tablename__ = "messages"

    sender_id = db.Column(db.Integer, db.ForeignKey("users.id"), nullable=False)
    receiver_id = db.Column(db.Integer, db.ForeignKey("users.id"), nullable=False)
    body = db.Column(db.Text, nullable=False)
    read = db.Column(db.Boolean, default=False, nullable=False)


class Post(BaseModel):
    __tablename__ = "posts"

    author_id = db.Column(db.Integer, db.ForeignKey("users.id"), nullable=False)
    title = db.Column(db.String(200), nullable=False)
    body = db.Column(db.Text, nullable=False)
    is_published = db.Column(db.Boolean, default=True, nullable=False)
