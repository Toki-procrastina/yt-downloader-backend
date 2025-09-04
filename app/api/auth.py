from fastapi import APIRouter, Depends, HTTPException, status, Request
from datetime import datetime, timedelta
from slowapi import Limiter
from slowapi.util import get_remote_address
import logging

from app.models.schemas import LoginRequest, Token
from app.core.auth import authenticate_user, create_access_token
from app.core.config import settings

router = APIRouter(
    prefix="/auth",
    tags=["authentication"]
)

limiter = Limiter(key_func=get_remote_address)
logger = logging.getLogger(__name__)

@router.post("/login", response_model=Token)
@limiter.limit(f"{settings.rate_limit_requests}/minute")
async def login(request: Request, login_data: LoginRequest):
    """Autenticar usuario y obtener token"""
    user = authenticate_user(login_data.username, login_data.password)
    if not user:
        logger.warning(f"Intento de login fallido desde {request.client.host}")
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Credenciales incorrectas",
            headers={"WWW-Authenticate": "Bearer"},
        )
    
    access_token_expires = timedelta(minutes=settings.access_token_expire_minutes)
    access_token = create_access_token(
        data={"sub": user.username}, expires_delta=access_token_expires
    )
    
    logger.info(f"Login exitoso para usuario {user.username} desde {request.client.host}")
    return {"access_token": access_token, "token_type": "bearer"}
