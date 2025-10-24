from __future__ import annotations

from flask import render_template, request, redirect, url_for, flash
from flask_login import login_required, current_user

from .. import db
from ..models import Message, User
from . import messages_bp


@messages_bp.route("/")
@login_required
def inbox():
    conversations = (
        db.session.query(User)
        .filter(User.id != current_user.id)
        .order_by(User.name.asc())
        .all()
    )
    messages = (
        Message.query.filter(
            (Message.sender_id == current_user.id) | (Message.receiver_id == current_user.id)
        )
        .order_by(Message.created_at.desc())
        .limit(50)
        .all()
    )
    return render_template(
        "messages/inbox.html", conversations=conversations, messages=messages
    )


@messages_bp.route("/send", methods=["POST"])
@login_required
def send_message():
    receiver_id = int(request.form.get("receiver_id"))
    body = request.form.get("body", "").strip()
    if not body:
        flash("Message cannot be empty.", "danger")
        return redirect(url_for("messages.inbox"))

    receiver = User.query.get(receiver_id)
    if not receiver:
        flash("User not found.", "danger")
        return redirect(url_for("messages.inbox"))

    msg = Message(sender_id=current_user.id, receiver_id=receiver_id, body=body)
    db.session.add(msg)
    db.session.commit()
    flash("Message sent.", "success")
    return redirect(url_for("messages.inbox"))
