package co.learn.app.repositories;

import co.learn.app.entities.User;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;

/**
 * Interface d'accès aux données pour les utilisateurs.
 * <p>
 * Inclut la récupération du top 10 par XP.
 */
public interface UserRepository extends JpaRepository<User, Long> {
    Optional<User> findByEmail(String email);

    java.util.List<User> findTop10ByOrderByXpDesc();
}