FROM ubuntu:20.04
RUN apt update
RUN apt install -y slurmd slurmdbd slurmctld sssd-ldap ldap-utils
ENV DEBIAN_FRONTEND=noninteractive
RUN pam-auth-update --enable mkhomedir
COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
RUN mkdir -p /etc/slurm-llnl
RUN mkdir -p /etc/slurm
COPY ./*.conf /etc/slurm-llnl/
COPY ./*.conf /etc/slurm/
ENTRYPOINT [ "./entrypoint.sh" ]