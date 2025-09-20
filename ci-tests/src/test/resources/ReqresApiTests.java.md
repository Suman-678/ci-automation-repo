**ReqresApiTests.java** 





package com.demo.api;



import io.restassured.RestAssured;

import io.restassured.http.ContentType;

import org.testng.annotations.BeforeClass;

import org.testng.annotations.Test;



import static io.restassured.RestAssured.given;

import static org.hamcrest.Matchers.\*;



public class ReqresApiTests {



&nbsp;   private static final String API\_KEY = "reqres-free-v1";



&nbsp;   @BeforeClass

&nbsp;   public void setup() {

&nbsp;       RestAssured.baseURI = "https://reqres.in/api";

&nbsp;   }



&nbsp;   // ✅ CREATE USER (POST)

&nbsp;   @Test

&nbsp;   public void createUserTest() {

&nbsp;       String requestBody = "{\\n" +

&nbsp;               "    \\"name\\": \\"morpheus\\",\\n" +

&nbsp;               "    \\"job\\": \\"leader\\"\\n" +

&nbsp;               "}";



&nbsp;       given()

&nbsp;               .header("x-api-key", API\_KEY)

&nbsp;               .contentType(ContentType.JSON)

&nbsp;               .body(requestBody)

&nbsp;               .when()

&nbsp;               .post("/users")

&nbsp;               .then()

&nbsp;               .statusCode(201)

&nbsp;               .body("name", equalTo("morpheus"))

&nbsp;               .body("job", equalTo("leader"));

&nbsp;   }



&nbsp;   // ✅ UPDATE USER (PUT)

&nbsp;   @Test

&nbsp;   public void updateUserTest() {

&nbsp;       String requestBody = "{\\n" +

&nbsp;               "    \\"name\\": \\"morpheus\\",\\n" +

&nbsp;               "    \\"job\\": \\"zion resident\\"\\n" +

&nbsp;               "}";



&nbsp;       given()

&nbsp;               .header("x-api-key", API\_KEY)

&nbsp;               .contentType(ContentType.JSON)

&nbsp;               .body(requestBody)

&nbsp;               .when()

&nbsp;               .put("/users/2")

&nbsp;               .then()

&nbsp;               .statusCode(200)

&nbsp;               .body("job", equalTo("zion resident"));

&nbsp;   }



&nbsp;   // ✅ DELETE USER

&nbsp;   @Test

&nbsp;   public void deleteUserTest() {

&nbsp;       given()

&nbsp;               .header("x-api-key", API\_KEY)

&nbsp;               .when()

&nbsp;               .delete("/users/2")

&nbsp;               .then()

&nbsp;               .statusCode(204);

&nbsp;   }



&nbsp;   // ✅ REGISTER USER

&nbsp;   @Test

&nbsp;   public void registerUserTest() {

&nbsp;       String requestBody = "{\\n" +

&nbsp;               "    \\"email\\": \\"eve.holt@reqres.in\\",\\n" +

&nbsp;               "    \\"password\\": \\"pistol\\"\\n" +

&nbsp;               "}";



&nbsp;       given()

&nbsp;               .header("x-api-key", API\_KEY)

&nbsp;               .contentType(ContentType.JSON)

&nbsp;               .body(requestBody)

&nbsp;               .when()

&nbsp;               .post("/register")

&nbsp;               .then()

&nbsp;               .statusCode(200)

&nbsp;               .body("id", notNullValue())

&nbsp;               .body("token", notNullValue());

&nbsp;   }



&nbsp;   // ✅ LOGIN USER

&nbsp;   @Test

&nbsp;   public void loginUserTest() {

&nbsp;       String requestBody = "{\\n" +

&nbsp;               "    \\"email\\": \\"eve.holt@reqres.in\\",\\n" +

&nbsp;               "    \\"password\\": \\"cityslicka\\"\\n" +

&nbsp;               "}";



&nbsp;       given()

&nbsp;               .header("x-api-key", API\_KEY)

&nbsp;               .contentType(ContentType.JSON)

&nbsp;               .body(requestBody)

&nbsp;               .when()

&nbsp;               .post("/login")

&nbsp;               .then()

&nbsp;               .statusCode(200)

&nbsp;               .body("token", notNullValue());

&nbsp;   }

}





**POM.XML**





<project xmlns="http://maven.apache.org/POM/4.0.0" 

&nbsp;        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"

&nbsp;        xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 

&nbsp;        http://maven.apache.org/xsd/maven-4.0.0.xsd">

&nbsp;   

