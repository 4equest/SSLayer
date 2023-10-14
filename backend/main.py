"""hello world
"""
import uvicorn
from fastapi import FastAPI, Form
from fastapi.templating import Jinja2Templates
from fastapi.responses import PlainTextResponse, HTMLResponse
from fastapi.requests import Request


app = FastAPI()
templates = Jinja2Templates(directory="templates")


@app.get('/', response_class=HTMLResponse)
def root(request: Request):
    """画面表示

    Args:
        request (Request): request    
    Returns:
        TemplateResponse: index.html
    """
    return templates.TemplateResponse('index.html', {'request': request})


@app.post('/hello', response_class=PlainTextResponse)
def hello(name: str = Form()):
    """文字列表示

    Args:
        name (string): 名前
    Returns:
        string: 表示文字列
    """
    return 'こんにちは、'+name+'さん'


if __name__ == '__main__':
    uvicorn.run(app)

