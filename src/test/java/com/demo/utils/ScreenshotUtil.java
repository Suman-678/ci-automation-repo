package com.demo.utils;

import org.openqa.selenium.OutputType;
import org.openqa.selenium.TakesScreenshot;
import org.openqa.selenium.WebDriver;

import java.io.File;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.text.SimpleDateFormat;
import java.util.Date;

public class ScreenshotUtil {

    public static String captureScreenshot(WebDriver driver, String testName) {
        try {
            File srcFile = ((TakesScreenshot) driver).getScreenshotAs(OutputType.FILE);
            String destDir = System.getProperty("user.dir") + "/screenshots";
            Files.createDirectories(Paths.get(destDir));
            String timestamp = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());
            String destPath = destDir + "/" + testName + "_" + timestamp + ".png";
            Files.copy(srcFile.toPath(), Paths.get(destPath));
            System.out.println("Screenshot saved: " + destPath);
            return destPath;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}
