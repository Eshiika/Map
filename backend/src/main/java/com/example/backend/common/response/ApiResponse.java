package com.example.backend.common.response;

import com.example.backend.common.exception.ApiErrorDetail;
import lombok.AllArgsConstructor;
import lombok.Getter;
import org.springframework.http.HttpStatus;

import java.time.LocalDateTime;
import java.util.List;

@Getter
@AllArgsConstructor
public class ApiResponse<T> {
    private boolean success;
    private int status;
    private String message;
    private T data;
    private LocalDateTime timestamp;
    private List<ApiErrorDetail> errors;

    public static ApiResponse<Void> ok() {
        return new ApiResponse<>(true, HttpStatus.OK.value(), HttpStatus.OK.getReasonPhrase(), null, LocalDateTime.now(), null);
    }

    public static <T> ApiResponse<T> ok(T data) {
        return new ApiResponse<>(true, HttpStatus.OK.value(), HttpStatus.OK.getReasonPhrase(), data, LocalDateTime.now(), null);
    }

    public static <T> ApiResponse<T> error(HttpStatus status, List<ApiErrorDetail> errors) {
        return new ApiResponse<>(false, status.value(), status.getReasonPhrase(), null, LocalDateTime.now(), errors);
    }

    public static <T> ApiResponse<T> error(HttpStatus status, String message, List<ApiErrorDetail> errors) {
        return new ApiResponse<>(false, status.value(), message, null, LocalDateTime.now(), errors);
    }
}
