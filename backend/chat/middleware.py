from urllib.parse import parse_qs

from channels.auth import AuthMiddlewareStack
from channels.db import database_sync_to_async
from django.contrib.auth.models import AnonymousUser
from rest_framework_simplejwt.exceptions import InvalidToken, TokenError
from rest_framework_simplejwt.tokens import AccessToken


@database_sync_to_async
def get_user_from_token(token):
    from django.contrib.auth import get_user_model

    User = get_user_model()
    try:
        validated = AccessToken(token)
        user = User.objects.get(id=validated["user_id"])
        return user
    except (InvalidToken, TokenError, User.DoesNotExist, KeyError):
        return AnonymousUser()


class JWTAuthMiddleware:
    """Authenticate websocket connections using a JWT passed as ?token=... """

    def __init__(self, app):
        self.app = app

    async def __call__(self, scope, receive, send):
        query_string = parse_qs(scope.get("query_string", b"").decode())
        token = query_string.get("token")
        if token:
            scope["user"] = await get_user_from_token(token[0])
        else:
            scope["user"] = AnonymousUser()
        return await self.app(scope, receive, send)


def JWTAuthMiddlewareStack(app):
    return JWTAuthMiddleware(AuthMiddlewareStack(app))
