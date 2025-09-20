package com.demo.ui;

import io.github.bonigarcia.wdm.WebDriverManager;
import io.qameta.allure.Description;
import org.openqa.selenium.*;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;
import org.openqa.selenium.support.ui.*;
import org.testng.Assert;
import org.testng.annotations.*;

import java.time.Duration;

public class Guru99Tests {

    private static ThreadLocal<WebDriver> tlDriver = new ThreadLocal<>();
    private static ThreadLocal<WebDriverWait> tlWait = new ThreadLocal<>();
    private static ThreadLocal<JavascriptExecutor> tlJs = new ThreadLocal<>();

    String managerId = "mngr634899";
    String password = "tAhYpyp";

    public WebDriver getDriver() {
        return tlDriver.get();
    }

    private WebDriverWait getWait() {
        return tlWait.get();
    }

    private JavascriptExecutor getJs() {
        return tlJs.get();
    }

    @BeforeClass
    public void setup() {
        WebDriverManager.chromedriver().setup();
        ChromeOptions options = new ChromeOptions();
        options.addArguments("--incognito");
        WebDriver driver = new ChromeDriver(options);
        driver.manage().window().maximize();
        tlDriver.set(driver);
        tlWait.set(new WebDriverWait(driver, Duration.ofSeconds(15)));
        driver.manage().timeouts().implicitlyWait(Duration.ofSeconds(5));
        tlJs.set((JavascriptExecutor) driver);
    }

    @Test(priority = 1)
    @Description("Verify login page title")
    public void verifyLoginPageTitle() {
        getDriver().get("https://demo.guru99.com/V4");
        String title = getDriver().getTitle();
        Assert.assertTrue(title.contains("Guru99 Bank"), "Login page title mismatch");
    }

    @Test(priority = 2)
    @Description("Login to Guru99 Bank")
    public void loginTest() {
        getDriver().get("https://demo.guru99.com/V4");
        getDriver().findElement(By.name("uid")).sendKeys(managerId);
        getDriver().findElement(By.name("password")).sendKeys(password);
        getDriver().findElement(By.name("btnLogin")).click();

        WebElement managerIdLabel = getWait()
                .until(ExpectedConditions.visibilityOfElementLocated(By.xpath("//td[contains(text(),'Manger Id')]")));
        Assert.assertTrue(managerIdLabel.isDisplayed(), "Manager ID not found - login may have failed");
    }

    // Add other test methods following the above pattern...

    @AfterClass
    public void teardown() {
        if (getDriver() != null) {
            getDriver().quit();
        }
        tlDriver.remove();
        tlWait.remove();
        tlJs.remove();
    }
}
