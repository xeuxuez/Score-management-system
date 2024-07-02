from fastapi import Form
from fastapi.responses import RedirectResponse
from psycopg.errors import UniqueViolation, ForeignKeyViolation

from .config import app, dblock
from .error_view import redirect_error


@app.post("/action/grade/add")
async def action_grade_add(
    stu_sn: int = Form(...), cou_sn: int = Form(...), grade: float = Form(...)
):
    try:
        with dblock() as db:
            db.execute(
                """
                INSERT INTO course_grade (stu_sn, cou_sn, grade) 
                VALUES ( %(stu_sn)s, %(cou_sn)s, %(grade)s)
                """,
                dict(stu_sn=stu_sn, cou_sn=cou_sn, grade=grade),
            )
    except UniqueViolation:
        return redirect_error(f"学生{stu_sn}的课程{cou_sn}成绩已添加", return_path="/")
    except ForeignKeyViolation as ex:
        return redirect_error(f"无此学生或课程: {ex}", return_path="/")

    return RedirectResponse(url="/", status_code=302)


@app.post("/action/grade/edit/{stu_sn}/{cou_sn}")
async def edit_grade_action(stu_sn: int, cou_sn: int, grade: float = Form(...)):
    with dblock() as db:
        db.execute(
            """
            UPDATE course_grade SET grade=%(grade)s
            WHERE stu_sn = %(stu_sn)s AND cou_sn = %(cou_sn)s
            """,
            dict(stu_sn=stu_sn, cou_sn=cou_sn, grade=grade),
        )

    return RedirectResponse(url="/", status_code=302)


@app.post("/action/grade/delete/{stu_sn}/{cou_sn}")
def delete_grade_action(stu_sn: int, cou_sn: int):
    with dblock() as db:
        db.execute(
            """
            DELETE FROM course_grade
                WHERE stu_sn = %(stu_sn)s AND cou_sn = %(cou_sn)s
            """,
            dict(stu_sn=stu_sn, cou_sn=cou_sn),
        )

    return RedirectResponse(url="/", status_code=302)
