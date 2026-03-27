package com.example.backend.http.api.city;

import com.example.backend.domain.city.service.CityService;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.webmvc.test.autoconfigure.AutoConfigureMockMvc;
import org.springframework.http.MediaType;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.test.web.servlet.MockMvc;

import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest
@AutoConfigureMockMvc
public class CityControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockitoBean
    private CityService cityService;

    @Test
    void getCities_WhenRegionIsValid_ShouldReturn200() throws Exception {
        mockMvc.perform(get("/api/cities")
                        .param("region", "Île-de-France")
                        .param("nbVille", "10")
                        .param("habitantMin", "100000")
                        .param("latitude", "48.8566")
                        .param("longitude", "2.3522")
                        .param("rayon", "40000")
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(content().contentTypeCompatibleWith(MediaType.APPLICATION_JSON))
                .andExpect(jsonPath("$.status").value(200));
    }

    @Test
    void getCities_WhenRegionIsNull_ShouldReturn200() throws Exception {
        mockMvc.perform(get("/api/cities")
                        .param("nbVille", "10")
                        .param("habitantMin", "100000")
                        .param("latitude", "48.8566")
                        .param("longitude", "2.3522")
                        .param("rayon", "40000")
                        .accept(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.status").value(200));
    }


}
