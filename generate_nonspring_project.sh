#!/usr/bin/env bash
set -euo pipefail
SECONDS=0
# Fallback defaults if positional parameters are not supplied
GROUP_ID="${1:-com.utility}"
ARTIFACT_ID="${2:-quick-util}"
PACKAGE_PATH=$(echo "$GROUP_ID" | tr '.' '/')

echo "--> Generating project structure via Maven archetype..."
mvn archetype:generate \
    -DgroupId="$GROUP_ID" \
    -DartifactId="$ARTIFACT_ID" \
    -DarchetypeArtifactId=maven-archetype-quickstart \
    -DarchetypeVersion=1.5 \
    -DinteractiveMode=false

cd "$ARTIFACT_ID"

echo "--> Overwriting pom.xml with Picocli, Lombok, Logback, and GraalVM Native Profile..."
cat << EOF > pom.xml
<project xmlns="http://maven.apache.org/POM/4.0.0" 
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <groupId>${GROUP_ID}</groupId>
    <artifactId>${ARTIFACT_ID}</artifactId>
    <version>1.0-SNAPSHOT</version>

    <properties>
        <maven.compiler.release>23</maven.compiler.release>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
        <lombok.version>1.18.36</lombok.version>
        <logback.version>1.5.16</logback.version>
        <picocli.version>4.7.6</picocli.version>
        <junit.version>5.11.4</junit.version>
        <hibernate-core.version>6.6.5.Final</hibernate-core.version>
        <HikariCP.version>6.2.0</HikariCP.version>
        <h2.version>2.3.232</h2.version>
        <fasterxml>2.18.2</fasterxml>
        <jakarta.xml.bind-api>4.0.2</jakarta.xml.bind-api>
        <jaxb-runtime>4.0.5</jaxb-runtime>
        <!-- Existing properties -->
        <mockito.version>5.14.2</mockito.version>
        <assertj.version>3.26.3</assertj.version>
    </properties>

    <dependencies>
        <!-- Lombok -->
        <dependency>
            <groupId>org.projectlombok</groupId>
            <artifactId>lombok</artifactId>
            <version>\${lombok.version}</version>
            <scope>provided</scope>
        </dependency>

        <!-- Picocli (CLI Framework) -->
        <dependency>
            <groupId>info.picocli</groupId>
            <artifactId>picocli</artifactId>
            <version>\${picocli.version}</version>
        </dependency>

        <!-- Logging: Logback Classic -->
        <dependency>
            <groupId>ch.qos.logback</groupId>
            <artifactId>logback-classic</artifactId>
            <version>\${logback.version}</version>
        </dependency>

        <!-- JUnit 5 -->
        <dependency>
            <groupId>org.junit.jupiter</groupId>
            <artifactId>junit-jupiter-api</artifactId>
            <version>\${junit.version}</version>
            <scope>test</scope>
        </dependency>
            <dependency>
            <groupId>org.junit.jupiter</groupId>
            <artifactId>junit-jupiter-engine</artifactId>
            <version>\${junit.version}</version>
            <scope>test</scope>
        </dependency>
        
        
        <!-- Jakarta Persistence API + Hibernate implementation -->
        <dependency>
            <groupId>org.hibernate.orm</groupId>
            <artifactId>hibernate-core</artifactId>
            <version>\${hibernate-core.version}</version>
        </dependency>
        
        <!-- High-performance Connection Pooling -->
        <dependency>
            <groupId>com.zaxxer</groupId>
            <artifactId>HikariCP</artifactId>
            <version>\${HikariCP.version}</version>
        </dependency>
        
        <!-- H2 Database (or your database driver) -->
        <dependency>
            <groupId>com.h2database</groupId>
            <artifactId>h2</artifactId>
            <version>\${h2.version}</version>
        </dependency>
        
        
        <!-- JSON Processing via Jackson -->
        <dependency>
            <groupId>com.fasterxml.jackson.core</groupId>
            <artifactId>jackson-databind</artifactId>
            <version>\${fasterxml}</version>
        </dependency>
        
        <!-- Modern Java 21+ Immutable Record / JavaTime Module Support -->
        <dependency>
            <groupId>com.fasterxml.jackson.datatype</groupId>
            <artifactId>jackson-datatype-jsr310</artifactId>
            <version>\${fasterxml}</version>
        </dependency>
        
        <!-- Standard Jakarta JAXB for XML (Independent of JDK built-ins) -->
        <dependency>
            <groupId>jakarta.xml.bind</groupId>
            <artifactId>jakarta.xml.bind-api</artifactId>
            <version>\${jakarta.xml.bind-api}</version>
        </dependency>
        <dependency>
            <groupId>org.glassfish.jaxb</groupId>
            <artifactId>jaxb-runtime</artifactId>
            <version>\${jaxb-runtime}</version>
        </dependency>
        <!-- Explicit Direct APIs -->
        <dependency>
            <groupId>jakarta.persistence</groupId>
            <artifactId>jakarta.persistence-api</artifactId>
            <version>3.1.0</version>
        </dependency>
        <dependency>
            <groupId>org.slf4j</groupId>
            <artifactId>slf4j-api</artifactId>
            <version>2.0.16</version>
        </dependency>
        
        <!-- AssertJ (Fluent, type-safe assertions for Java) -->
        <dependency>
            <groupId>org.assertj</groupId>
            <artifactId>assertj-core</artifactId>
            <version>\${assertj.version}</version>
            <scope>test</scope>
        </dependency>

        <!-- Mockito Core & JUnit Jupiter Integration -->
        <dependency>
            <groupId>org.mockito</groupId>
            <artifactId>mockito-core</artifactId>
            <version>\${mockito.version}</version>
            <scope>test</scope>
        </dependency>
        <dependency>
            <groupId>org.mockito</groupId>
            <artifactId>mockito-junit-jupiter</artifactId>
            <version>\${mockito.version}</version>
            <scope>test</scope>
        </dependency>
    </dependencies>
    
    

    <build>    
        <plugins>
            <!-- Code Formatting Quality Gate -->
            <plugin>
                <groupId>com.diffplug.spotless</groupId>
                <artifactId>spotless-maven-plugin</artifactId>
                <version>2.43.0</version>
                <configuration>
                    <java>
                        <cleanthat />
                        <googleJavaFormat>
                            <version>1.22.0</version>
                            <style>AOSP</style>
                        </googleJavaFormat>
                        <removeUnusedImports />
                    </java>
                </configuration>
                <executions>
                    <execution>
                        <goals>
                            <goal>check</goal>
                        </goals>
                        <phase>compile</phase>
                    </execution>
                </executions>
            </plugin>

            <!-- Dependency Bloat Analysis -->
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-dependency-plugin</artifactId>
                <version>3.7.1</version>
                <executions>
                    <execution>
                        <id>analyze-dependencies</id>
                        <goals>
                            <goal>analyze-only</goal>
                        </goals>
                        <phase>verify</phase>
                        <configuration>
                            <failOnWarning>true</failOnWarning>
                            <ignoreNonCompile>true</ignoreNonCompile>
                            <!-- Tell analyzer to ignore runtime implementations used via reflection/SPI -->
                            <ignoredUnusedDeclaredDependencies>
                                <ignoredUnusedDeclaredDependency>ch.qos.logback:logback-classic</ignoredUnusedDeclaredDependency>
                                <ignoredUnusedDeclaredDependency>org.hibernate.orm:hibernate-core</ignoredUnusedDeclaredDependency>
                                <ignoredUnusedDeclaredDependency>com.zaxxer:HikariCP</ignoredUnusedDeclaredDependency>
                                <ignoredUnusedDeclaredDependency>com.h2database:h2</ignoredUnusedDeclaredDependency>
                                <ignoredUnusedDeclaredDependency>org.glassfish.jaxb:jaxb-runtime</ignoredUnusedDeclaredDependency>
                            </ignoredUnusedDeclaredDependencies>
                        </configuration>
                    </execution>
                </executions>
            </plugin>        
            <!-- Surefire Plugin -->
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-surefire-plugin</artifactId>
                <version>3.3.1</version>
                <configuration>
                    <argLine>--enable-preview</argLine>
                </configuration>
            </plugin>
        
            <!-- Compiler Plugin for Java 23, Lombok, and Picocli Annotation Processing -->
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-compiler-plugin</artifactId>
                <version>3.13.0</version>
                <configuration>
                    <annotationProcessorPaths>
                        <path>
                            <groupId>org.projectlombok</groupId>
                            <artifactId>lombok</artifactId>
                            <version>\${lombok.version}</version>
                        </path>
                        <path>
                            <groupId>info.picocli</groupId>
                            <artifactId>picocli-codegen</artifactId>
                            <version>\${picocli.version}</version>
                        </path>
                    </annotationProcessorPaths>
                    <compilerArgs>
                        <arg>-proc:full</arg>
                        <arg>--enable-preview</arg>
                    </compilerArgs>
                </configuration>
            </plugin>

            <!-- Executable Fat JAR Generator -->
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-shade-plugin</artifactId>
                <version>3.6.0</version>
                <executions>
                    <execution>
                        <phase>package</phase>
                        <goals>
                            <goal>shade</goal>
                        </goals>
                        <configuration>
                            <!-- Suppress overlapping resource warnings -->
                            <filters>
                                <filter>
                                    <artifact>*:*</artifact>
                                    <excludes>
                                        <!-- Strip cryptographic signatures from dependencies -->
                                        <exclude>META-INF/*.SF</exclude>
                                        <exclude>META-INF/*.DSA</exclude>
                                        <exclude>META-INF/*.RSA</exclude>
                                        <exclude>META-INF/MANIFEST.MF</exclude>
                                        <!-- Exclude module descriptors to prevent encapsulation warnings in shaded JARs -->
                                        <exclude>module-info.class</exclude>
                                        <exclude>META-INF/versions/*/module-info.class</exclude>
                                        <!-- Strip duplicate metadata files -->
                                        <exclude>META-INF/DEPENDENCIES</exclude>
                                        <exclude>META-INF/LICENSE*</exclude>
                                        <exclude>META-INF/NOTICE*</exclude>
                                    </excludes>
                                </filter>
                            </filters>
                            <transformers>
                                <transformer implementation="org.apache.maven.plugins.shade.resource.ManifestResourceTransformer">
                                    <mainClass>${GROUP_ID}.App</mainClass>
                                </transformer>
                            </transformers>
                        </configuration>
                    </execution>
                </executions>
            </plugin>
        </plugins>
    </build>

    <profiles>
        <!-- Native Image compilation profile via GraalVM -->
        <profile>
            <id>native</id>
            <build>
                <plugins>
                    <plugin>
                        <groupId>org.graalvm.buildtools</groupId>
                        <artifactId>native-maven-plugin</artifactId>
                        <version>0.10.4</version>
                        <executions>
                            <execution>
                                <goals>
                                    <goal>compile-no-fork</goal>
                                </goals>
                                <phase>package</phase>
                            </execution>
                        </executions>
                    </plugin>
                </plugins>
            </build>
        </profile>
    </profiles>