&nbsp;   <modelVersion>4.0.0</modelVersion>

&nbsp;   <groupId>com.demo</groupId>

&nbsp;   <artifactId>guru99-tests</artifactId>

&nbsp;   <version>1.0-SNAPSHOT</version>

&nbsp;   <packaging>jar</packaging>



&nbsp;   <name>Guru99 Selenium TestNG Automation</name>



&nbsp;   <properties>

&nbsp;       <maven.compiler.source>17</maven.compiler.source>

&nbsp;       <maven.compiler.target>17</maven.compiler.target>

&nbsp;       <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>

&nbsp;       <surefire.version>3.2.5</surefire.version>

&nbsp;       <restassured.version>5.3.0</restassured.version>

&nbsp;       <selenium.version>4.12.1</selenium.version>

&nbsp;       <testng.version>7.10.2</testng.version>

&nbsp;       <webdriver.manager.version>5.5.0</webdriver.manager.version>

&nbsp;   </properties>



&nbsp;   <dependencies>

&nbsp;       <!-- TestNG -->

&nbsp;       <dependency>

&nbsp;           <groupId>org.testng</groupId>

&nbsp;           <artifactId>testng</artifactId>

&nbsp;           <version>${testng.version}</version>

&nbsp;           <scope>test</scope>

&nbsp;       </dependency>



&nbsp;       <!-- RestAssured -->

&nbsp;       <dependency>

&nbsp;           <groupId>io.rest-assured</groupId>

&nbsp;           <artifactId>rest-assured</artifactId>

&nbsp;           <version>${restassured.version}</version>

&nbsp;           <scope>test</scope>

&nbsp;       </dependency>



&nbsp;       <!-- Selenium -->

&nbsp;       <dependency>

&nbsp;           <groupId>org.seleniumhq.selenium</groupId>

&nbsp;           <artifactId>selenium-java</artifactId>

&nbsp;           <version>${selenium.version}</version>

&nbsp;       </dependency>



&nbsp;       <!-- WebDriverManager -->

&nbsp;       <dependency>

&nbsp;           <groupId>io.github.bonigarcia</groupId>

&nbsp;           <artifactId>webdrivermanager</artifactId>

&nbsp;           <version>${webdriver.manager.version}</version>

&nbsp;       </dependency>



&nbsp;       <!-- JSON Handling -->

&nbsp;       <dependency>

&nbsp;           <groupId>org.json</groupId>

&nbsp;           <artifactId>json</artifactId>

&nbsp;           <version>20230227</version>

&nbsp;       </dependency>



&nbsp;       <!-- Apache Commons Lang (optional, useful for utils) -->

&nbsp;       <dependency>

&nbsp;           <groupId>org.apache.commons</groupId>

&nbsp;           <artifactId>commons-lang3</artifactId>

&nbsp;           <version>3.13.0</version>

&nbsp;       </dependency>

&nbsp;   </dependencies>



&nbsp;   <build>

&nbsp;       <plugins>

&nbsp;           <!-- Maven Compiler Plugin -->

&nbsp;           <plugin>

&nbsp;               <groupId>org.apache.maven.plugins</groupId>

&nbsp;               <artifactId>maven-compiler-plugin</artifactId>

&nbsp;               <version>3.13.0</version>

&nbsp;               <configuration>

&nbsp;                   <source>${maven.compiler.source}</source>

&nbsp;                   <target>${maven.compiler.target}</target>

&nbsp;                   <encoding>${project.build.sourceEncoding}</encoding>

&nbsp;               </configuration>

&nbsp;           </plugin>



&nbsp;           <!-- Maven Surefire Plugin -->

&nbsp;           <plugin>

&nbsp;               <groupId>org.apache.maven.plugins</groupId>

&nbsp;               <artifactId>maven-surefire-plugin</artifactId>

&nbsp;               <version>${surefire.version}</version>

&nbsp;               <configuration>

&nbsp;                   <suiteXmlFiles>

&nbsp;                       <suiteXmlFile>testng.xml</suiteXmlFile>

&nbsp;                   </suiteXmlFiles>

&nbsp;               </configuration>

&nbsp;           </plugin>

&nbsp;       </plugins>

&nbsp;   </build>



</project>





**testing.xml**





<!DOCTYPE suite SYSTEM "https://testng.org/testng-1.0.dtd" >

<suite name="TestSuite" verbose="1" parallel="none">

&nbsp;   <test name="API Tests">

&nbsp;       <packages>

&nbsp;           <package name="com.demo.api"/>

&nbsp;       </packages>

&nbsp;   </test>

</suite>





