FROM alpine
RUN apk update && apk add nginx
COPY index.html /var/lib/nginx/html/index.html
COPY default.conf /etc/nginx/http.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]