</project>
EOF

echo "--> Setting up directory structure..."
mkdir -p src/main/resources src/test/resources src/main/resources/META-INF src/test/resources/META-INF
mkdir -p "src/main/java/${PACKAGE_PATH}" "src/test/java/${PACKAGE_PATH}" "src/main/java/${PACKAGE_PATH}"/utils  "src/test/java/${PACKAGE_PATH}"/utils

echo "--> Writing application resources..."
cat << 'EOF' > src/main/resources/application.properties
app.name=Lightweight Utility
app.version=1.0.0
EOF

cat << 'EOF' > src/main/resources/META-INF/persistence.xml
<persistence xmlns="https://jakarta.ee/xml/ns/persistence"
             xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
             xsi:schemaLocation="https://jakarta.ee/xml/ns/persistence https://jakarta.ee/xml/ns/persistence/persistence_3_0.xsd"
             version="3.0">

    <persistence-unit name="utility-pu">
        <provider>org.hibernate.jpa.HibernatePersistenceProvider</provider>
        
        
        
        <properties>
            <!-- JDBC Connection Settings -->
            <property name="jakarta.persistence.jdbc.driver" value="org.h2.Driver"/>
            <property name="jakarta.persistence.jdbc.url" value="jdbc:h2:mem:util_db;DB_CLOSE_DELAY=-1"/>
            <property name="jakarta.persistence.jdbc.user" value="sa"/>
            <property name="jakarta.persistence.jdbc.password" value=""/>

            <!-- HikariCP Integration -->
            <property name="hibernate.hikari.minimumIdle" value="2"/>
            <property name="hibernate.hikari.maximumPoolSize" value="10"/>

            <!-- Hibernate Properties -->
            <property name="hibernate.hbm2ddl.auto" value="update"/>
            <property name="hibernate.show_sql" value="true"/>
            <property name="hibernate.format_sql" value="true"/>
        </properties>
    </persistence-unit>
