# ---------- 1) Build stage ----------
FROM node:20-alpine AS build

WORKDIR /app

# Install deps first (better caching)
COPY package*.json ./
RUN npm ci

# Copy the rest and build
COPY . .
RUN npm run build


# ---------- 2) Run stage (serve static files) ----------
FROM nginx:alpine

# Copy built files from the build stage
COPY --from=build /app/dist /usr/share/nginx/html

# Optional: if you use SPA routing (React Router), add a custom nginx config (see below)
# COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
