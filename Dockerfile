FROM nginx:alpine

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY . /usr/share/nginx/html/

RUN rm -f /usr/share/nginx/html/Dockerfile \
          /usr/share/nginx/html/.dockerignore \
          /usr/share/nginx/html/.gcloudignore \
          /usr/share/nginx/html/cloudbuild.yaml \
          /usr/share/nginx/html/nginx.conf \
          /usr/share/nginx/html/republica_site.sh \
          /usr/share/nginx/html/.DS_Store

EXPOSE 8080
CMD ["nginx", "-g", "daemon off;"]