</persistence>

EOF


cat << 'EOF' > src/test/resources/META-INF/persistence.xml
<persistence xmlns="https://jakarta.ee/xml/ns/persistence"
             xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
             xsi:schemaLocation="https://jakarta.ee/xml/ns/persistence https://jakarta.ee/xml/ns/persistence/persistence_3_0.xsd"
             version="3.0">

    <persistence-unit name="utility-pu">
        <provider>org.hibernate.jpa.HibernatePersistenceProvider</provider>
        
        <!-- Register entity explicitly -->
        <class>${GROUP_ID}.utils.MigrationLog</class>
        
        <properties>
            <!-- JDBC Connection Settings -->
            <property name="jakarta.persistence.jdbc.driver" value="org.h2.Driver"/>
            <property name="jakarta.persistence.jdbc.url" value="jdbc:h2:mem:util_db;DB_CLOSE_DELAY=-1"/>
            <property name="jakarta.persistence.jdbc.user" value="sa"/>
            <property name="jakarta.persistence.jdbc.password" value=""/>

            <!-- HikariCP Integration -->
            <property name="hibernate.hikari.minimumIdle" value="2"/>
            <property name="hibernate.hikari.maximumPoolSize" value="10"/>

            <!-- Hibernate Properties -->
            <property name="hibernate.hbm2ddl.auto" value="update"/>
            <property name="hibernate.show_sql" value="true"/>
            <property name="hibernate.format_sql" value="true"/>
        </properties>
    </persistence-unit>
