**Parallel execution (UI+API) :-**



**ReqresApiTests.java**





package com.demo.api;



import io.restassured.RestAssured;

import io.restassured.http.ContentType;

import org.testng.annotations.BeforeClass;

import org.testng.annotations.Test;



import static io.restassured.RestAssured.given;

import static org.hamcrest.Matchers.\*;



public class ReqresApiTests {



&nbsp;       private static final String API\_KEY = "reqres-free-v1";



&nbsp;       @BeforeClass

&nbsp;       public void setup() {

&nbsp;               RestAssured.baseURI = "https://reqres.in/api";

&nbsp;       }



&nbsp;       // ✅ CREATE USER (POST)

&nbsp;       @Test

&nbsp;       public void createUserTest() {

&nbsp;               String requestBody = "{\\n" +

&nbsp;                               "    \\"name\\": \\"morpheus\\",\\n" +

&nbsp;                               "    \\"job\\": \\"leader\\"\\n" +

&nbsp;                               "}";



&nbsp;               given()

&nbsp;                               .header("x-api-key", API\_KEY)

&nbsp;                               .contentType(ContentType.JSON)

&nbsp;                               .body(requestBody)

&nbsp;                               .when()

&nbsp;                               .post("/users")

&nbsp;                               .then()

&nbsp;                               .statusCode(201)

&nbsp;                               .body("name", equalTo("morpheus"))

&nbsp;                               .body("job", equalTo("leader"));

&nbsp;       }



&nbsp;       // ✅ UPDATE USER (PUT)

&nbsp;       @Test

&nbsp;       public void updateUserTest() {

&nbsp;               String requestBody = "{\\n" +

&nbsp;                               "    \\"name\\": \\"morpheus\\",\\n" +

&nbsp;                               "    \\"job\\": \\"zion resident\\"\\n" +

&nbsp;                               "}";



&nbsp;               given()

&nbsp;                               .header("x-api-key", API\_KEY)

&nbsp;                               .contentType(ContentType.JSON)

&nbsp;                               .body(requestBody)

&nbsp;                               .when()

&nbsp;                               .put("/users/2")

&nbsp;                               .then()

&nbsp;                               .statusCode(200)

&nbsp;                               .body("job", equalTo("zion resident"));

&nbsp;       }



&nbsp;       // ✅ DELETE USER

&nbsp;       @Test

&nbsp;       public void deleteUserTest() {

&nbsp;               given()

&nbsp;                               .header("x-api-key", API\_KEY)

&nbsp;                               .when()

&nbsp;                               .delete("/users/2")

&nbsp;                               .then()

&nbsp;                               .statusCode(204);

&nbsp;       }



&nbsp;       // ✅ REGISTER USER

&nbsp;       @Test

&nbsp;       public void registerUserTest() {

&nbsp;               String requestBody = "{\\n" +

&nbsp;                               "    \\"email\\": \\"eve.holt@reqres.in\\",\\n" +

&nbsp;                               "    \\"password\\": \\"pistol\\"\\n" +

&nbsp;                               "}";



&nbsp;               given()

&nbsp;                               .header("x-api-key", API\_KEY)

&nbsp;                               .contentType(ContentType.JSON)

&nbsp;                               .body(requestBody)

&nbsp;                               .when()

&nbsp;                               .post("/register")

&nbsp;                               .then()

&nbsp;                               .statusCode(200)

&nbsp;                               .body("id", notNullValue())

&nbsp;                               .body("token", notNullValue());

&nbsp;       }



&nbsp;       // ✅ LOGIN USER

&nbsp;       @Test

&nbsp;       public void loginUserTest() {

&nbsp;               String requestBody = "{\\n" +

&nbsp;                               "    \\"email\\": \\"eve.holt@reqres.in\\",\\n" +

&nbsp;                               "    \\"password\\": \\"cityslicka\\"\\n" +

&nbsp;                               "}";



&nbsp;               given()

&nbsp;                               .header("x-api-key", API\_KEY)

&nbsp;                               .contentType(ContentType.JSON)

&nbsp;                               .body(requestBody)

&nbsp;                               .when()

&nbsp;                               .post("/login")

&nbsp;                               .then()

&nbsp;                               .statusCode(200)

&nbsp;                               .body("token", notNullValue());

&nbsp;       }

}





