FROM python:3.12-slim-bookworm

# pip换国内清华的源
RUN python -m pip install -i https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple --upgrade pip \
&& python -m pip config set global.index-url https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple

# 安装项目依赖库
WORKDIR /code
COPY /your_project/requirements.txt /code/requirements.txt
RUN python -m pip install --no-cache-dir --upgrade -r /code/requirements.txt

# 启动项目
WORKDIR /code/app
CMD ["command","command_args"]