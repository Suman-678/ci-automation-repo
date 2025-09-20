**Guru99Tests.com**





**package com.demo.ui;**



**import io.github.bonigarcia.wdm.WebDriverManager;**

**import org.openqa.selenium.By;**

**import org.openqa.selenium.JavascriptExecutor;**

**import org.openqa.selenium.WebDriver;**

**import org.openqa.selenium.WebElement;**

**import org.openqa.selenium.chrome.ChromeDriver;**

**import org.openqa.selenium.chrome.ChromeOptions;**

**import org.openqa.selenium.support.ui.ExpectedConditions;**

**import org.openqa.selenium.support.ui.WebDriverWait;**

**import org.testng.Assert;**

**import org.testng.annotations.AfterClass;**

**import org.testng.annotations.BeforeClass;**

**import org.testng.annotations.Test;**



**import java.time.Duration;**



**public class Guru99Tests {**



    **WebDriver driver;**

    **WebDriverWait wait;**

    **JavascriptExecutor js;**



    **// Use the valid credentials you have**

    **String managerId = "mngr634899";**

    **String password = "tAhYpyp";**



    **@BeforeClass**

    **public void setup() {**

        **WebDriverManager.chromedriver().setup();**

        **ChromeOptions options = new ChromeOptions();**

        **options.addArguments("--incognito");**

        **driver = new ChromeDriver(options);**

        **driver.manage().window().maximize();**



        **wait = new WebDriverWait(driver, Duration.ofSeconds(15));**

        **driver.manage().timeouts().implicitlyWait(Duration.ofSeconds(5));**



        **js = (JavascriptExecutor) driver;**

    **}**



    **@Test(priority = 1)**

    **public void verifyLoginPageTitle() {**

        **driver.get("https://demo.guru99.com/V4/");**

        **String title = driver.getTitle();**

        **Assert.assertTrue(title.contains("Guru99 Bank"), "Login page title mismatch");**

    **}**



    **@Test(priority = 2)**

    **public void loginTest() {**

        **driver.get("https://demo.guru99.com/V4/");**



        **driver.findElement(By.name("uid")).sendKeys(managerId);**

        **driver.findElement(By.name("password")).sendKeys(password);**

        **driver.findElement(By.name("btnLogin")).click();**



        **WebElement managerIdLabel = wait.until(ExpectedConditions.visibilityOfElementLocated(**

                **By.xpath("//td\[contains(text(),'Manger Id')]")));**

        **Assert.assertTrue(managerIdLabel.isDisplayed(), "Manager ID not found - login may have failed");**

    **}**



    **@Test(priority = 3)**

    **public void createNewCustomerTest() {**

        **WebElement newCustomerLink = wait**

                **.until(ExpectedConditions.visibilityOfElementLocated(By.linkText("New Customer")));**

        **js.executeScript("arguments\[0].click();", newCustomerLink);**



        **wait.until(ExpectedConditions.visibilityOfElementLocated(By.name("name"))).sendKeys("John Doe");**

        **driver.findElement(By.name("rad1")).click(); // Gender**

        **driver.findElement(By.name("dob")).sendKeys("01/01/1990");**

        **driver.findElement(By.name("addr")).sendKeys("123 Main Street");**

        **driver.findElement(By.name("city")).sendKeys("New York");**

        **driver.findElement(By.name("state")).sendKeys("NY");**

        **driver.findElement(By.name("pinno")).sendKeys("123456");**

        **driver.findElement(By.name("telephoneno")).sendKeys("9876543210");**

        **driver.findElement(By.name("emailid")).sendKeys("john" + System.currentTimeMillis() + "@test.com");**

        **driver.findElement(By.name("password")).sendKeys("Password123");**

        **driver.findElement(By.name("sub")).click();**



        **WebElement successMsg = wait.until(ExpectedConditions.visibilityOfElementLocated(**

                **By.xpath("//p\[contains(text(),'Customer Registered Successfully')]")));**

        **Assert.assertTrue(successMsg.isDisplayed(), "Customer creation failed");**

    **}**



    **@Test(priority = 4)**

    **public void resetNewCustomerFormTest() {**

        **WebElement newCustomerLink = wait**

                **.until(ExpectedConditions.visibilityOfElementLocated(By.linkText("New Customer")));**

        **js.executeScript("arguments\[0].click();", newCustomerLink);**



        **WebElement nameField = wait.until(ExpectedConditions.visibilityOfElementLocated(By.name("name")));**

        **nameField.sendKeys("Test Customer");**



        **driver.findElement(By.name("res")).click(); // Reset button**

        **Assert.assertEquals(nameField.getAttribute("value"), "", "Reset did not clear the name field");**

    **}**



    **@Test(priority = 5)**

    **public void verifyHomePageNavigation() {**

        **WebElement newCustomerLink = wait**

                **.until(ExpectedConditions.visibilityOfElementLocated(By.linkText("New Customer")));**

        **js.executeScript("arguments\[0].click();", newCustomerLink);**



        **String url = driver.getCurrentUrl();**

        **Assert.assertTrue(url.contains("addcustomerpage"), "Did not navigate to New Customer page");**

    **}**



    **@Test(priority = 6)**

    **public void logoutTest() {**

        **WebElement logoutLink = wait.until(ExpectedConditions.visibilityOfElementLocated(By.linkText("Log out")));**

        **js.executeScript("arguments\[0].click();", logoutLink);**



        **driver.switchTo().alert().accept(); // Accept logout confirmation**



        **String title = driver.getTitle();**

        **Assert.assertTrue(title.contains("Guru99 Bank"), "Logout failed or not redirected to login page");**

    **}**



    **@AfterClass**

    **public void teardown() {**

        **if (driver != null) {**

            **driver.quit();**

        **}**

    **}**

**}**