**Guru99Tests.java**





package com.demo.ui;



import io.github.bonigarcia.wdm.WebDriverManager;

import org.openqa.selenium.\*;

import org.openqa.selenium.chrome.ChromeDriver;

import org.openqa.selenium.chrome.ChromeOptions;

import org.openqa.selenium.support.ui.\*;

import org.testng.Assert;

import org.testng.annotations.\*;



import java.time.Duration;



public class Guru99Tests {



&nbsp;   private static ThreadLocal<WebDriver> tlDriver = new ThreadLocal<>();

&nbsp;   private static ThreadLocal<WebDriverWait> tlWait = new ThreadLocal<>();

&nbsp;   private static ThreadLocal<JavascriptExecutor> tlJs = new ThreadLocal<>();



&nbsp;   String managerId = "mngr634899";

&nbsp;   String password = "tAhYpyp";



&nbsp;   private WebDriver getDriver() {

&nbsp;       return tlDriver.get();

&nbsp;   }



&nbsp;   private WebDriverWait getWait() {

&nbsp;       return tlWait.get();

&nbsp;   }



&nbsp;   private JavascriptExecutor getJs() {

&nbsp;       return tlJs.get();

&nbsp;   }



&nbsp;   @BeforeClass

&nbsp;   public void setup() {

&nbsp;       WebDriverManager.chromedriver().setup();

&nbsp;       ChromeOptions options = new ChromeOptions();

&nbsp;       options.addArguments("--incognito");

&nbsp;       WebDriver driver = new ChromeDriver(options);

&nbsp;       driver.manage().window().maximize();

&nbsp;       tlDriver.set(driver);



&nbsp;       tlWait.set(new WebDriverWait(driver, Duration.ofSeconds(15)));

&nbsp;       driver.manage().timeouts().implicitlyWait(Duration.ofSeconds(5));



&nbsp;       tlJs.set((JavascriptExecutor) driver);

&nbsp;   }



&nbsp;   @Test(priority = 1)

&nbsp;   public void verifyLoginPageTitle() {

&nbsp;       getDriver().get("https://demo.guru99.com/V4/");

&nbsp;       String title = getDriver().getTitle();

&nbsp;       Assert.assertTrue(title.contains("Guru99 Bank"), "Login page title mismatch");

&nbsp;   }



&nbsp;   @Test(priority = 2)

&nbsp;   public void loginTest() {

&nbsp;       getDriver().get("https://demo.guru99.com/V4/");

&nbsp;       getDriver().findElement(By.name("uid")).sendKeys(managerId);

&nbsp;       getDriver().findElement(By.name("password")).sendKeys(password);

&nbsp;       getDriver().findElement(By.name("btnLogin")).click();



&nbsp;       WebElement managerIdLabel = getWait().until(ExpectedConditions.visibilityOfElementLocated(

&nbsp;               By.xpath("//td\[contains(text(),'Manger Id')]")));

&nbsp;       Assert.assertTrue(managerIdLabel.isDisplayed(), "Manager ID not found - login may have failed");

&nbsp;   }



&nbsp;   @Test(priority = 3)

&nbsp;   public void createNewCustomerTest() {

&nbsp;       WebElement newCustomerLink = getWait()

&nbsp;               .until(ExpectedConditions.visibilityOfElementLocated(By.linkText("New Customer")));

&nbsp;       getJs().executeScript("arguments\[0].click();", newCustomerLink);



&nbsp;       getWait().until(ExpectedConditions.visibilityOfElementLocated(By.name("name"))).sendKeys("John Doe");

&nbsp;       getDriver().findElement(By.name("rad1")).click(); // Gender

&nbsp;       getDriver().findElement(By.name("dob")).sendKeys("01/01/1990");

&nbsp;       getDriver().findElement(By.name("addr")).sendKeys("123 Main Street");

&nbsp;       getDriver().findElement(By.name("city")).sendKeys("New York");

&nbsp;       getDriver().findElement(By.name("state")).sendKeys("NY");

&nbsp;       getDriver().findElement(By.name("pinno")).sendKeys("123456");

&nbsp;       getDriver().findElement(By.name("telephoneno")).sendKeys("9876543210");

&nbsp;       getDriver().findElement(By.name("emailid"))

&nbsp;               .sendKeys("john" + System.currentTimeMillis() + "@test.com");

&nbsp;       getDriver().findElement(By.name("password")).sendKeys("Password123");

&nbsp;       getDriver().findElement(By.name("sub")).click();



&nbsp;       WebElement successMsg = getWait().until(ExpectedConditions.visibilityOfElementLocated(

&nbsp;               By.xpath("//p\[contains(text(),'Customer Registered Successfully')]")));

&nbsp;       Assert.assertTrue(successMsg.isDisplayed(), "Customer creation failed");

&nbsp;   }



&nbsp;   @Test(priority = 4)

&nbsp;   public void resetNewCustomerFormTest() {

&nbsp;       WebElement newCustomerLink = getWait()

&nbsp;               .until(ExpectedConditions.visibilityOfElementLocated(By.linkText("New Customer")));

&nbsp;       getJs().executeScript("arguments\[0].click();", newCustomerLink);



&nbsp;       WebElement nameField = getWait().until(ExpectedConditions.visibilityOfElementLocated(By.name("name")));

&nbsp;       nameField.sendKeys("Test Customer");



&nbsp;       getDriver().findElement(By.name("res")).click(); // Reset button

&nbsp;       Assert.assertEquals(nameField.getAttribute("value"), "", "Reset did not clear the name field");

&nbsp;   }



&nbsp;   @Test(priority = 5)

&nbsp;   public void verifyHomePageNavigation() {

&nbsp;       WebElement newCustomerLink = getWait()

&nbsp;               .until(ExpectedConditions.visibilityOfElementLocated(By.linkText("New Customer")));

&nbsp;       getJs().executeScript("arguments\[0].click();", newCustomerLink);



&nbsp;       String url = getDriver().getCurrentUrl();

&nbsp;       Assert.assertTrue(url.contains("addcustomerpage"), "Did not navigate to New Customer page");

&nbsp;   }



&nbsp;   @Test(priority = 6)

&nbsp;   public void logoutTest() {

&nbsp;       WebElement logoutLink = getWait().until(ExpectedConditions.visibilityOfElementLocated(By.linkText("Log out")));

&nbsp;       getJs().executeScript("arguments\[0].click();", logoutLink);



&nbsp;       getDriver().switchTo().alert().accept(); // Accept logout confirmation



&nbsp;       String title = getDriver().getTitle();

&nbsp;       Assert.assertTrue(title.contains("Guru99 Bank"), "Logout failed or not redirected to login page");

&nbsp;   }



&nbsp;   @AfterClass

&nbsp;   public void teardown() {

&nbsp;       if (getDriver() != null) {

&nbsp;           getDriver().quit();

&nbsp;           tlDriver.remove();

&nbsp;           tlWait.remove();

&nbsp;           tlJs.remove();

&nbsp;       }

&nbsp;   }

}