</persistence>

EOF



cat << 'EOF' > src/test/resources/application-test.properties
app.name=Lightweight Utility (Test Environment)
app.version=1.0.0-TEST
EOF

# Explicit Logback configuration file
cat << 'EOF' > src/main/resources/logback.xml
<configuration>
    <appender name="STDOUT" class="ch.qos.logback.core.ConsoleAppender">
        <encoder>
            <pattern>%d{dd-MMM-YYYY HH:mm:ss.SSS} [%thread] %highlight(%-5level) %cyan(%logger{36}) - %msg%n</pattern>
        </encoder>
    </appender>
    <root level="INFO">
        <appender-ref ref="STDOUT" />
    </root>
</configuration>
EOF


# Explicit Logback configuration file
cat << 'EOF' > src/test/resources/logback-test.xml
<configuration>
    <appender name="STDOUT" class="ch.qos.logback.core.ConsoleAppender">
        <encoder>
            <pattern>%d{dd-MMM-YYYY HH:mm:ss.SSS} [%thread] %highlight(%-5level) %cyan(%logger{36}) - %msg%n</pattern>
        </encoder>
    </appender>
    <root level="INFO">
        <appender-ref ref="STDOUT" />
    </root>
</configuration>
EOF

echo "--> Generating Picocli + Virtual Thread baseline App.java..."
cat << EOF > "src/main/java/${PACKAGE_PATH}/App.java"
package ${GROUP_ID};

