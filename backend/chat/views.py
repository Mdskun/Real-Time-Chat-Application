from django.contrib.auth import get_user_model
from django.shortcuts import get_object_or_404
from rest_framework import generics, permissions, status
from rest_framework.response import Response
from rest_framework.views import APIView

from .models import Message, Room
from .serializers import MessageSerializer, RoomSerializer

User = get_user_model()


class RoomListCreateView(generics.ListCreateAPIView):
    serializer_class = RoomSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        return Room.objects.filter(participants=self.request.user)

    def create(self, request, *args, **kwargs):
        user_ids = request.data.get("participant_ids", [])
        is_group = request.data.get("is_group", False)
        name = request.data.get("name", "")

        if not is_group and len(user_ids) == 1:
            existing = (
                Room.objects.filter(is_group=False, participants=request.user)
                .filter(participants__id=user_ids[0])
                .first()
            )
            if existing:
                return Response(
                    RoomSerializer(existing, context={"request": request}).data,
                    status=status.HTTP_200_OK,
                )

        room = Room.objects.create(name=name, is_group=is_group)
        room.participants.add(request.user, *user_ids)
        return Response(
            RoomSerializer(room, context={"request": request}).data,
            status=status.HTTP_201_CREATED,
        )


class RoomDetailView(generics.RetrieveAPIView):
    serializer_class = RoomSerializer
    permission_classes = [permissions.IsAuthenticated]
    queryset = Room.objects.all()

    def get_queryset(self):
        return Room.objects.filter(participants=self.request.user)


class MessageListView(generics.ListAPIView):
    serializer_class = MessageSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        room = get_object_or_404(
            Room, id=self.kwargs["room_id"], participants=self.request.user
        )
        return room.messages.select_related("sender").all()


class MarkReadView(APIView):
    permission_classes = [permissions.IsAuthenticated]

    def post(self, request, room_id):
        room = get_object_or_404(Room, id=room_id, participants=request.user)
        room.messages.exclude(sender=request.user).update(is_read=True)
        return Response(status=status.HTTP_204_NO_CONTENT)
