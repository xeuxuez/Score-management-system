from fastapi import Request
from .config import app, dblock, view_page
from .error_view import redirect_error

@app.get("/")
@app.get("/grade")
async def view_list_grades(request: Request):
    with dblock() as db:
        db.execute("""
        SELECT sn AS stu_sn, name as stu_name FROM student ORDER BY name
        """)
        students = list(db)

    with dblock() as db:
        db.execute("""
        SELECT sn AS cou_sn, name as cou_name FROM course ORDER BY name
        """)
        courses = list(db)

    with dblock() as db:
        db.execute("""
        SELECT g.stu_sn, g.cou_sn, 
            s.name as stu_name, 
            c.name as cou_name, 
            g.grade 
        FROM course_grade as g
            INNER JOIN student as s ON g.stu_sn = s.sn
            INNER JOIN course as c  ON g.cou_sn = c.sn
        ORDER BY stu_sn, cou_sn;
        """)

        items = list(db)

    return view_page(
        request, "grade_list.html", students=students, courses=courses, items=items
    )


@app.get("/grade/edit/{stu_sn}/{cou_sn}")
def view_grade_editor(stu_sn: int, cou_sn: int, request: Request):
    with dblock() as db:
        db.execute(
            """
            SELECT grade FROM course_grade
                WHERE stu_sn = %(stu_sn)s AND cou_sn = %(cou_sn)s;
            """,
            dict(stu_sn=stu_sn, cou_sn=cou_sn),
        )

        record = db.fetchone() 

    if record is None:
        return redirect_error(f"无此学生{stu_sn}的课程{cou_sn}成绩", return_path="/")

    return view_page(
        request, "grade_edit.html", stu_sn=stu_sn, cou_sn=cou_sn, grade=record.grade
    )


@app.get("/grade/delete/{stu_sn}/{cou_sn}")
def grade_deletion_dialog(request: Request, stu_sn: int, cou_sn: int):
    with dblock() as db:
        db.execute(
            """
        SELECT g.stu_sn, g.cou_sn, 
            s.name as stu_name, 
            c.name as cou_name, 
            g.grade 
        FROM course_grade as g
            INNER JOIN student as s ON g.stu_sn = s.sn
            INNER JOIN course as c  ON g.cou_sn = c.sn
        WHERE stu_sn = %(stu_sn)s AND cou_sn = %(cou_sn)s;
        """,
            dict(stu_sn=stu_sn, cou_sn=cou_sn),
        )

        record = db.fetchone()

    if record is None:
        return redirect_error(f"无此学生{stu_sn}的课程{cou_sn}成绩", return_path="/")

    return view_page(request, "grade_dialog_deletion.html", record=record)