import java.util.concurrent.Callable;
import java.util.concurrent.Executors;
import lombok.extern.slf4j.Slf4j;
import picocli.CommandLine;
import picocli.CommandLine.Command;
import picocli.CommandLine.Option;

@Slf4j
@Command(
        name = "quick-util",
        mixinStandardHelpOptions = true,
        version = "1.0.0",
        description = "Lightweight Java Utility with Picocli and Virtual Threads",         
        subcommands = {
            ${GROUP_ID}.utils.GenerateEntityCommand.class
        })
public class App implements Callable<Integer> {

    @Option(
            names = {"-n", "--name"},
            description = "Target name to greet",
            defaultValue = "Developer")
    private String name;

    @Override
    public Integer call() throws Exception {
        log.info("Executing main utility logic for name: {}", name);

        // Execute concurrent work using Java 21+ Virtual Threads
        try (var executor = Executors.newVirtualThreadPerTaskExecutor()) {
            executor.submit(
                            () -> {
                                log.info(
                                        "Task running asynchronously in virtual thread: {}",
                                        Thread.currentThread());
                            })
                    .get();
        }

        return 0;
    }

    public static void main(String[] args) {
        int exitCode = new CommandLine(new App()).execute(args);
        System.exit(exitCode);
    }
} 
EOF

echo "--> Generating AppTest.java..."
cat << EOF > "src/test/java/${PACKAGE_PATH}/AppTest.java"
package ${GROUP_ID};

import static org.junit.jupiter.api.Assertions.assertEquals;

import lombok.extern.slf4j.Slf4j;
import org.junit.jupiter.api.Test;
import picocli.CommandLine;

@Slf4j
public class AppTest {

    @Test
    public void testCliExecution() {
        App app = new App();
        CommandLine cmd = new CommandLine(app);
        int exitCode = cmd.execute("-n", "TestUser");

        assertEquals(0, exitCode, "Execution should complete with status code 0");
        log.info("CLI test executed successfully.");
    }
}
EOF


echo "--> Generating DbManager.java ..."
cat << EOF > "src/main/java/${PACKAGE_PATH}/utils/DbManager.java"
package ${GROUP_ID}.utils;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import java.util.function.Consumer;
import java.util.function.Function;

public class DbManager implements AutoCloseable {

    private final EntityManagerFactory emf;

    public DbManager(String persistenceUnitName) {
        this.emf = Persistence.createEntityManagerFactory(persistenceUnitName);
    }

    // Functional wrapper for transactional writes
    public void executeInTransaction(Consumer<EntityManager> action) {
        try (EntityManager em = emf.createEntityManager()) {
            var tx = em.getTransaction();
            try {
                tx.begin();
                action.accept(em);
                tx.commit();
            } catch (Exception e) {
                if (tx.isActive()) tx.rollback();
                throw new RuntimeException("Transaction failed", e);
            }
        }
    }

    // Functional wrapper for reads returning data
    public <T> T executeQuery(Function<EntityManager, T> query) {
        try (EntityManager em = emf.createEntityManager()) {
            return query.apply(em);
        }
    }

    @Override
    public void close() {
        if (emf != null && emf.isOpen()) {
            emf.close();
        }
    }
}
EOF



echo "--> Generating JsonXmlUtils.java ..."
cat << EOF > "src/main/java/${PACKAGE_PATH}/utils/JsonXmlUtils.java"
package ${GROUP_ID}.utils;

import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import jakarta.xml.bind.JAXBContext;
import jakarta.xml.bind.Marshaller;
import java.io.StringReader;
import java.io.StringWriter;

public final class JsonXmlUtils {

