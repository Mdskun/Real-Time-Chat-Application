from rest_framework import serializers

from accounts.serializers import UserSerializer
from .models import Message, Room


class MessageSerializer(serializers.ModelSerializer):
    id = serializers.UUIDField(format='hex_verbose', read_only=True)
    room = serializers.CharField(source="room.id", read_only=True)
    sender = UserSerializer(read_only=True)

    class Meta:
        model = Message
        fields = ("id", "room", "sender", "content", "created_at")
        read_only_fields = ("id", "sender", "created_at")


class RoomSerializer(serializers.ModelSerializer):
    participants = UserSerializer(many=True, read_only=True)
    last_message = serializers.SerializerMethodField()
    display_name = serializers.SerializerMethodField()

    class Meta:
        model = Room
        fields = (
            "id",
            "name",
            "is_group",
            "participants",
            "created_at",
            "last_message",
            "display_name",
        )

    def get_last_message(self, obj):
        last = obj.messages.order_by("-created_at").first()
        return MessageSerializer(last).data if last else None

    def get_display_name(self, obj):
        request = self.context.get("request")
        if request:
            return obj.display_name(request.user)
        return obj.name
