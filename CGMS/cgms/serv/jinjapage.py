from fastapi import Request
from fastapi.templating import Jinja2Templates
from dataclasses import dataclass

templates = Jinja2Templates(directory="./templates")


@dataclass
class PageLocation:
    pathname: str


def view_page(request: Request, filename: str, **kwargs):
    location = PageLocation(request.url.path)
    print(location)
    return templates.TemplateResponse(
        filename, dict(request=request, location=location, **kwargs)
    )
