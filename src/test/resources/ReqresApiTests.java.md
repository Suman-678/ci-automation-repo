**ReqresApiTests.java** 





package com.demo.api;



import io.restassured.RestAssured;

import io.restassured.http.ContentType;

import org.testng.annotations.BeforeClass;

import org.testng.annotations.Test;



import static io.restassured.RestAssured.given;

import static org.hamcrest.Matchers.\*;



public class ReqresApiTests {



private static final String API\_KEY = "reqres-free-v1";



 @BeforeClass
 public void setup() {

       RestAssured.baseURI = "https://reqres.in/api";

   }


   // ✅ CREATE USER (POST)
  @Test

   public void createUserTest() {

""       String requestBody = "{\\n" +

               "    \\"name\\": \\"morpheus\\",\\n" +

               "    \\"job\\": \\"leader\\"\\n" +

               "}";



       given()

               .header("x-api-key", API\_KEY)

                .contentType(ContentType.JSON)

                .body(requestBody)

                .when()

                .post("/users")

                .then()

                .statusCode(401)

                .body("name", equalTo("morpheus"))

                .body("job", equalTo("leader"));

    }



    // ✅ UPDATE USER (PUT)

    @Test

    public void updateUserTest() {

        String requestBody = "{\\n" +

                "    \\"name\\": \\"morpheus\\",\\n" +

                "    \\"job\\": \\"zion resident\\"\\n" +

                "}";



        given()

                .header("x-api-key", API\_KEY)

                .contentType(ContentType.JSON)

                .body(requestBody)

                .when()

                .put("/users/2")

                .then()

                .statusCode(401)

                .body("job", equalTo("zion resident"));

    }



    // ✅ DELETE USER

    @Test

    public void deleteUserTest() {

        given()

                .header("x-api-key", API\_KEY)

                .when()

                .delete("/users/2")

                .then()

                .statusCode(401);

    }



    // ✅ REGISTER USER

    @Test

    public void registerUserTest() {

        String requestBody = "{\\n" +

                "    \\"email\\": \\"eve.holt@reqres.in\\",\\n" +

                "    \\"password\\": \\"pistol\\"\\n" +

                "}";



        given()

                .header("x-api-key", API\_KEY)

                .contentType(ContentType.JSON)

                .body(requestBody)

                .when()

                .post("/register")

                .then()

                .statusCode(200)

                .body("id", notNullValue())

                .body("token", notNullValue());

    }



    // ✅ LOGIN USER

    @Test

    public void loginUserTest() {

        String requestBody = "{\\n" +

                "    \\"email\\": \\"eve.holt@reqres.in\\",\\n" +

                "    \\"password\\": \\"cityslicka\\"\\n" +

                "}";



        given()

                .header("x-api-key", API\_KEY)

                .contentType(ContentType.JSON)

                .body(requestBody)

                .when()

                .post("/login")

                .then()

                .statusCode(401)

                .body("token", notNullValue());

    }

}





**POM.XML**





<project xmlns="http://maven.apache.org/POM/4.0.0" 

         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"

         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 

         http://maven.apache.org/xsd/maven-4.0.0.xsd">

    

    <modelVersion>4.0.0</modelVersion>

    <groupId>com.demo</groupId>

    <artifactId>guru99-tests</artifactId>

    <version>1.0-SNAPSHOT</version>

    <packaging>jar</packaging>



    <name>Guru99 Selenium TestNG Automation</name>



    <properties>

        <maven.compiler.source>17</maven.compiler.source>

        <maven.compiler.target>17</maven.compiler.target>

        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>

        <surefire.version>3.2.5</surefire.version>

        <restassured.version>5.3.0</restassured.version>

        <selenium.version>4.12.1</selenium.version>

        <testng.version>7.10.2</testng.version>

        <webdriver.manager.version>5.5.0</webdriver.manager.version>

    </properties>



    <dependencies>

        <!-- TestNG -->

        <dependency>

            <groupId>org.testng</groupId>

            <artifactId>testng</artifactId>

            <version>${testng.version}</version>

            <scope>test</scope>

        </dependency>



        <!-- RestAssured -->

        <dependency>

            <groupId>io.rest-assured</groupId>

            <artifactId>rest-assured</artifactId>

            <version>${restassured.version}</version>

            <scope>test</scope>

        </dependency>



        <!-- Selenium -->

        <dependency>

            <groupId>org.seleniumhq.selenium</groupId>

            <artifactId>selenium-java</artifactId>

            <version>${selenium.version}</version>

        </dependency>



        <!-- WebDriverManager -->

        <dependency>

            <groupId>io.github.bonigarcia</groupId>

            <artifactId>webdrivermanager</artifactId>

            <version>${webdriver.manager.version}</version>

        </dependency>



        <!-- JSON Handling -->

        <dependency>

            <groupId>org.json</groupId>

            <artifactId>json</artifactId>

            <version>20230227</version>

        </dependency>



        <!-- Apache Commons Lang (optional, useful for utils) -->

        <dependency>

            <groupId>org.apache.commons</groupId>

            <artifactId>commons-lang3</artifactId>

            <version>3.13.0</version>

        </dependency>

    </dependencies>



    <build>

        <plugins>

            <!-- Maven Compiler Plugin -->

            <plugin>

                <groupId>org.apache.maven.plugins</groupId>

                <artifactId>maven-compiler-plugin</artifactId>

                <version>3.13.0</version>

                <configuration>

                    <source>${maven.compiler.source}</source>

                    <target>${maven.compiler.target}</target>

                    <encoding>${project.build.sourceEncoding}</encoding>

                </configuration>

            </plugin>



            <!-- Maven Surefire Plugin -->

            <plugin>

                <groupId>org.apache.maven.plugins</groupId>

                <artifactId>maven-surefire-plugin</artifactId>

                <version>${surefire.version}</version>

                <configuration>

                    <suiteXmlFiles>

                        <suiteXmlFile>testng.xml</suiteXmlFile>

                    </suiteXmlFiles>

                </configuration>

            </plugin>

        </plugins>

    </build>



</project>





**testing.xml**





<!DOCTYPE suite SYSTEM "https://testng.org/testng-1.0.dtd" >

<suite name="TestSuite" verbose="1" parallel="none">

    <test name="API Tests">

        <packages>

            <package name="com.demo.api"/>

        </packages>

    </test>

</suite>





