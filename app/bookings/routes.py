from __future__ import annotations

from datetime import datetime, timedelta

from flask import render_template, request, redirect, url_for, flash
from flask_login import login_required, current_user

from .. import db
from ..models import Booking
from . import bookings_bp


@bookings_bp.route("/calendar")
@login_required
def calendar_view():
    # Show user's bookings and a simple calendar form
    user_bookings = (
        Booking.query.filter_by(user_id=current_user.id)
        .order_by(Booking.start_time.desc())
        .all()
    )
    return render_template("bookings/calendar.html", bookings=user_bookings)


@bookings_bp.route("/create", methods=["POST"])
@login_required
def create_booking():
    service_type = request.form.get("service_type")
    start = request.form.get("start_time")
    duration_minutes = int(request.form.get("duration", "60"))
    notes = request.form.get("notes", "")

    if service_type not in Booking.SERVICE_CHOICES:
        flash("Invalid service type.", "danger")
        return redirect(url_for("bookings.calendar_view"))

    try:
        start_dt = datetime.fromisoformat(start)
    except Exception:
        flash("Invalid start time.", "danger")
        return redirect(url_for("bookings.calendar_view"))

    end_dt = start_dt + timedelta(minutes=duration_minutes)

    # Naive conflict check for user
    conflict = (
        Booking.query.filter(Booking.user_id == current_user.id)
        .filter(Booking.start_time < end_dt, Booking.end_time > start_dt)
        .first()
    )
    if conflict:
        flash("Booking conflicts with an existing one.", "danger")
        return redirect(url_for("bookings.calendar_view"))

    booking = Booking(
        user_id=current_user.id,
        service_type=service_type,
        start_time=start_dt,
        end_time=end_dt,
        status="pending",
        notes=notes,
    )
    db.session.add(booking)
    db.session.commit()
    flash("Booking created and pending confirmation.", "success")
    return redirect(url_for("bookings.calendar_view"))
