# ============================================
# Stage 1: BUILD (Maven + JDK 21)
# ============================================
FROM eclipse-temurin:21-jdk-alpine AS builder
WORKDIR /app

# Copiar Maven Wrapper y pom.xml primero (cache de dependencias)
COPY .mvn/ .mvn/
COPY mvnw pom.xml ./
RUN chmod +x mvnw && ./mvnw dependency:go-offline -q

# Compilar la aplicacion
COPY src ./src
RUN ./mvnw package -DskipTests --no-transfer-progress

# ============================================
# Stage 2: RUNTIME (JRE minimo, sin JDK)
# ============================================
FROM eclipse-temurin:21-jre-alpine AS runtime

# Usuario no-root (security best practice)
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser
WORKDIR /app

# Copiar solo el JAR compilado
COPY --from=builder /app/target/*.jar app.jar

# Health check para Docker y Kubernetes
HEALTHCHECK --interval=30s --timeout=3s --retries=3 \
  CMD wget -qO- http://localhost:8080/actuator/health || exit 1

EXPOSE 8080

ENTRYPOINT ["java", "-XX:+UseContainerSupport", "-jar", "app.jar"]
