import uuid

from django.conf import settings
from django.db import models


class Room(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    name = models.CharField(max_length=255, blank=True)
    is_group = models.BooleanField(default=False)
    participants = models.ManyToManyField(settings.AUTH_USER_MODEL, related_name="rooms")
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ["-created_at"]

    def __str__(self):
        return self.name or f"Room {self.id}"

    def display_name(self, current_user):
        if self.is_group:
            return self.name or "Group Chat"
        other = self.participants.exclude(id=current_user.id).first()
        return other.username if other else "Direct Message"


class Message(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    room = models.ForeignKey(Room, related_name="messages", on_delete=models.CASCADE)
    sender = models.ForeignKey(
        settings.AUTH_USER_MODEL, related_name="messages", on_delete=models.CASCADE
    )
    content = models.TextField()
    created_at = models.DateTimeField(auto_now_add=True)
    is_read = models.BooleanField(default=False)

    class Meta:
        ordering = ["created_at"]

    def __str__(self):
        return f"{self.sender}: {self.content[:30]}"
