from __future__ import annotations

from flask import render_template, request, redirect, url_for, flash
from flask_login import login_required, current_user

from .. import db
from ..models import Post
from . import content_bp


@content_bp.route("/feed")
def feed():
    posts = Post.query.filter_by(is_published=True).order_by(Post.created_at.desc()).all()
    return render_template("content/feed.html", posts=posts)


@content_bp.route("/create", methods=["GET", "POST"])
@login_required
def create_post():
    if not current_user.is_admin:
        flash("Only admin can create posts.", "danger")
        return redirect(url_for("content.feed"))

    if request.method == "POST":
        title = request.form.get("title", "").strip()
        body = request.form.get("body", "").strip()
        if not title or not body:
            flash("Title and body are required.", "danger")
            return render_template("content/create.html")
        post = Post(author_id=current_user.id, title=title, body=body)
        db.session.add(post)
        db.session.commit()
        flash("Post created.", "success")
        return redirect(url_for("content.feed"))

    return render_template("content/create.html")
