package com.example.backend.http.api;

import lombok.Getter;

@Getter
public class ApiErrorDetail {
    private String field;
    private String code;
    private String message;
    private Object rejectedValue;
    private Object[] args;

    // Simply constructeur for common errors
    public ApiErrorDetail(String code, String message) {
        this.code = code;
        this.message = message;
    }

    // Constructeur for validation errors
    public ApiErrorDetail(String field, String code, String message, Object rejectedValue) {
        this.field = field;
        this.code = code;
        this.message = message;
        this.rejectedValue = rejectedValue;
    }

    // Constructeur for errors with arguments
    public ApiErrorDetail(String code, String message, Object... args) {
        this.code = code;
        this.message = message;
        this.args = args;
    }
}
