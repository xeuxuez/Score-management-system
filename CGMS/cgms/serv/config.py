import logging
from fastapi import FastAPI
from fastapi.staticfiles import StaticFiles
from .dblock import create_dpool
from .jinjapage import view_page  # noqa: F401

logging.basicConfig(level=logging.INFO, format = '%(asctime)s %(name)s %(levelname)s %(message)s')

# dblock, lifespan = create_dpool("host=localhost dbname=examdb user=examdb", min_size=4)
dblock, lifespan = create_dpool("host=localhost dbname=newdb user=postgres options='-c client_encoding=utf8'", min_size=4)
app = FastAPI(lifespan=lifespan)
app.mount("/static", StaticFiles(directory="static"), name="static")
