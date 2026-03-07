rm -rf ~/.cache/fontconfig && \
sudo rm -rf /var/cache/fontconfig && \
fc-cache -r -v && \
sudo fc-cache -r -v && \
echo "Font cache cleared and rebuilt. It's best to restart your session for changes to take effect."