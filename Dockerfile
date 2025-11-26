FROM alpine:3.20

ENV DISPLAY=:0
ENV HOME=/home/user

# Install minimal packages
RUN apk add --no-cache \
    xfce4-terminal \
    xfce4-session \
    supervisor \
    tightvncserver \
    novnc \
    websockify \
    sudo \
    bash \
    curl \
    nano

# Create user
RUN adduser -D user && echo "user:user" | chpasswd && adduser user wheel

# Setup VNC
RUN mkdir -p /home/user/.vnc
COPY startup.sh /home/user/.vnc/startup.sh
RUN chmod +x /home/user/.vnc/startup.sh && chown -R user:user /home/user/.vnc

# Setup noVNC
RUN mkdir -p /opt/novnc
RUN cp -r /usr/share/novnc/* /opt/novnc || true

# Copy supervisor config
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Copy run script
COPY run.sh /run.sh
RUN chmod +x /run.sh

EXPOSE 8080
CMD ["/run.sh"]
