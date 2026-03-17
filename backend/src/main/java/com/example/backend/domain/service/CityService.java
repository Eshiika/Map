package com.example.backend.domain.service;

import com.example.backend.domain.City;
import com.example.backend.domain.repository.CityRepository;
import lombok.AllArgsConstructor;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@AllArgsConstructor
public class CityService {

    private final CityRepository cityRepository;

    public List<City> getCities(String region, Integer nbVille, Integer habitantMin, Double latitude, Double longitude, Double rayon) {
        int nbVilleValue = (nbVille != null) ? nbVille : 10;
        int habitantMinValue = (habitantMin != null) ? habitantMin : 0;
        double rayonValue = (rayon != null) ? rayon : 40000.0;

        Pageable pageable = PageRequest.of(0, nbVilleValue);
        return cityRepository.getCities(region, pageable, habitantMinValue, latitude, longitude, rayonValue)
                .stream().toList();
    }

    public List<String> getRegions() {
        return cityRepository.getRegion();
    }
}
