FROM ubuntu:20.04
RUN apt update
RUN apt install -y slurmd slurmdbd slurmctld sssd-ldap ldap-utils
ENV DEBIAN_FRONTEND=noninteractive
RUN pam-auth-update --enable mkhomedir
COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
RUN mkdir -p /etc/slurm-llnl
RUN mkdir -p /etc/slurm
COPY ./sssd.conf /etc/sssd/sssd.conf
RUN chmod 600 /etc/sssd/sssd.conf
COPY ./slurm.conf /etc/slurm-llnl/
COPY ./slurmdbd.conf /etc/slurm-llnl/
COPY ./cgroup.conf /etc/slurm-llnl/
COPY ./slurm.conf /etc/slurm/
COPY ./slurmdbd.conf /etc/slurm/
COPY ./cgroup.conf /etc/slurm/
ENTRYPOINT [ "./entrypoint.sh" ]