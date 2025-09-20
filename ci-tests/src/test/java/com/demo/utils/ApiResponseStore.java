package com.demo.utils;

public class ApiResponseStore {
    private static final ThreadLocal<String> responseHolder = new ThreadLocal<>();

    public static void setResponse(String response) {
        responseHolder.set(response);
    }

    public static String getResponse() {
        return responseHolder.get();
    }

    public static void clear() {
        responseHolder.remove();
    }
}
