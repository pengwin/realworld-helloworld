docker build -t draw-diagrams ./doc/diagrams/src
docker run --rm -it -v ./doc/diagrams/output:/output draw-diagrams