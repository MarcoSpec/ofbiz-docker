FROM openjdk:8-jdk

MAINTAINER Paul Mandeltort
RUN apt-get update && apt-get upgrade -y && apt-get clean

## Clone/Checkout OFbiz from github
WORKDIR /

RUN mkdir /ofbiz && svn checkout http://svn.apache.org/repos/asf/ofbiz/branches/release16.11 /ofbiz

## compile ofbiz
WORKDIR /ofbiz

### set default 2G memory for OFBiz. 
ENV JAVA_OPTS -Xmx2G 

RUN ./gradlew cleanAll loadDefault

##for passing in entity engine config - maybe replace with copy?
VOLUME /ofbiz/framework/entity/config/

##for Derby Database
VOLUME /ofbiz/runtime/data

EXPOSE 8443 8080

ENTRYPOINT ./gradlew ofbiz
