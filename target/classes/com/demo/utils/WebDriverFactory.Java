package com.demo.utils;

import io.github.bonigarcia.wdm.WebDriverManager;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;

public class WebDriverFactory {

    private static ThreadLocal<WebDriver> driver = new ThreadLocal<>();

    // Initialize WebDriver
    public static void initDriver() {
        WebDriverManager.chromedriver().setup();
        driver.set(new ChromeDriver());
        driver.get().manage().window().maximize();
    }

    // Get current driver
    public static WebDriver getDriver() {
        return driver.get();
    }

    // Quit driver
    public static void quitDriver() {
        if (driver.get() != null) {
            driver.get().quit();
            driver.remove();
        }
    }
}
