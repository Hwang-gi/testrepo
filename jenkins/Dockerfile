# Stage 1: Build stage
FROM alpine:3.14 AS build

# TOMCAT VERSION, HOME DIRECTORY 환경변수 설정
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk
ENV TOMCAT_VERSION=9.0.93
ENV CATALINA_HOME=/usr/local/tomcat
ENV JAVA_OPTS="-Djava.awt.headless=true -Djenkins.model.Jenkins.installState=UNINITIALIZED -Dhttp.port=9090"

# 필요한 Package 설치
RUN apk update && \
    apk add --no-cache wget tar openjdk11-jre ttf-dejavu && \
    rm -rf /var/cache/apk/*

# TOMCAT 설치 및 설치파일 삭제
RUN mkdir $CATALINA_HOME \
        && wget https://archive.apache.org/dist/tomcat/tomcat-9/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz -O /tmp/tomcat.tar.gz
RUN cd /tmp && tar xfz tomcat.tar.gz \
        && cp -Rv /tmp/apache-tomcat-${TOMCAT_VERSION}/* $CATALINA_HOME \
        && rm -rf /tmp/apache-tomcat-${TOMCAT_VERSION} \
        && rm -rf /tmp/tomcat.tar.gz \
        && wget https://repo1.maven.org/maven2/org/mariadb/jdbc/mariadb-java-client/3.4.1/mariadb-java-client-3.4.1.jar -P $CATALINA_HOME/lib 

# 불필요한 파일 삭제
RUN rm -rf $CATALINA_HOME/webapps/* \
    && rm -rf $CATALINA_HOME/bin/*.bat \
    && rm -rf $CATALINA_HOME/bin/*.tar.gz \
    && rm -rf $CATALINA_HOME/bin/*.md5 \
    && rm -rf $CATALINA_HOME/bin/*.sha512
    
RUN wget https://get.jenkins.io/war/2.460/jenkins.war -P $CATALINA_HOME/webapps \ 
    && mkdir $CATALINA_HOME/webapps/ROOT

# MariaDB 정보 저장
COPY setenv.sh $CATALINA_HOME/bin
COPY context.xml $CATALINA_HOME/conf
COPY tomcat-user.xml $CATALINA_HOME/conf
COPY test.jsp $CATALINA_HOME/webapps/ROOT

# /usr/local/tomcat/bin/catalina.sh 파일에 실행 권한 추가
RUN chmod +x $CATALINA_HOME/bin/catalina.sh && \
    chmod +x $CATALINA_HOME/bin/setenv.sh

# Stage 2 :RunTime Stage
FROM alpine:3.14

# TOMCAT 실행을 위한 JDK 설치
RUN apk add --no-cache openjdk11-jre && \
    rm -rf /var/cache/apk/*

# TOMCAT HOME DIRECTORY , 시간설정 환경변수 설정
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk
ENV CATALINA_HOME=/usr/local/tomcat
RUN apk add --no-cache tzdata ttf-dejavu
ENV TZ=Asia/Seoul

#  Java 프로그램이 실행될 때 클래스 파일을 찾는 경로를 지정
ENV CLASSPATH .:$JAVA_HOME/jre/lib/ext:$JAVA_HOME/lib/tools.jar:$CATALINA_HOME/lib/\
jsp-api.jar:$CATALINA_HOME/lib/servlet-api.jar:$CATALINA_HOME/lib/mariadb-java-client-3.4.1.jar
ENV JAVA_OPTS="-Djava.awt.headless=true -Djenkins.model.Jenkins.installState=UNINITIALIZED -Dhttp.port=9090"

# Stage 1 에서 설치한 TOMCAT 및 메인페이지 복사
COPY --from=build $CATALINA_HOME $CATALINA_HOME

# 포트번호 노출
EXPOSE 8080 9090

# TOMCAT 실행
CMD ["/usr/local/tomcat/bin/catalina.sh", "run"]
