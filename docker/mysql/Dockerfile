FROM mysql:5.7

LABEL maintainer="Marcel Gascoyne <marcel@gascoyne.de>"
LABEL description="MySQL container for Symfony 5"

# Configuration
COPY my.cnf /etc/mysql/

# Volumes
VOLUME /var/lib/mysql

# Ports
EXPOSE  3306

WORKDIR /var/lib/mysql
CMD ["mysqld"]
