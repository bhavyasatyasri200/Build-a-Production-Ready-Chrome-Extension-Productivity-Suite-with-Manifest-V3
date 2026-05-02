# Build stage
FROM node:20-alpine AS builder

# Install zip utility
RUN apk add --no-cache zip

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy source code
COPY . .

# Build the project
RUN npm run build

# Create zip file
RUN zip -r productivity_suite.zip dist/

# Export stage (fixed)
FROM alpine AS export

WORKDIR /output

# Copy zip from builder
COPY --from=builder /app/productivity_suite.zip .

# Keep container alive (so compose doesn’t fail)
CMD ["sh", "-c", "echo Build complete && ls -l /output"]
