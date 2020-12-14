docker pull ubuntu:18.04
docker images
docker run --name ubuntu18 -d ubuntu:18.04
docker ps
docker exec -it ubuntu18 bash
