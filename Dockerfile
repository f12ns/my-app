FROM node:alpine as builder

ENV PROJECT_ENV production
RUN npm install -g http-server

WORKDIR /code

ADD package.json /code
ADD .npmrc /code
RUN npm install --production

ADD . /code
RUN npm run build
# npm run uploadCdn 是把静态资源上传至 cdn 上的脚本文件
# RUN npm run build && npm run uploadCdn

EXPOSE 80
# CMD http-server ./build -p 80
FROM nginx:alpine
COPY --from=builder /code/build/* /usr/share/nginx/html/

ENTRYPOINT [ "nginx" ]
CMD ["-g","daemon off;"]
