package com.example.backend.http.api.city;

import com.example.backend.domain.city.service.CityService;
import com.example.backend.common.response.ApiResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/cities")
@RequiredArgsConstructor
public class CityController {

    private final CityService cityService;

    @GetMapping
    public ApiResponse<List<CityApiResponse>> getCities(
            @RequestParam(required = false) String region,
            @RequestParam(required = false) Integer nbVille,
            @RequestParam(required = false) Integer habitantMin,
            @RequestParam double latitude,
            @RequestParam double longitude,
            @RequestParam(required = false) Double rayon
    ) {
        return ApiResponse.ok(this.cityService.getCities(region, nbVille, habitantMin, latitude, longitude, rayon));
    }

    @GetMapping("/region")
    public ApiResponse<List<String>> getRegions() {
        return ApiResponse.ok(this.cityService.getRegions());
    }
}
