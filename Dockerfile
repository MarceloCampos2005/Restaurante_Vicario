FROM tomcat:10.1.39

RUN rm -rf /usr/local/tomcat/webapps/*

# Copia o WAR gerado para o Tomcat (com nome ROOT.war para ser a app principal)
COPY target/vicario-1.0-SNAPSHOT.war /usr/local/tomcat/webapps/ROOT.war

# Expõe a porta 8080 (Tomcat padrão)
EXPOSE 8080

# O comando padrão inicia o Tomcat
