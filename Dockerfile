FROM openshift/base-centos7
LABEL maintainer="Adam Bien, adam-bien.com" description="Payara5 Micro S2I for OpenShift"
ENV JAVA_HOME /usr/lib/jvm/java-1.8.0
ENV PATH "$PATH":/${JAVA_HOME}/bin:.:
ENV VERSION 5.192
ENV PAYARA_JAR payara-micro-${VERSION}.jar
ENV INSTALL_DIR /opt
ENV LIB_DIR ${INSTALL_DIR}/lib
ENV DEPLOYMENT_DIR ${INSTALL_DIR}/deploy
ENV BUILDER_VERSION 0.0.1
RUN yum update -y \
  && yum -y install unzip \
  && yum -y install java-1.8.0-openjdk-devel \
  && yum clean all
RUN curl -o ${INSTALL_DIR}/${PAYARA_JAR} -L https://s3-eu-west-1.amazonaws.com/payara.fish/Payara+Downloads/${VERSION}/${PAYARA_JAR}
RUN mkdir -p ${DEPLOYMENT_DIR} \
    mkdir -p ${LIB_DIR} \
    && chown -R 1001:0 ${INSTALL_DIR} \
    && chmod -R a+rw ${INSTALL_DIR}
EXPOSE 8080 8181
LABEL io.k8s.description="Payara Micro S2I Image" \
      io.k8s.display-name="Payara Micro S2I Builder" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,airhacks,payara,payara micro,javaee,microprofile"
	  
COPY ./s2i/bin/ /usr/libexec/s2i
RUN chmod -R a+x /usr/libexec/s2i

USER 1001

