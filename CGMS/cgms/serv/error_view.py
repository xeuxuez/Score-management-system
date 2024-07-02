from urllib.parse import urlencode
from fastapi.responses import RedirectResponse
from fastapi import Request

from .config import app, view_page


def redirect_error(message: str, return_path: str):
    query = urlencode({"message": message, "return_path": return_path})
    return RedirectResponse(url=f"/error?{query}", status_code=302)


@app.get("/error")
async def dialog_error(request: Request, message: str, return_path: str):
    return view_page(
        request, "dialog_error.html", message=message, return_path=return_path
    )