    private static final ObjectMapper JSON_MAPPER =
            new ObjectMapper()
                    .registerModule(new JavaTimeModule())
                    .disable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS)
                    .configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);

    private JsonXmlUtils() {}

    // --- JSON Operations ---
    public static String toJson(Object obj) {
        try {
            return JSON_MAPPER.writeValueAsString(obj);
        } catch (Exception e) {
            throw new IllegalArgumentException("JSON serialization error", e);
        }
    }

    public static <T> T fromJson(String json, Class<T> clazz) {
        try {
            return JSON_MAPPER.readValue(json, clazz);
        } catch (Exception e) {
            throw new IllegalArgumentException("JSON deserialization error", e);
        }
    }

    // --- XML Operations (Standard JAXB) ---
    public static String toXml(Object obj) {
        try {
            JAXBContext context = JAXBContext.newInstance(obj.getClass());
            Marshaller marshaller = context.createMarshaller();
            marshaller.setProperty(Marshaller.JAXB_FORMATTED_OUTPUT, Boolean.TRUE);

            StringWriter writer = new StringWriter();
            marshaller.marshal(obj, writer);
            return writer.toString();
        } catch (Exception e) {
            throw new IllegalArgumentException("XML serialization error", e);
        }
    }

    @SuppressWarnings("unchecked")
    public static <T> T fromXml(String xml, Class<T> clazz) {
        try {
            JAXBContext context = JAXBContext.newInstance(clazz);
            return (T) context.createUnmarshaller().unmarshal(new StringReader(xml));
        } catch (Exception e) {
            throw new IllegalArgumentException("XML deserialization error", e);
        }
    }
}
EOF


echo "--> Generating FieldSpec.java ..."
cat << EOF > "src/main/java/${PACKAGE_PATH}/utils/FieldSpec.java"
package ${GROUP_ID}.utils;

public record FieldSpec(String name, String type) {

    public String toCamelCaseName() {
        return name.substring(0, 1).toLowerCase() + name.substring(1);
    }

    public String toSnakeCaseName() {
        return name.replaceAll("([a-z])([A-Z])", "\$1_\$2").toUpperCase();
    }
    
    public String toJavaType() {
        return switch (type.toLowerCase()) {
            case "date" -> "java.util.Date";
            case "string" -> "String";
            case "long" -> "Long";
            case "double" -> "Double";
            case "integer", "int" -> "Integer";
            case "boolean" -> "Boolean";
            default -> type;
        };
    }

    public String toSqlType() {
        return switch (type.toLowerCase()) {
            case "long" -> "NUMBER(32)";
            case "string" -> "VARCHAR2(1024)";
            case "date" -> "DATE";
            case "double" -> "NUMBER(18,2)";
            case "integer", "int" -> "NUMBER(10)";
            case "boolean" -> "NUMBER(1)";
            default -> "VARCHAR2(255)";
        };
    }

}
EOF


echo "--> Generating EntityGenerator.java ..."
cat << EOF > "src/main/java/${PACKAGE_PATH}/utils/EntityGenerator.java"
package ${GROUP_ID}.utils;

import com.utility.utils.FieldSpec;
import java.util.*;
import java.util.stream.*;

public class EntityGenerator {

    public record EntitySpec(String className, List<FieldSpec> fields) {}

    public static EntitySpec parseSchemaText(String text) {
        String[] lines = text.strip().split("\\r?\\n");
        if (lines.length == 0 || lines[0].isBlank()) {
            throw new IllegalArgumentException("Entity input cannot be empty.");
        }

        String className = lines[0].trim();
        List<FieldSpec> fields = new ArrayList<>();

        for (int i = 1; i < lines.length; i++) {
            String line = lines[i].trim();
            if (line.isBlank()) continue;

            String[] parts = line.split("\\s+");
            if (parts.length < 2) {
                throw new IllegalArgumentException("Invalid field specification: " + line);
            }
            fields.add(new FieldSpec(parts[0], parts[1]));
        }

        return new EntitySpec(className, fields);
    }

