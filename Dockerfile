FROM docker.io/sridca/neuron:1.9.17.0 AS build
COPY . /notes/
# The $PATH is not working for some reason.
# Haven't investigated it, but just using the absolute paths instead.
RUN /bin/neuron rib \
    && /bin/mv /notes/.neuron/output /html

FROM nginx:1.17.9-alpine

COPY --from=build /html /usr/share/nginx/html
COPY ./deploy/nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 8080
CMD ["nginx", "-g", "daemon off;"]
