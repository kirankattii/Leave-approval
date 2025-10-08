"""
Railway entry point - redirects to app.main
This file exists so Railway's Railpack can auto-detect the FastAPI app
"""
from app.main import app

__all__ = ["app"]

