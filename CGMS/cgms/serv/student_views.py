from fastapi import Request
from .config import app, view_page
from .config import app, dblock, view_page
from .error_view import redirect_error
from fastapi.responses import FileResponse



@app.get("/student")
async def view_student_list(request: Request):
     with dblock() as db:
        db.execute("""
        SELECT * FROM student ORDER BY name
        """)
        items = list(db)

     return view_page(
        request, "student_list.html",  items=items
    )

@app.get("/detail/{sn}")
def gradedetail(request: Request, sn: int):
    record = None
    record1 = None
    with dblock() as db:
        db.execute(
            """
            SELECT name FROM student
            WHERE sn = %(sn)s ;
            """,
            dict(sn=sn),
        )
        studen = db.fetchone()
        if studen:
           print(studen)
           studen = studen.name
    with dblock() as db:
        db.execute(
            """
            SELECT grade FROM course_grade
            WHERE stu_sn = %(sn)s ;
            """,
            dict(sn=sn),
        )
        row = db.fetchone()
        if row:
           print(row)
           record = row.grade
        
    with dblock() as db:
        db.execute(
            """
            SELECT grade FROM classes_grade
            WHERE stu_sn = %(sn)s ;
            """,
            dict(sn=sn),
        )
        row1 = db.fetchone()
        
        if row1:
            record1 = row1.grade
    
    return view_page(request, "studentdetail.html", record1=record1, record=record,studen=studen)


