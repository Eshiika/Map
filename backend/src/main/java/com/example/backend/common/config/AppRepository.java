package com.example.backend.common.config;

import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

@Repository
@Transactional(readOnly = true)
@Target(ElementType.TYPE)
@Retention(RetentionPolicy.RUNTIME)
public @interface AppRepository {
}