**pom.xml**



<project xmlns="http://maven.apache.org/POM/4.0.0"

&nbsp;        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"

&nbsp;        xsi:schemaLocation="http://maven.apache.org/POM/4.0.0

&nbsp;        http://maven.apache.org/xsd/maven-4.0.0.xsd">

&nbsp;   <modelVersion>4.0.0</modelVersion>



&nbsp;   <groupId>com.demo</groupId>

&nbsp;   <artifactId>ci-tests</artifactId>

&nbsp;   <version>1.0-SNAPSHOT</version>



&nbsp;   <properties>

&nbsp;       <maven.compiler.source>17</maven.compiler.source>

&nbsp;       <maven.compiler.target>17</maven.compiler.target>

&nbsp;   </properties>



&nbsp;   <dependencies>

&nbsp;       <!-- Selenium WebDriver -->

&nbsp;       <dependency>

&nbsp;           <groupId>org.seleniumhq.selenium</groupId>

&nbsp;           <artifactId>selenium-java</artifactId>

&nbsp;           <version>4.20.0</version>

&nbsp;       </dependency>



&nbsp;       <!-- Selenium DevTools v124 -->

&nbsp;       <dependency>

&nbsp;           <groupId>org.seleniumhq.selenium</groupId>

&nbsp;           <artifactId>selenium-devtools-v124</artifactId>