    public static String generateJavaBean(EntitySpec spec, String packageName) {
        StringBuilder sb = new StringBuilder();
        sb.append("package ").append(packageName).append(".bean;\n\n");
        
        boolean needsDate = spec.fields().stream()
                .anyMatch(f -> f.type().equalsIgnoreCase("date"));
        if (needsDate) {
            sb.append("import java.util.Date;\n");
        }
        sb.append("import lombok.*;\n\n");
        sb.append("@Getter @Setter @ToString @EqualsAndHashCode @NoArgsConstructor @AllArgsConstructor\n");
        sb.append("public class ").append(spec.className()).append(" {\n");

        for (FieldSpec field : spec.fields()) {
            sb.append("    private ").append(field.toJavaType()).append(" ")
              .append(field.toCamelCaseName()).append(";\n");
        }

        sb.append("}\n");
        return sb.toString();
    }

    public static String generateSqlScript(EntitySpec spec) {
        String tableName = spec.className().replaceAll("([a-z])([A-Z])", "\$1_\$2").toUpperCase();
        StringBuilder sb = new StringBuilder();
        sb.append("CREATE OR REPLACE TABLE ").append(tableName).append(" (\n");

        List<String> fieldDefinitions = spec.fields().stream()
                .map(f -> "    " + f.toSnakeCaseName() + " " + f.toSqlType())
                .collect(Collectors.toList());

        sb.append(String.join(",\n", fieldDefinitions));
        sb.append("\n);\n");

        return sb.toString();
    }
}
EOF


echo "--> Generating GenerateEntityCommand.java ..."
cat << EOF > "src/main/java/${PACKAGE_PATH}/utils/GenerateEntityCommand.java"
package ${GROUP_ID}.utils;

import com.utility.utils.EntityGenerator;
import com.utility.utils.EntityGenerator.EntitySpec;
import lombok.extern.slf4j.Slf4j;
import picocli.CommandLine.*;
import picocli.CommandLine.Option;

import java.nio.file.*;
import java.util.concurrent.*;

@Slf4j
@Command(
    name = "generate-entity",
    aliases = {"gen"},
    description = "Generates Java Beans and SQL schema scripts from lightweight entity definitions"
)
public class GenerateEntityCommand implements Callable<Integer> {

    @Option(names = {"-i", "--input"}, description = "Path to schema definition file")
    private Path inputFilePath;

    @Option(names = {"-s", "--spec"}, description = "Inline schema string (newline delimited)")
    private String inlineSpec;

    @Option(names = {"-p", "--package"}, defaultValue = "com.utility", description = "Base package name")
    private String packageName;

    @Option(names = {"-o", "--out-dir"}, description = "Target output directory (optional)")
    private Path outputDir;

    @Override
    public Integer call() throws Exception {
        String specContent;

        if (inputFilePath != null) {
            specContent = Files.readString(inputFilePath);
        } else if (inlineSpec != null && !inlineSpec.isBlank()) {
            specContent = inlineSpec;
        } else {
            log.error("Error: Either --input file or --spec inline string must be provided.");
            return 1;
        }

        EntitySpec entitySpec = EntityGenerator.parseSchemaText(specContent);
        String javaCode = EntityGenerator.generateJavaBean(entitySpec, packageName);
        String sqlCode = EntityGenerator.generateSqlScript(entitySpec);

        if (outputDir != null) {
            Files.createDirectories(outputDir);
            Path javaPath = outputDir.resolve(entitySpec.className() + ".java");
            Path sqlPath = outputDir.resolve(entitySpec.className().toLowerCase() + ".sql");

            Files.writeString(javaPath, javaCode);
            Files.writeString(sqlPath, sqlCode);

            log.info("Successfully generated Java Bean at: {}", javaPath.toAbsolutePath());
            log.info("Successfully generated SQL Script at: {}", sqlPath.toAbsolutePath());
        } else {
            System.out.println("=== Generated Java Bean ===");
            System.out.println(javaCode);
            System.out.println("=== Generated SQL Script ===");
            System.out.println(sqlCode);
        }

        return 0;
    }
}

