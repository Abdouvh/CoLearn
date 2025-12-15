package co.learn.app.repositories;

import co.learn.app.entities.Module;
import org.springframework.data.jpa.repository.JpaRepository;

/**
 * Interface d'accès aux données pour les modules de cours.
 */
public interface ModuleRepository extends JpaRepository<Module, Long> {
}