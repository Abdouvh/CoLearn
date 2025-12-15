package co.learn.app.entities;

import jakarta.persistence.*;
import lombok.Data;
import java.time.Instant;

/**
 * Entité stockant les codes de réinitialisation de mot de passe.
 * <p>
 * Ces codes ont une durée de vie limitée et sont invalidés après utilisation.
 */
@Entity
@Table(name = "password_reset_codes")
@Data
public class PasswordResetCode {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String email;

    @Column(nullable = false, length = 6)
    private String code; // 6-digit numeric code

    @Column(nullable = false)
    private Instant expiresAt;

    @Column(nullable = false)
    private boolean used = false;
}
