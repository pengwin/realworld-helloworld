FROM ubuntu:20.04
RUN apt-get update && apt-get install -y python3.9 python3.9-dev graphviz
RUN apt-get install -y python3-pip
RUN pip install diagrams
COPY . .
CMD ["python3", "draw.py"]