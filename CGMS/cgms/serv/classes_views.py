from fastapi import Request
from .config import app, dblock, view_page

@app.get("/")
@app.get("/classes")
async def view_list_classes(request: Request):
    with dblock() as db:
        db.execute("""
        SELECT sn AS cla_sn, no as cla_no, name as cla_name,
             term as cla_term, place as cla_place, course as cla_course FROM classes ORDER BY name
        """)

        classesl = list(db)

    
    print(classesl)
    return view_page(
        request, "classes_list.html",  classesl=classesl
    )