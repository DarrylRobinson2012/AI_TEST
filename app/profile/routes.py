from __future__ import annotations

from flask import render_template, request, redirect, url_for, flash
from flask_login import login_required, current_user

from .. import db
from ..models import User
from . import profile_bp


@profile_bp.route("/")
@login_required
def view_profile():
    return render_template("profile/profile.html", user=current_user)


@profile_bp.route("/edit", methods=["GET", "POST"])
@login_required
def edit_profile():
    if request.method == "POST":
        current_user.name = request.form.get("name", current_user.name)
        current_user.bio = request.form.get("bio", current_user.bio)
        current_user.phone = request.form.get("phone", current_user.phone)
        db.session.commit()
        flash("Profile updated.", "success")
        return redirect(url_for("profile.view_profile"))
    return render_template("profile/edit.html", user=current_user)
