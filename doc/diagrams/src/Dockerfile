FROM ubuntu:20.04
RUN apt-get update && apt-get install -y python3.9 python3.9-dev graphviz
RUN apt-get install -y python3-pip
COPY . .
RUN pip install diagrams
CMD ["python3", "draw.py"]