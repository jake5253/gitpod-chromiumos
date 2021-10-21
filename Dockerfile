FROM gitpod/workspace-full-vnc:latest

USER root

# Install Chromium build dependencies
RUN apt update \
  && apt install --yes --no-install-recommends \
    git \
    xz-utils \
    python3-pkg-resources \
    python3-virtualenv \
    python3-oauth2client\
    locales \
    software-properties-common \
    lvm2 \
    thin-provisioning-tools \
  && locale-gen en_US.UTF-8 \
  && rm -rf /var/lib/apt/lists/*

ENV LANG=en_US.UTF-8

USER gitpod

# Install Chromium's depot_tools.
RUN git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git /home/gitpod/depot_tools
ENV PATH $PATH:/home/gitpod/depot_tools
RUN echo "\n# Add Chromium's depot_tools to the PATH." >> /home/gitpod/.bashrc \
 && echo "export PATH=\"\$PATH:/home/gitpod/depot_tools\"" >> /home/gitpod/.bashrc

# Enable bash completion for git cl.
RUN echo "\n# The next line enables bash completion for git cl." >> /home/gitpod/.bashrc \
 && echo "if [ -f \"/home/gitpod/depot_tools/git_cl_completion.sh\" ]; then" >> /home/gitpod/.bashrc \
 && echo "  . \"/home/gitpod/depot_tools/git_cl_completion.sh\"" >> /home/gitpod/.bashrc \
 && echo "fi" >> /home/gitpod/.bashrc

# Set up git
RUN git config --global user.name "/dev/null" \
  && git config --global user.email "dev@null.com" 

# Give back control.
USER root
