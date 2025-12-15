package co.learn.app.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.web.SecurityFilterChain;

/**
 * Configuration de sécurité Spring Security.
 * <p>
 * Définit la chaîne de filtres de sécurité, désactive CSRF pour les API REST,
 * et configure les accès publics pour les endpoints d'authentification.
 */
@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
                .csrf(AbstractHttpConfigurer::disable)
                .authorizeHttpRequests(authz -> authz
                        .requestMatchers("/register", "/login", "/forgot-password", "/verify-reset-code",
                                "/confirm-reset-password", "/oauth/**")
                        .permitAll()
                        .anyRequest().permitAll());

        return http.build();
    }
}
