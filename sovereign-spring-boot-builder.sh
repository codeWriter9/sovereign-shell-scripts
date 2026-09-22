#!/usr/bin/env bash
SECONDS=0
set -euo pipefail

# Fallback defaults if positional parameters are not supplied
GROUP_ID="${1:-com.utility}"
ARTIFACT_ID="${2:-quick-util}"
JAVA_VERSION="23"
SPRING_BOOT_VERSION="3.3.4"

echo "==> Initializing Sovereign Spring Boot Project: ${GROUP_ID}:${ARTIFACT_ID}"

# Create directory structure
PACKAGE_PATH=$(echo "${GROUP_ID}" | tr '.' '/')
PROJECT_DIR="${ARTIFACT_ID}"

mkdir -p "${PROJECT_DIR}/src/main/java/${PACKAGE_PATH}/config"
mkdir -p "${PROJECT_DIR}/src/test/java/${PACKAGE_PATH}/config"
mkdir -p "${PROJECT_DIR}/src/main/resources"
mkdir -p "${PROJECT_DIR}/src/test/resources"

cd "${PROJECT_DIR}"

# 1. pom.xml
cat << EOF > pom.xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0" 
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>${SPRING_BOOT_VERSION}</version>
        <relativePath/>
    </parent>

    <groupId>${GROUP_ID}</groupId>
    <artifactId>${ARTIFACT_ID}</artifactId>
    <version>0.0.1-SNAPSHOT</version>
    <name>${ARTIFACT_ID}</name>
    <description>Sovereign Spring Boot Core Scaffolding</description>

    <properties>
        <java.version>${JAVA_VERSION}</java.version>
        <maven.compiler.source>${JAVA_VERSION}</maven.compiler.source>
        <maven.compiler.target>${JAVA_VERSION}</maven.compiler.target>
    </properties>

    <dependencies>
        <!-- Spring Boot Starters -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-data-jpa</artifactId>
        </dependency>

        <!-- H2 Embedded Database -->
        <dependency>
            <groupId>com.h2database</groupId>
            <artifactId>h2</artifactId>
            <scope>runtime</scope>
        </dependency>

        <!-- Lombok -->
        <dependency>
            <groupId>org.projectlombok</groupId>
            <artifactId>lombok</artifactId>
            <optional>true</optional>
        </dependency>

        <!-- Testing -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-test</artifactId>
            <scope>test</scope>
        </dependency>
    </dependencies>

    <build>
        <plugins>
            <!-- Compiler plugin configured for JDK 23 annotation processing -->
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-compiler-plugin</artifactId>
                <version>3.13.0</version>
                <configuration>
                    <compilerArgs>
                        <arg>-proc:full</arg>
                    </compilerArgs>
                    <annotationProcessorPaths>
                        <path>
                            <groupId>org.projectlombok</groupId>
                            <artifactId>lombok</artifactId>
                        </path>
                    </annotationProcessorPaths>
                </configuration>
            </plugin>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
                <configuration>
                    <excludes>
                        <exclude>
                            <groupId>org.projectlombok</groupId>
                            <artifactId>lombok</artifactId>
                        </exclude>
                    </excludes>
                </configuration>
            </plugin>
        </plugins>
    </build>
</project>
EOF

# 2. Resources Configuration
cat << EOF > src/main/resources/application.properties
spring.application.name=${ARTIFACT_ID}

# H2 Database Configuration
spring.datasource.url=jdbc:h2:mem:testdb
spring.datasource.driverClassName=org.h2.Driver
spring.datasource.username=sa
spring.datasource.password=
spring.jpa.database-platform=org.hibernate.dialect.H2Dialect
spring.h2.console.enabled=true
EOF

cat << EOF > src/test/resources/application-test.properties
spring.datasource.url=jdbc:h2:mem:testdb
spring.datasource.driverClassName=org.h2.Driver
spring.datasource.username=sa
spring.datasource.password=
EOF

# 3. Main Application Class
cat << EOF > "src/main/java/${PACKAGE_PATH}/Application.java"
package ${GROUP_ID};

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class Application {
    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
    }
}
EOF

# 4. Configuration Class
cat << EOF > "src/main/java/${PACKAGE_PATH}/config/AppConfig.java"
package ${GROUP_ID}.config;

import org.springframework.context.annotation.Configuration;

@Configuration
public class AppConfig {
}
EOF

# 5. Test Class
cat << EOF > "src/test/java/${PACKAGE_PATH}/config/AppConfigTest.java"
package ${GROUP_ID}.config;

import lombok.extern.slf4j.Slf4j;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

@Slf4j
@SpringBootTest
public class AppConfigTest {

    @Autowired
    private AppConfig config;

    @Test
    @DisplayName("Check if the Context loads")
    public void contextLoads() {
        log.info("The context loads successfully!");
    }
}
EOF

echo "==> Verifying build with 'mvn clean test package'..."
mvn clean test package


echo "==> use the below to run the jar..."
echo "java -jar target/${ARTIFACT_ID}-0.0.1-SNAPSHOT.jar"

echo "==> Build successful. Returning to root directory."
cd ..

echo "==> COMPLETED in ${SECONDS} seconds."