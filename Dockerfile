FROM openjdk:8-jdk-alpine as build
WORKDIR /app

COPY gradle gradle
COPY build.gradle settings.gradle gradlew ./
COPY . .
ENV DIST_ARCH=amd64 \
    DIST_OS=linux
RUN ./gradlew clean build shredder-ec2:buildDeb -x signArchives --info

FROM ubuntu:24.04
COPY --from=build /app/shredder-ec2/build/distributions/*.deb /tmp/shredder.deb
RUN dpkg -i /tmp/shredder.deb \
 && rm /tmp/shredder.deb


#ENTRYPOINT ["java","-cp","app:app/lib/*","com.example.Application"]