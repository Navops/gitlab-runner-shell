FROM gitlab/gitlab-runner:v9.2.0

# Add docker bits (from https://github.com/docker-library/docker/blob/7ef1746a46a29d89bac9aca8d0788bd629eb00e6/1.10/Dockerfile)

ENV DOCKER_BUCKET get.docker.com
ENV DOCKER_VERSION 1.10.3
ENV DOCKER_SHA256 d0df512afa109006a450f41873634951e19ddabf8c7bd419caeb5a526032d86d

RUN curl -fSL "https://${DOCKER_BUCKET}/builds/Linux/x86_64/docker-$DOCKER_VERSION" -o /usr/local/bin/docker \
	&& echo "${DOCKER_SHA256}  /usr/local/bin/docker" | sha256sum -c - \
	&& chmod +x /usr/local/bin/docker

# Prepare the image.
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install -y -qq --no-install-recommends wget unzip python python-openssl make && apt-get clean

# Custom changes
COPY entry_point.sh /
CMD ["run", "--user=gitlab-runner", "--working-directory=/home/gitlab-runner"]
ENTRYPOINT [ "/entry_point.sh" ]
# Leave the rest from gitlab-runner