&nbsp;           <version>4.20.0</version>

&nbsp;       </dependency>



&nbsp;       <!-- WebDriverManager -->

&nbsp;       <dependency>

&nbsp;           <groupId>io.github.bonigarcia</groupId>

&nbsp;           <artifactId>webdrivermanager</artifactId>

&nbsp;           <version>5.5.0</version>

&nbsp;       </dependency>



&nbsp;       <!-- TestNG -->

&nbsp;       <dependency>

&nbsp;           <groupId>org.testng</groupId>

&nbsp;           <artifactId>testng</artifactId>

&nbsp;           <version>7.9.0</version>

&nbsp;           <scope>test</scope>

&nbsp;       </dependency>



&nbsp;       <!-- Apache Commons IO -->

&nbsp;       <dependency>

&nbsp;           <groupId>commons-io</groupId>

&nbsp;           <artifactId>commons-io</artifactId>

&nbsp;           <version>2.13.0</version>

&nbsp;       </dependency>



&nbsp;       <!-- SLF4J Simple Logger -->

&nbsp;       <dependency>

&nbsp;           <groupId>org.slf4j</groupId>

&nbsp;           <artifactId>slf4j-simple</artifactId>

&nbsp;           <version>2.0.7</version>

&nbsp;       </dependency>



&nbsp;       <!-- RestAssured for API Testing -->

&nbsp;       <dependency>

&nbsp;           <groupId>io.rest-assured</groupId>

&nbsp;           <artifactId>rest-assured</artifactId>

&nbsp;           <version>5.3.2</version>

&nbsp;           <scope>test</scope>

&nbsp;       </dependency>



&nbsp;       <!-- Hamcrest for Assertions -->

&nbsp;       <dependency>

&nbsp;           <groupId>org.hamcrest</groupId>

&nbsp;           <artifactId>hamcrest</artifactId>

&nbsp;           <version>2.2</version>

&nbsp;           <scope>test</scope>

&nbsp;       </dependency>



&nbsp;   </dependencies>



&nbsp;   <build>

&nbsp;       <plugins>

&nbsp;       <plugin>

&nbsp;           <groupId>org.apache.maven.plugins</groupId>

&nbsp;           <artifactId>maven-surefire-plugin</artifactId>

&nbsp;           <version>3.1.2</version>

&nbsp;           <configuration>

&nbsp;               <suiteXmlFiles>

&nbsp;                   <suiteXmlFile>src/test/resources/testng.xml</suiteXmlFile>

&nbsp;               </suiteXmlFiles>

&nbsp;           </configuration>

&nbsp;       </plugin>

&nbsp;   </plugins>

&nbsp;   </build>

</project>





**testing.xml**





<!DOCTYPE suite SYSTEM "https://testng.org/testng-1.0.dtd">

<suite name="RegressionSuite" parallel="tests" thread-count="2">



&nbsp;   <test name="UI\_Tests">

&nbsp;       <packages>

&nbsp;           <package name="com.demo.ui"/>

&nbsp;       </packages>

&nbsp;   </test>



&nbsp;   <test name="API\_Tests">

&nbsp;       <packages>

&nbsp;           <package name="com.demo.api"/>

&nbsp;       </packages>

&nbsp;   </test>



</suite>