**POM.XML**



<project xmlns="http://maven.apache.org/POM/4.0.0"

&nbsp;        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"

&nbsp;        xsi:schemaLocation="http://maven.apache.org/POM/4.0.0

&nbsp;                            http://maven.apache.org/xsd/maven-4.0.0.xsd">



&nbsp;   <modelVersion>4.0.0</modelVersion>

&nbsp;   <groupId>com.demo</groupId>

&nbsp;   <artifactId>guru99-tests</artifactId>

&nbsp;   <version>1.0-SNAPSHOT</version>

&nbsp;   <packaging>jar</packaging>



&nbsp;   <name>Guru99 Selenium TestNG Automation</name>



&nbsp;   <properties>

&nbsp;       <maven.compiler.source>17</maven.compiler.source>

&nbsp;       <maven.compiler.target>17</maven.compiler.target>

&nbsp;       <selenium.version>4.22.0</selenium.version>

&nbsp;       <testng.version>7.8.0</testng.version>

&nbsp;       <webdrivermanager.version>5.5.3</webdrivermanager.version>

&nbsp;   </properties>



&nbsp;   <dependencies>

&nbsp;       <!-- Selenium Java -->

&nbsp;       <dependency>

&nbsp;           <groupId>org.seleniumhq.selenium</groupId>

&nbsp;           <artifactId>selenium-java</artifactId>

&nbsp;           <version>${selenium.version}</version>

&nbsp;       </dependency>



&nbsp;       <!-- TestNG -->

&nbsp;       <dependency>

&nbsp;           <groupId>org.testng</groupId>

&nbsp;           <artifactId>testng</artifactId>

&nbsp;           <version>${testng.version}</version>

&nbsp;           <scope>test</scope>

&nbsp;       </dependency>



&nbsp;       <!-- WebDriverManager -->

&nbsp;       <dependency>

&nbsp;           <groupId>io.github.bonigarcia</groupId>

&nbsp;           <artifactId>webdrivermanager</artifactId>

&nbsp;           <version>${webdrivermanager.version}</version>

&nbsp;       </dependency>



&nbsp;       <!-- SLF4J (optional, avoids warning messages) -->

&nbsp;       <dependency>

&nbsp;           <groupId>org.slf4j</groupId>

&nbsp;           <artifactId>slf4j-api</artifactId>

&nbsp;           <version>2.0.7</version>

&nbsp;       </dependency>

&nbsp;       <dependency>

&nbsp;           <groupId>org.slf4j</groupId>

&nbsp;           <artifactId>slf4j-simple</artifactId>

&nbsp;           <version>2.0.7</version>

&nbsp;       </dependency>



&nbsp;       <!-- RestAssured (for API tests) -->

&nbsp;       <dependency>

&nbsp;           <groupId>io.rest-assured</groupId>

&nbsp;           <artifactId>rest-assured</artifactId>

&nbsp;           <version>5.3.2</version>

&nbsp;           <scope>test</scope>

&nbsp;       </dependency>

&nbsp;   </dependencies>



&nbsp;   <build>

&nbsp;       <plugins>

&nbsp;           <!-- Compiler plugin -->

&nbsp;           <plugin>

&nbsp;               <groupId>org.apache.maven.plugins</groupId>

&nbsp;               <artifactId>maven-compiler-plugin</artifactId>

&nbsp;               <version>3.13.0</version>

&nbsp;               <configuration>

&nbsp;                   <source>${maven.compiler.source}</source>

&nbsp;                   <target>${maven.compiler.target}</target>

&nbsp;               </configuration>

&nbsp;           </plugin>



&nbsp;           <!-- Surefire plugin for TestNG -->

&nbsp;           <plugin>

&nbsp;               <groupId>org.apache.maven.plugins</groupId>

&nbsp;               <artifactId>maven-surefire-plugin</artifactId>

&nbsp;               <version>3.2.5</version>

&nbsp;               <configuration>

&nbsp;                   <suiteXmlFiles>

&nbsp;                       <suiteXmlFile>src/test/resources/testng.xml</suiteXmlFile>

&nbsp;                   </suiteXmlFiles>

&nbsp;               </configuration>

&nbsp;           </plugin>

&nbsp;       </plugins>

&nbsp;   </build>

</project>





**TESTNG.XML**



<?xml version="1.0" encoding="UTF-8"?>

<!DOCTYPE suite SYSTEM "https://testng.org/testng-1.0.dtd">

<suite name="Guru99 Automation Suite" verbose="1" parallel="false">



&nbsp;   <test name="Guru99 Tests">

&nbsp;       <classes>

&nbsp;           <class name="com.demo.ui.Guru99Tests"/>

&nbsp;       </classes>

&nbsp;   </test>



</suite>

















