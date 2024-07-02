from fastapi import Request
from .config import app, dblock, view_page

@app.get("/")
@app.get("/course")
async def view_list_course(request: Request):
    with dblock() as db:
        db.execute("""
        SELECT sn AS cou_sn, name as cou_name, credit as cou_credit, credit_hour as cou_credit_hour FROM course ORDER BY name
        """)
        courses = list(db)

    
    
    with dblock() as db:
        db.execute("""
        SELECT g.stu_sn, g.cou_sn, 
            s.name as stu_name, 
            c.name as cou_name, 
            c.credit as cou_credit,
            c.credit_hour as cou_credit_hour,
            g.grade 
        FROM course_grade as g
            INNER JOIN student as s ON g.stu_sn = s.sn
            INNER JOIN course as c  ON g.cou_sn = c.sn
        ORDER BY stu_sn, cou_sn;
        """)

        items = list(db)


    return view_page(
        request, "course_list.html",  courses=courses, items=items
    )