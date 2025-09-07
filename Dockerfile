# --- build stage ---
FROM node:20 AS build
WORKDIR /app

# Backend deps
COPY backend/package*.json ./backend/
RUN npm ci --prefix backend

# Frontend deps
COPY frontend/package*.json ./frontend/
RUN npm ci --prefix frontend

# Copy all sources
COPY . .

# Build frontend
RUN npm run build --prefix frontend

# --- run stage ---
FROM node:20
WORKDIR /app

# Copy backend + built frontend
COPY --from=build /app/backend ./backend
COPY --from=build /app/frontend/dist ./frontend/dist

WORKDIR /app/backend
ENV NODE_ENV=production
EXPOSE 8080

CMD ["npm", "start"]
