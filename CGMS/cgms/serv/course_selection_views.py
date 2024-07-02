from fastapi import Request
from .config import app, dblock, view_page
from .error_view import redirect_error

@app.get("/")
@app.get("/cousel")
async def view_list_coursel(request: Request):
    with dblock() as db:
        db.execute("""
        SELECT sn AS cla_sn, no as cla_no, name as cla_name,
             term as cla_term, place as cla_place, course as cla_course FROM classes ORDER BY name
        """)

        classesl = list(db)
    

    with dblock() as db:
        db.execute("""
        SELECT g.stu_sn,  
            s.name as stu_name, 
            cl.sn as cla_sn, 
            cl.no as cla_no, cl.name as cla_name,
            cl.term as cla_term, cl.place as cla_place, cl.course as cla_course,
            g.grade 
        FROM classes_grade as g
            INNER JOIN student as s ON g.stu_sn = s.sn
            INNER JOIN classes as cl  ON g.cla_sn = cl.sn
        ORDER BY stu_sn,cla_sn;
        """)

        items = list(db)
    
    with dblock() as db:
        db.execute("""
        SELECT sn AS stu_sn, name as stu_name FROM student ORDER BY name
        """)
        students = list(db)

    
    return view_page(
        request, "cousel_list.html",  classesl=classesl, items=items, students=students
    )


@app.get("/cousel/edit/{cla_sn}/{stu_sn}")
def view_grade_editor(stu_sn: int, cla_sn: int, request: Request):
    with dblock() as db:
        db.execute(
            """
            SELECT g.stu_sn, g.cla_sn, 
            s.name as stu_name, 
            cl.name as cla_name, 
            g.grade 
        FROM classes_grade as g
            INNER JOIN student as s ON g.stu_sn = s.sn
            INNER JOIN classes as cl  ON g.cla_sn = cl.sn
        WHERE stu_sn = %(stu_sn)s AND cla_sn = %(cla_sn)s;
        """,
            dict(stu_sn=stu_sn, cla_sn=cla_sn),
        )

        record = db.fetchone()

    if record is None:
        return redirect_error(f"无此学生{stu_sn}的课程{cla_sn}成绩", return_path="/")

    return view_page(
        request, "cousel_edit.html", stu_sn=stu_sn, cla_sn=cla_sn, grade=record.grade
    )


@app.get("/cousel/delete/{cla_sn}/{stu_sn}")
def cousel_deletion_dialog(request: Request, stu_sn: int, cla_sn: int):
    with dblock() as db:
        db.execute(
            """
        SELECT g.stu_sn,  
            s.name as stu_name, 
            cl.sn as cla_sn, 
            cl.no as cla_no, cl.name as cla_name,
            cl.term as cla_term, cl.place as cla_place, cl.course as cla_course,
            g.grade 
        FROM classes_grade as g
            INNER JOIN student as s ON g.stu_sn = s.sn
            INNER JOIN classes as cl  ON g.cla_sn = cl.sn
        
        WHERE stu_sn = %(stu_sn)s AND cla_sn = %(cla_sn)s;
        """,
            dict(stu_sn=stu_sn, cla_sn=cla_sn),
        )

        record = db.fetchone()

    if record is None:
        return redirect_error(f"无此学生{stu_sn}的课程{cla_sn}成绩", return_path="/")

    return view_page(request, "cousel_dialog_deletion.html", record=record)