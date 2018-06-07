FROM hashicorp/terraform:full

ARG branch=master
ARG version

ENV name="terransibula"

LABEL application=${name} \
      description="Terraform + Ansible provisioner + OpenNebula provider" \
      maintainer="kimle@cesnet.cz"

SHELL ["/bin/bash", "-c"]

# Install dependencies
RUN apk --update add bzr make sudo python py-pip openssl ca-certificates && \
    apk --update add --virtual build-dependencies python-dev libffi-dev openssl-dev build-base && \
    pip install --upgrade pip cffi

# Install Ansible
RUN pip install ansible && \
    pip install --upgrade pywinrm && \
    apk --update add sshpass openssh-client rsync py-netaddr

# Install OpenNebula provider
RUN go get -v github.com/runtastic/terraform-provider-opennebula && \
    go install -v github.com/runtastic/terraform-provider-opennebula

# Install Ansible provisioner
RUN mkdir -p $GOPATH/src/github.com/radekg && \
    cd $GOPATH/src/github.com/radekg && \
    git clone https://github.com/radekg/terraform-provisioner-ansible.git && \
    cd terraform-provisioner-ansible && \
    make install && \
    make build-linux

# Cleaning
RUN apk del build-dependencies && \
    rm -rf /var/cache/apk/*

WORKDIR /app

ENTRYPOINT ["terraform"]