EOF

echo "--> Generating MigrationLog.java..."
cat << EOF > "src/test/java/${PACKAGE_PATH}/utils/MigrationLog.java"
package ${GROUP_ID}.utils;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "migration_logs")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class MigrationLog {
    @Id private String logId;
    private String status;
    private int processedCount;
}
EOF


echo "--> Generating DbManagerTest.java..."
cat << EOF > "src/test/java/${PACKAGE_PATH}/utils/DbManagerTest.java"
package ${GROUP_ID}.utils;

import static org.junit.jupiter.api.Assertions.*;

import org.junit.jupiter.api.*;

class DbManagerTest {

    private static DbManager dbManager;

    @BeforeAll
    static void setUp() {
        // Initialize H2 persistence unit defined in persistence.xml
        dbManager = new DbManager("utility-pu");
    }

    @AfterAll
    static void tearDown() {
        if (dbManager != null) {
            dbManager.close();
        }
    }

    @BeforeEach
    void cleanUpDatabase() {
        // Clear table before each test
        dbManager.executeInTransaction(
                em -> em.createQuery("DELETE FROM MigrationLog").executeUpdate());
    }

    @Test
    @DisplayName("Should successfully persist and query an entity in transaction")
    void testExecuteInTransactionAndQuery() {
        MigrationLog logEntry = new MigrationLog("JOB-001", "SUCCESS", 1500);

        // Execute Write
        dbManager.executeInTransaction(em -> em.persist(logEntry));

        // Execute Read
        MigrationLog fetched = dbManager.executeQuery(em -> em.find(MigrationLog.class, "JOB-001"));

        assertNotNull(fetched);
        assertEquals("JOB-001", fetched.getLogId());
        assertEquals("SUCCESS", fetched.getStatus());
        assertEquals(1500, fetched.getProcessedCount());
    }

    @Test
    @DisplayName("Should rollback transaction when an exception occurs")
    void testTransactionRollbackOnException() {
        MigrationLog logEntry = new MigrationLog("JOB-ERR", "FAILED", 0);

        // Attempt write that triggers explicit RuntimeException inside block
        assertThrows(
                RuntimeException.class,
                () ->
                        dbManager.executeInTransaction(
                                em -> {
                                    em.persist(logEntry);
                                    throw new RuntimeException("Simulated processing failure");
                                }));

        // Verify entity was NOT saved due to rollback
        MigrationLog fetched = dbManager.executeQuery(em -> em.find(MigrationLog.class, "JOB-ERR"));

        assertNull(fetched, "Entity should be null as the transaction rolled back");
    }

    @Test
    @DisplayName("Should return correct count via query wrapper")
    void testExecuteQueryCount() {
        dbManager.executeInTransaction(
                em -> {
                    em.persist(new MigrationLog("JOB-A", "SUCCESS", 100));
                    em.persist(new MigrationLog("JOB-B", "SUCCESS", 200));
                });

        Long totalRecords =
                dbManager.executeQuery(
                        em ->
                                em.createQuery("SELECT COUNT(m) FROM MigrationLog m", Long.class)
                                        .getSingleResult());

        assertEquals(2L, totalRecords);
    }
}
EOF

echo "--> Format the Source Files"
mvn spotless:apply

echo "--> Verify..."
mvn clean verify

echo "--> Packaging standalone executable JAR..."
mvn clean package

echo "--> Executing standalone JAR with '--help' flag..."
java -jar "target/${ARTIFACT_ID}-1.0-SNAPSHOT.jar" --help

echo "--> Executing standalone JAR with default arguments..."
java -jar "target/${ARTIFACT_ID}-1.0-SNAPSHOT.jar" -n "Mercenary"

cd ..
echo "--> Setup complete! To build a native executable later, run: mvn clean package -Pnative"
echo "-->Time Taken $SECONDS secs."