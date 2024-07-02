from fastapi import Form
from fastapi.responses import RedirectResponse
from psycopg.errors import UniqueViolation, ForeignKeyViolation

from .config import app, dblock
from .error_view import redirect_error


@app.post("/action/cousel/add")
async def action_cousel_add(
    cla_sn: int = Form(...), stu_sn: int = Form(...), grade: float = Form(...)
):
    try:
        with dblock() as db:
            db.execute(
                """
                INSERT INTO classes_grade (stu_sn, cla_sn, grade) 
                VALUES ( %(stu_sn)s, %(cla_sn)s, %(grade)s)
                """,
                dict(stu_sn=stu_sn, cla_sn=cla_sn, grade=grade),
            )
    except UniqueViolation:
        return redirect_error(f"学生{stu_sn}的课程{cla_sn}成绩已添加", return_path="/")
    except ForeignKeyViolation as ex:
        return redirect_error(f"无此学生或课程: {ex}", return_path="/cousel")

    return RedirectResponse(url="/cousel", status_code=302)


@app.post("/action/cousel/edit/{cla_sn}/{stu_sn}")
async def edit_cousel_action( cla_sn: int, stu_sn: int, grade: float = Form(...)):
    with dblock() as db:
        db.execute(
            """
            UPDATE classes_grade SET grade=%(grade)s
            WHERE stu_sn = %(stu_sn)s AND cla_sn = %(cla_sn)s
            """,
            dict(stu_sn=stu_sn, cla_sn=cla_sn, grade=grade),
        )

    return RedirectResponse(url="/cousel", status_code=302)


@app.post("/action/cousel/delete/{cla_sn}/{stu_sn}")
def delete_cousel_action(cla_sn: int, stu_sn: int):
    with dblock() as db:
        db.execute(
            """
            DELETE FROM classes_grade
                WHERE stu_sn = %(stu_sn)s AND cla_sn = %(cla_sn)s
            """,
            dict(stu_sn=stu_sn, cla_sn=cla_sn),
        )

    return RedirectResponse(url="/cousel", status_code=302)
