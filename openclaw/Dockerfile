FROM node:20-alpine

RUN apk add --no-cache git curl gnupg pass jq

RUN npm install -g openclaw

COPY run.sh /run.sh
RUN chmod +x /run.sh

EXPOSE 18789

CMD ["/run.sh"]
