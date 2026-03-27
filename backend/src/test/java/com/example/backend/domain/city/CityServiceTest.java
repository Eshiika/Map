package com.example.backend.domain.city;

import com.example.backend.domain.city.dto.CityDTO;
import com.example.backend.domain.city.repository.CityRepository;
import com.example.backend.domain.city.service.CityService;
import com.example.backend.http.api.city.CityApiResponse;
import com.example.backend.http.api.city.CityMapper;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.Pageable;

import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class CityServiceTest {

    @Mock
    private CityRepository cityRepository;

    @Mock
    private CityMapper cityMapper;

    @InjectMocks
    private CityService cityService;

    @Test
    void shouldReturnCitiesWithDefaultValuesWhenParamsAreNull() {
        CityDTO cityDto = mock(CityDTO.class);

        CityApiResponse response = new CityApiResponse(
                1L,
                "Paris",
                48.8566,
                2.3522,
                2148271L,
                "Île-de-France"
        );

        when(cityRepository.getCities(
                eq(null),
                any(Pageable.class),
                eq(0),
                eq(48.8566),
                eq(2.3522),
                eq(40000.0)
        )).thenReturn(List.of(cityDto));

        when(cityMapper.toCityApiResponse(cityDto)).thenReturn(response);

        List<CityApiResponse> result = cityService.getCities(
                null,
                null,
                null,
                48.8566,
                2.3522,
                null
        );

        assertEquals(1, result.size());
        assertEquals("Paris", result.get(0).name());
        assertEquals("Île-de-France", result.get(0).region());

        verify(cityRepository).getCities(
                eq(null),
                any(Pageable.class),
                eq(0),
                eq(48.8566),
                eq(2.3522),
                eq(40000.0)
        );
        verify(cityMapper).toCityApiResponse(cityDto);
    }

    @Test
    void shouldReturnCitiesWithProvidedValues() {
        CityDTO cityDto = mock(CityDTO.class);

        CityApiResponse response = new CityApiResponse(
                1L,
                "Paris",
                48.8566,
                2.3522,
                2148271L,
                "Île-de-France"
        );

        when(cityRepository.getCities(
                eq("Île-de-France"),
                any(Pageable.class),
                eq(100000),
                eq(48.8566),
                eq(2.3522),
                eq(15000.0)
        )).thenReturn(List.of(cityDto));

        when(cityMapper.toCityApiResponse(cityDto)).thenReturn(response);

        List<CityApiResponse> result = cityService.getCities(
                "Île-de-France",
                5,
                100000,
                48.8566,
                2.3522,
                15000.0
        );

        assertEquals(1, result.size());
        assertEquals("Paris", result.get(0).name());

        verify(cityRepository).getCities(
                eq("Île-de-France"),
                any(Pageable.class),
                eq(100000),
                eq(48.8566),
                eq(2.3522),
                eq(15000.0)
        );
        verify(cityMapper).toCityApiResponse(cityDto);
    }
}